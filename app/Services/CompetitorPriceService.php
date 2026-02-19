<?php

namespace App\Services;

use App\Models\Product;
use App\Models\CompetitorPrice;
use Illuminate\Support\Facades\DB;

class CompetitorPriceService
{
    public function getPricingAnalysis(int $storeId)
    {
        $products = Product::where('store_id', $storeId)->get();
        $recommendations = [];

        foreach ($products as $product) {
            $latestCompetitorPrice = CompetitorPrice::where('product_id', $product->id)
                ->latest('checked_at')
                ->first();

            if (!$latestCompetitorPrice) continue;

            $diff = $product->price - $latestCompetitorPrice->price;
            $diffPercentage = ($diff / $latestCompetitorPrice->price) * 100;

            $status = 'fair';
            if ($diffPercentage > 5) $status = 'overpriced';
            elseif ($diffPercentage < -5) $status = 'underpriced';

            if ($status !== 'fair') {
                $recommendations[] = [
                    'product' => $product,
                    'internal_price' => $product->price,
                    'competitor_price' => $latestCompetitorPrice->price,
                    'competitor_name' => $latestCompetitorPrice->competitor_name,
                    'diff_percentage' => round($diffPercentage, 1),
                    'status' => $status,
                    'margin_impact' => $this->simulateMarginImpact($product, $latestCompetitorPrice->price)
                ];
            }
        }

        return $recommendations;
    }

    public function simulateMarginImpact(Product $product, float $newPrice)
    {
        // Simple impact: (New Price - Cost) - (Current Price - Cost)
        // Usually calculated per unit.
        $currentMargin = $product->price - $product->cost_price;
        $newMargin = $newPrice - $product->cost_price;
        
        return [
            'per_unit' => $newMargin - $currentMargin,
            'new_margin_percentage' => $newPrice > 0 ? (round(($newMargin / $newPrice) * 100, 1)) : 0
        ];
    }
}
