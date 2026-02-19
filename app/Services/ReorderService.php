<?php

namespace App\Services;

use App\Models\Product;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;

class ReorderService
{
    /**
     * Calculate reorder suggestions for a specific store.
     */
    public function getReorderSuggestions(int $storeId): Collection
    {
        // Get products for the store
        $products = Product::where('store_id', $storeId)->get();
        
        // Pre-fetch sales data for last 30 days to minimize N+1
        // Group by product_id
        $salesData = DB::table('transaction_items')
            ->join('transactions', 'transaction_items.transaction_id', '=', 'transactions.id')
            ->where('transactions.store_id', $storeId)
            ->where('transactions.created_at', '>=', now()->subDays(30))
            ->select(
                'transaction_items.product_id',
                DB::raw('SUM(transaction_items.quantity) as total_sold')
            )
            ->groupBy('transaction_items.product_id')
            ->pluck('total_sold', 'product_id');

        $suggestions = collect();

        foreach ($products as $product) {
            $totalSold30Days = $salesData->get($product->id, 0);
            $avgDailySales = $totalSold30Days / 30;
            
            // Reorder Point = (Avg Daily Sales * Lead Time) + Safety Stock
            $reorderPoint = ($avgDailySales * $product->lead_time_days) + $product->safety_stock;
            
            // If current stock is below reorder point, suggest restock
            if ($product->stock <= $reorderPoint) {
                // Economic Order Quantity (EOQ) simplified or fill up to max? 
                // Let's suggest filling up to (Reorder Point + Safety Stock) for now
                // or just detailed info for the user.
                
                $suggestedQty = ceil($reorderPoint - $product->stock); // Ensure positive integer
                
                if ($suggestedQty > 0) {
                    $suggestions->push([
                        'product_id' => $product->id,
                        'product_name' => $product->name,
                        'current_stock' => $product->stock,
                        'avg_daily_sales' => round($avgDailySales, 2),
                        'lead_time_days' => $product->lead_time_days,
                        'safety_stock' => $product->safety_stock,
                        'reorder_point' => round($reorderPoint, 2),
                        'suggested_quantity' => $suggestedQty,
                    ]);
                }
            }
        }

        return $suggestions->sortByDesc('suggested_quantity');
    }
}
