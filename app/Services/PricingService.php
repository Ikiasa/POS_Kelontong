<?php

namespace App\Services;

use App\Models\PriceTier;
use App\Models\Product;

class PricingService
{
    public function __construct(
        protected PromotionService $promotionService
    ) {}

    /**
     * Resolve the price for a product based on parameters.
     */
    public function getPrice(Product $product, int $storeId, string $tier = 'retail'): float
    {
        // 1. Check Store Specific Tier
        $storeTier = PriceTier::where('product_id', $product->id)
            ->where('store_id', $storeId)
            ->where('tier_name', $tier)
            ->first();

        if ($storeTier) {
            return $storeTier->price;
        }

        // 2. Check Global Tier
        $globalTier = PriceTier::where('product_id', $product->id)
            ->whereNull('store_id')
            ->where('tier_name', $tier)
            ->first();

        if ($globalTier) {
            return $globalTier->price;
        }

        // 3. Fallback to Base Price
        $basePrice = $product->price;

        // 4. Apply Promotions (Net Price)
        // Note: For 'Buy X Get Y', it might be better handled in the cart logic 
        // but for percentage/fixed discounts, we can apply here.
        $discount = $this->promotionService->calculateDiscount($product, 1);
        
        return $basePrice - $discount;
    }

    /**
     * Get all applicable prices for a product at a store.
     */
    public function getProductPrices(Product $product, int $storeId): array
    {
        $prices = [
            'base' => $product->price,
            'retail' => $this->getPrice($product, $storeId, 'retail'),
            'wholesale' => $this->getPrice($product, $storeId, 'wholesale'),
            'member' => $this->getPrice($product, $storeId, 'member'),
        ];

        // 5. Margin Validation
        foreach ($prices as $tier => $price) {
            $margin = $this->calculateMargin($product, $price);
            if ($margin < $product->min_margin) {
                // Potential alert or flag - in ERP we might block or adjust
                // For now, let's flag it in the metadata or logger
                \Illuminate\Support\Facades\Log::warning("Margin Violation for Product #{$product->id} [{$tier}]: {$margin}% (Min: {$product->min_margin}%)");
            }
        }

        return $prices;
    }

    /**
     * Calculate profit margin percentage.
     */
    public function calculateMargin(Product $product, float $sellingPrice): float
    {
        $cost = $product->cost_price ?: 1; // Avoid division by zero
        if ($sellingPrice <= 0) return -100;
        
        $profit = $sellingPrice - $cost;
        return round(($profit / $sellingPrice) * 100, 2);
    }
}
