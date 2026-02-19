<?php

namespace App\Services;

use App\Models\Product;
use App\Models\StockTransfer;
use App\Models\Store;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class ReplenishmentService
{
    /**
     * Allocate stock from Source Store (DC) to Target Store (Branch).
     */
    public function allocateStock(int $sourceStoreId, int $targetStoreId, array $items): StockTransfer
    {
        return DB::transaction(function () use ($sourceStoreId, $targetStoreId, $items) {
            // 1. Create Stock Transfer Record
            $transfer = StockTransfer::create([
                'source_store_id' => $sourceStoreId,
                'target_store_id' => $targetStoreId,
                'user_id' => auth()->id() ?? 1,
                'transfer_number' => 'ALOC-' . strtoupper(Str::random(8)),
                'status' => 'pending',
                'notes' => 'Strategic branch allocation (Replenishment).'
            ]);

            foreach ($items as $item) {
                // 2. Validate Source Stock
                $sourceProduct = Product::where('id', $item['id'])
                    ->where('store_id', $sourceStoreId)
                    ->lockForUpdate()
                    ->firstOrFail();

                if ($sourceProduct->stock < $item['quantity']) {
                    throw new \Exception("Insufficient stock in DC for product: {$sourceProduct->name}");
                }

                // 3. Create Transfer Item
                $transfer->items()->create([
                    'product_id' => $item['id'],
                    'quantity' => $item['quantity']
                ]);

                // 4. Deduct from Source
                $sourceProduct->decrement('stock', $item['quantity']);
            }

            return $transfer;
        });
    }

    /**
     * Re-calculate suggested replenishment for all branches based on min_stock.
     */
    public function getRecommendations(int $storeId): array
    {
        return Product::where('store_id', $storeId)
            ->whereColumn('stock', '<', 'min_stock')
            ->get()
            ->map(function($product) {
                return [
                    'product_id' => $product->id,
                    'name' => $product->name,
                    'current_stock' => $product->stock,
                    'min_stock' => $product->min_stock,
                    'suggested_replenishment' => $product->suggested_order_qty
                ];
            })
            ->toArray();
    }
}
