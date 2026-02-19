<?php

namespace App\Services;

use App\Models\PriceTier;
use App\Models\Product;

class PricingService
{
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
        return $product->price;
    }

    /**
     * Get all applicable prices for a product at a store.
     */
    public function getProductPrices(Product $product, int $storeId): array
    {
        return [
            'base' => $product->price,
            'retail' => $this->getPrice($product, $storeId, 'retail'),
            'wholesale' => $this->getPrice($product, $storeId, 'wholesale'),
            'member' => $this->getPrice($product, $storeId, 'member'),
        ];
    }
}
