<?php

namespace App\Services;

use App\Models\Product;
use App\Models\TransactionItem;
use Illuminate\Support\Facades\DB;

class PricingIntelligenceService
{
    /**
     * Analyze products and suggest pricing changes.
     */
    public function getPricingSuggestions(int $storeId): array
    {
        $suggestions = [];

        // 1. Identify Low Margin Products (Margin < 10%)
        // We compare current selling price vs weighted average cost of active batches (or just base cost if lazy)
        // Ideally use BatchService to get real cost. Here we use product->cost_price or batch avg.
        // Let's rely on Product model cost_price for speed (assuming it's updated).
        
        $products = Product::where('store_id', $storeId)->get();

        foreach ($products as $product) {
            $cost = $product->cost_price; // Or fetch via ValuationService
            $price = $product->price;

            if ($cost > 0) {
                $margin = ($price - $cost) / $cost;
                if ($margin < 0.10) {
                    $suggestions[] = [
                        'product' => $product,
                        'type' => 'markup',
                        'reason' => 'Low Margin (' . number_format($margin * 100, 1) . '%)',
                        'suggested_price' => $cost * 1.25, // Target 25% margin
                        'severity' => 'high'
                    ];
                }
            }
        }

        // 2. Identify Slow Moving Items (No sales in 30 days)
        $slowChekDate = now()->subDays(30);
        
        $soldProductIds = TransactionItem::whereHas('transaction', function($q) use ($storeId, $slowChekDate) {
            $q->where('store_id', $storeId)->where('created_at', '>=', $slowChekDate);
        })->distinct()->pluck('product_id')->toArray();

        $slowProducts = Product::where('store_id', $storeId)
            ->whereNotIn('id', $soldProductIds)
            ->where('stock', '>', 0)
            ->take(10) // Limit to top 10 to avoid noise
            ->get();

        foreach ($slowProducts as $product) {
            $suggestions[] = [
                'product' => $product,
                'type' => 'discount',
                'reason' => 'Slow Moving (No sales 30 days)',
                'suggested_price' => $product->price * 0.90, // 10% discount
                'severity' => 'medium'
            ];
        }

        return $suggestions;
    }
}
