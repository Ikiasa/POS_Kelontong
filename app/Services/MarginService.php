<?php

namespace App\Services;

use App\Models\Product;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;

class MarginService
{
    /**
     * Calculate margins per product and category.
     */
    public function getMarginAnalysis(int $storeId): array
    {
        $products = Product::where('store_id', $storeId)
            ->with('category')
            ->get();

        $productMargins = $products->map(function ($product) {
            $margin = $product->price - $product->cost_price;
            $marginPercent = $product->price > 0 ? ($margin / $product->price) * 100 : 0;
            
            return [
                'id' => $product->id,
                'name' => $product->name,
                'category' => $product->category->name ?? 'Uncategorized',
                'price' => $product->price,
                'cost' => $product->cost_price,
                'margin' => $margin,
                'margin_percent' => round($marginPercent, 2),
                'is_low_margin' => $marginPercent < 15, // Configurable threshold
            ];
        });

        // Group by Category
        $categoryMargins = $productMargins->groupBy('category')->map(function ($items, $category) {
            $totalRevenue = $items->sum('price'); // Potential revenue
            $totalCost = $items->sum('cost');
            $totalMargin = $totalRevenue - $totalCost;
            $avgMarginPercent = $totalRevenue > 0 ? ($totalMargin / $totalRevenue) * 100 : 0;
            
            return [
                'category' => $category,
                'avg_margin_percent' => round($avgMarginPercent, 2),
                'product_count' => $items->count(),
            ];
        })->values();

        return [
            'top_products' => $productMargins->sortByDesc('margin')->take(10)->values(),
            'low_margin_products' => $productMargins->where('is_low_margin', true)->values(),
            'category_performance' => $categoryMargins->sortByDesc('avg_margin_percent'),
        ];
    }
}
