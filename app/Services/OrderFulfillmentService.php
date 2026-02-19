<?php

namespace App\Services;

use App\Models\Transaction;
use App\Models\Product;
use Illuminate\Support\Facades\DB;

class OrderFulfillmentService
{
    /**
     * Convert an external Sales Order (SO) to a POS Transaction for fulfillment.
     */
    public function fulfillOrder(array $soData, int $storeId, int $userId): Transaction
    {
        return DB::transaction(function () use ($soData, $storeId, $userId) {
            // 1. Verify Stock Availability (Soft-Allocation)
            foreach ($soData['items'] as $item) {
                $product = Product::where('id', $item['id'])
                    ->where('store_id', $storeId)
                    ->lockForUpdate()
                    ->firstOrFail();

                if ($product->stock < $item['quantity']) {
                    throw new \Exception("Stock fulfillment gap for {$product->name}");
                }
            }

            // 2. Delegate to SaleService for actual processing
            // This ensures all Journal, StockMovement, and Tax logic is applied consistently
            $saleService = app(SaleService::class);
            
            $payload = [
                'client_uuid' => \Illuminate\Support\Str::uuid(),
                'customer_id' => $soData['customer_id'] ?? null,
                'items' => $soData['items'],
                'totals' => $soData['totals'],
                'payment' => [
                    'method' => 'DEBT', // SOs are usually on-account
                    'cashReceived' => 0,
                    'change' => 0,
                    'items' => [[
                        'method' => 'DEBT',
                        'amount' => $soData['totals']['grandTotal']
                    ]]
                ],
                'status' => 'shipped', // Fulfillment status
                'metadata' => [
                    'source' => 'fulfillment',
                    'external_so_id' => $soData['external_id']
                ]
            ];

            return $saleService->createSale($payload, $storeId, $userId);
        });
    }
}
