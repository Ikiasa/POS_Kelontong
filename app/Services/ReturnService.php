<?php

namespace App\Services;

use App\Models\Transaction;
use App\Models\ReturnTransaction;
use App\Models\ReturnItem;
use App\Models\Product;
use App\Enums\StockMovementType;
use App\Services\StockMovementService;
use App\Services\JournalService;
use Illuminate\Support\Facades\DB;
use Exception;
use Illuminate\Support\Str;

class ReturnService
{
    public function __construct(
        protected StockMovementService $stockService,
        protected JournalService $journalService
    ) {}

    /**
     * Process a product return atomically.
     */
    public function processReturn(array $data, int $storeId, int $userId): ReturnTransaction
    {
        return DB::transaction(function () use ($data, $storeId, $userId) {
            $transactionId = $data['transaction_id'];
            $reason = $data['reason'] ?? 'Customer Return';
            
            // 1. Fetch & Lock Original Transaction
            $originalTransaction = Transaction::where('id', $transactionId)
                ->where('store_id', $storeId)
                ->lockForUpdate()
                ->firstOrFail();

            if ($originalTransaction->status === 'returned') {
                throw new Exception("This transaction has already been fully returned.");
            }

            $totalRefund = 0;
            $returnItems = [];

            // 2. Process each return item
            foreach ($data['items'] as $item) {
                $productId = $item['product_id'];
                $quantityToReturn = $item['quantity'];

                // A. Validate against original line item
                $originalItem = $originalTransaction->items()
                    ->where('product_id', $productId)
                    ->first();

                if (!$originalItem) {
                    throw new Exception("Product #{$productId} was not part of original transaction.");
                }

                // B. Calculate already returned quantity
                $alreadyReturned = ReturnItem::whereHas('returnTransaction', function($q) use ($transactionId) {
                        $q->where('transaction_id', $transactionId);
                    })
                    ->where('product_id', $productId)
                    ->sum('quantity');

                if ($alreadyReturned + $quantityToReturn > $originalItem->quantity) {
                    throw new Exception("Cannot return more than originally purchased for Product #{$productId}.");
                }

                // C. Restore Stock safely
                // [FEFO FIX] Restore to original batch if known
                $originalBatchId = $originalItem->batch_id; 

                if ($originalBatchId) {
                    // Try to find the batch and restore it
                    $batch = \App\Models\ProductBatch::find($originalBatchId);
                    if ($batch) {
                        $batch->increment('current_quantity', $quantityToReturn);
                    } else {
                        // If batch deleted, maybe create a new "Restored" batch or just dump in general stock?
                        // For now, general stock update handles the aggregate. 
                        // But we want to preserve batch info if possible.
                    }
                }

                $this->stockService->recordMovement(
                    $storeId,
                    $productId,
                    $quantityToReturn,
                    StockMovementType::RETURN,
                    $transactionId, // Reference the original sale
                    "Return from Invoice {$originalTransaction->invoice_number}: {$reason}",
                    $userId,
                    $originalBatchId // [NEW] Link to batch
                );

                $refundAmount = $originalItem->price * $quantityToReturn;
                $totalRefund += $refundAmount;

                $returnItems[] = [
                    'product_id' => $productId,
                    'quantity' => $quantityToReturn,
                    'refund_price' => $originalItem->price
                ];
            }

            // 3. Create Return Transaction Log
            $returnTx = ReturnTransaction::create([
                'id' => (string) Str::uuid(),
                'transaction_id' => $transactionId,
                'store_id' => $storeId,
                'user_id' => $userId,
                'total_refunded' => $totalRefund,
                'payment_method' => $data['refund_method'] ?? 'cash',
                'reason' => $reason
            ]);

            // 4. Create Return Items
            foreach ($returnItems as $itemData) {
                $returnTx->items()->create($itemData);
            }

            // 5. Update Original Transaction Status if fully returned
            $totalOrdered = $originalTransaction->items()->sum('quantity');
            $totalReturnedSoFar = ReturnItem::whereHas('returnTransaction', function($q) use ($transactionId) {
                    $q->where('transaction_id', $transactionId);
                })->sum('quantity');

            if ($totalReturnedSoFar >= $totalOrdered) {
                $originalTransaction->status = 'returned';
                $originalTransaction->save();
            } else {
                $originalTransaction->status = 'partial_return';
                $originalTransaction->save();
            }

            // 6. Record Financial Impact (Journal)
            $this->journalService->recordReturnJournal(
                $storeId,
                $originalTransaction->invoice_number,
                $totalRefund,
                $data['refund_method'] ?? 'cash'
            );

            return $returnTx;
        });
    }
}
