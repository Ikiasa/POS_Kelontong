<?php

namespace App\Services;

use App\Models\Product;
use App\Models\StockMovement;
use Illuminate\Support\Facades\DB;
use Exception;

class StockMovementService
{
    /**
     * Record a stock movement.
     * This is the ONLY way stock should be modified.
     */
    public function recordMovement(
        int $storeId,
        int $productId,
        int $quantityChange,
        \App\Enums\StockMovementType $type, // Formal Enum
        string $referenceType,
        string $referenceId,
        ?string $notes = null,
        ?int $userId = null,
        ?string $batchId = null // [NEW] Optional Batch ID
    ): StockMovement {
        return DB::transaction(function () use ($storeId, $productId, $quantityChange, $type, $referenceType, $referenceId, $notes, $userId, $batchId) {
            
            // 1. Lock Row
            $product = Product::where('id', $productId)
                ->where('store_id', $storeId)
                ->lockForUpdate()
                ->firstOrFail();

            // 2. Snapshots
            $beforeStock = $product->stock;

            // 3. Validation
            if ($beforeStock + $quantityChange < 0 && !config('pos.allow_negative_stock', false)) {
                throw new \App\Exceptions\InsufficientStockException($product->name, $beforeStock, abs($quantityChange));
            }

            // 4. Atomic Math
            if ($quantityChange < 0) {
                $product->decrement('stock', abs($quantityChange));
            } else {
                $product->increment('stock', $quantityChange);
            }
            
            $product->refresh();
            $afterStock = $product->stock;

            // 5. Audit Log
            $movement = StockMovement::create([
                'store_id' => $storeId,
                'product_id' => $productId,
                'batch_id' => $batchId, // [NEW]
                'user_id' => $userId ?? auth()->id(),
                'type' => $type,
                'reference_type' => $referenceType,
                'reference_id' => $referenceId,
                'quantity' => $quantityChange,
                'before_stock' => $beforeStock,
                'after_stock' => $afterStock,
                'notes' => $notes,
                'created_at' => now(),
            ]);
            
            return $movement;
        });
    }

    /**
     * Recalculate stock from movements in case of suspected corruption.
     */
    public function recalculateStock(int $productId): void
    {
        DB::transaction(function () use ($productId) {
            $product = Product::lockForUpdate()->find($productId);
            
            $calculatedStock = StockMovement::where('product_id', $productId)
                ->sum('quantity_change');
            
            if ($product->stock !== $calculatedStock) {
                // Log discrepancy?
                $product->stock = $calculatedStock;
                $product->save();
            }
        });
    }
}
