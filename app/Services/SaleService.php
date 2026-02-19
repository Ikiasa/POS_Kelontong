<?php

namespace App\Services;

use App\Models\Customer;
use App\Models\Product; // [FIX] Missing Import
use App\Models\Transaction;
use App\Models\TransactionItem;
use App\Services\StockMovementService;
use App\Services\JournalService;
use App\Services\LoyaltyService;
use App\Services\WhatsAppService;
use App\Services\FraudDetectionService;
use App\Services\BatchService; // [NEW]
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Exception;

class SaleService
{
    public function __construct(
        protected StockMovementService $stockService,
        protected JournalService $journalService,
        protected LoyaltyService $loyaltyService,
        protected WhatsAppService $whatsappService,
        protected FraudDetectionService $fraudService,
        protected BatchService $batchService,
        protected PaymentService $paymentService
    ) {}

    /**
     * Process a new sale transaction atomically.
     */
    public function createSale(array $data, int $storeId, int $userId): Transaction
    {
        return DB::transaction(function () use ($data, $storeId, $userId) {
            
            // 1. Generate Invoice Number
            $lastInvoice = Transaction::where('store_id', $storeId)
                ->whereDate('created_at', now())
                ->lockForUpdate()
                ->latest()
                ->first();
                
            $nextNum = $lastInvoice ? intval(substr($lastInvoice->invoice_number, -4)) + 1 : 1;
            $invoiceNumber = 'INV-' . date('ymd') . '-' . str_pad($nextNum, 4, '0', STR_PAD_LEFT);

            // Loyalty Logic
            $customerId = $data['customer_id'] ?? null;
            $redeemPoints = $data['redeem_points'] ?? 0;
            $pointsEarned = 0;
            $customer = null;

            if ($customerId) {
                $customer = Customer::find($customerId);
                if (!$customer) throw new Exception("Customer not found.");
            }

            $grandTotal = $data['totals']['grandTotal'];
            
            if ($customer && $redeemPoints > 0) {
                if ($customer->points_balance < $redeemPoints) {
                    throw new Exception("Insufficient points.");
                }
                $this->loyaltyService->redeemPoints($customer, $redeemPoints, $invoiceNumber);
            }

            if ($customer) {
                $pointsEarned = $this->loyaltyService->calculatePointsEarned($grandTotal);
            }

            // 2. Create Transaction Header
            $transaction = Transaction::create([
                'id' => Str::uuid(),
                'store_id' => $storeId,
                'user_id' => $userId,
                'customer_id' => $customerId,
                'invoice_number' => $invoiceNumber,
                'subtotal' => $data['totals']['subtotal'],
                'tax' => $data['totals']['tax'] ?? 0,
                'service_charge' => $data['totals']['serviceCharge'] ?? 0,
                'discount' => $data['totals']['discount'] ?? 0,
                'grand_total' => $grandTotal,
                'points_earned' => $pointsEarned,
                'points_redeemed' => $redeemPoints,
                'payment_method' => $data['payment']['method'], // 'split' if multiple
                'cash_received' => $data['payment']['cashReceived'] ?? null,
                'change_amount' => $data['payment']['change'] ?? null,
                'status' => 'completed',
                'transaction_date' => now(),
                'created_at' => $data['timestamp'] ?? now(),
            ]);

            // 2a. Process Detailed Payments
            if (isset($data['payment']['items'])) {
                $this->paymentService->processPayments($transaction, $data['payment']['items']);
            } else {
                // Single payment fallback
                $this->paymentService->processPayments($transaction, [[
                    'method' => $data['payment']['method'],
                    'amount' => $grandTotal,
                    'reference_number' => $data['payment']['reference'] ?? null,
                ]]);
            }

                // 3. Process Items & Deduct Stock
                $totalCost = 0;
                foreach ($data['items'] as $item) {
                    \Log::info("Processing item #{$item['id']} for Store #$storeId");
                    
                    // A. Fetch current product state with lock
                    $product = Product::where('id', $item['id'])->lockForUpdate()->first();
                    if (!$product) throw new Exception("Product #{$item['id']} not found.");
                    
                    $itemStoreId = $product->store_id;

                    // B. Deduct Stock from Batches
                    try {
                        $affectedBatches = $this->batchService->deductStock($itemStoreId, $item['id'], $item['quantity']);
                    } catch (\Exception $e) {
                        \Log::warning("Batch deduction failed for product #{$item['id']}: " . $e->getMessage());
                        // Fallback: If no batches exist (migration period), we still need to record movement
                        $affectedBatches = [];
                    }
                    
                    $itemCost = 0;
                    $batchInfo = [];
                    
                    // If batches were affected, record movement per batch
                    if (!empty($affectedBatches)) {
                        foreach($affectedBatches as $batch) {
                            $itemCost += $batch['total_cost'];
                            $batchInfo[] = $batch['batch_number'] . '(' . $batch['quantity'] . ')';

                            $this->stockService->recordMovement(
                                $itemStoreId,
                                $item['id'],
                                -$batch['quantity'],
                                \App\Enums\StockMovementType::SALE,
                                'sale',
                                $transaction->id, 
                                "Sale #$invoiceNumber (Batch: {$batch['batch_number']})",
                                $userId,
                                $batch['batch_id'] // [NEW] Pass Batch ID
                            );
                        }
                    } 
                    // Fallback: No batches found, deduct from main stock generic
                    else {
                        $itemCost = $product->cost_price * $item['quantity'];
                         $this->stockService->recordMovement(
                            $itemStoreId,
                            $item['id'],
                            -$item['quantity'],
                            \App\Enums\StockMovementType::SALE, // Formal Enum
                            'sale',
                            $transaction->id, 
                            "Sale #$invoiceNumber (No Batch)",
                            $userId
                        );
                    }
                    
                    $totalCost += $itemCost;

                    // C. Create Transaction Item
                    $avgCost = $item['quantity'] > 0 ? $itemCost / $item['quantity'] : 0;
                    TransactionItem::create([
                        'transaction_id' => $transaction->id,
                        'product_id' => $item['id'],
                        'batch_id' => !empty($affectedBatches) ? $affectedBatches[0]['batch_id'] : null, // Link primarily to first batch for now (refinement: split items if multi-batch)
                        'product_name' => $item['name'],
                        'price' => $item['price'],
                        'cost_price' => $avgCost,
                        'quantity' => $item['quantity'],
                        'total' => $item['price'] * $item['quantity'],
                    ]);
                }

            // 4. Add Points Earned
            if ($customer && $pointsEarned > 0) {
                $this->loyaltyService->addPoints($customer, $pointsEarned, $transaction->id, "Earned from $invoiceNumber");
            }

            // 4a. Record Journal Entry
            $this->journalService->recordSaleJournal(
                $storeId,
                $invoiceNumber,
                $data['totals']['subtotal'],
                $totalCost,
                $data['totals']['tax'] ?? 0,
                $data['totals']['serviceCharge'] ?? 0,
                $data['payment']['items'] ?? [[
                    'method' => $data['payment']['method'],
                    'amount' => $grandTotal
                ]]
            );

            // 5. Send WhatsApp Receipt
            if ($customer && $customer->phone) {
                try {
                    $pdfUrl = route('receipt.download', $transaction->id); 
                    $this->whatsappService->sendReceipt($customer->phone, $invoiceNumber, $grandTotal, $pdfUrl);
                } catch (\Exception $e) { }
            }

            // 6. Check Fraud
            $this->fraudService->checkTransaction($transaction->refresh()->load('items'));
            
            \Log::info("Sale Transaction Committed Successfully: {$transaction->invoice_number}");
            return $transaction;
        });
    }
}
