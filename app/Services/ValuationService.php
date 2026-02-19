<?php

namespace App\Services;

use App\Models\InventoryValuation;
use App\Models\ProductBatch;
use Illuminate\Support\Facades\DB;

class ValuationService
{
    /**
     * Calculate current inventory value based on FIFO cost.
     */
    public function calculateCurrentValuation(int $storeId): InventoryValuation
    {
        // Sum (current_quantity * cost_price) for all active batches
        $totalValue = ProductBatch::where('store_id', $storeId)
            ->where('current_quantity', '>', 0)
            ->sum(DB::raw('current_quantity * cost_price'));

        $totalItems = ProductBatch::where('store_id', $storeId)
            ->where('current_quantity', '>', 0)
            ->sum('current_quantity');

        return InventoryValuation::create([
            'store_id' => $storeId,
            'total_value' => $totalValue,
            'total_items' => $totalItems,
            'valuation_date' => now(),
        ]);
    }

    /**
     * Get Average Cost for a product.
     */
    public function getAverageCost(int $storeId, int $productId): float
    {
        $totalValue = ProductBatch::where('store_id', $storeId)
            ->where('product_id', $productId)
            ->where('current_quantity', '>', 0)
            ->sum(DB::raw('current_quantity * cost_price'));

        $totalQty = ProductBatch::where('store_id', $storeId)
            ->where('product_id', $productId)
            ->where('current_quantity', '>', 0)
            ->sum('current_quantity');

        return $totalQty > 0 ? $totalValue / $totalQty : 0;
    }
}
