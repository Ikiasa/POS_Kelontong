<?php

namespace App\Services;

use App\Models\Promotion;
use App\Models\Product;

class PromotionService
{
    /**
     * Calculate discount for a line item based on active promotions
     */
    public function calculateDiscount(Product $product, int $qty): float
    {
        $promo = Promotion::where('product_id', $product->id)
            ->where('is_active', true)
            ->where('start_date', '<=', now())
            ->where('end_date', '>=', now())
            ->first();

        if (!$promo) return 0;

        switch ($promo->rule_type) {
            case 'percentage':
                return ($product->price * $qty) * ($promo->discount_amount / 100);
            
            case 'fixed':
                return $promo->discount_amount * $qty;
            
            case 'buy_x_get_y':
                if ($qty >= $promo->buy_qty) {
                    $times = floor($qty / $promo->buy_qty);
                    $freeQty = $times * $promo->get_qty;
                    return $product->price * $freeQty;
                }
                break;
            
            case 'volume':
                if ($qty >= $promo->min_volume) {
                    return ($product->price * $qty) * ($promo->discount_amount / 100);
                }
                break;
        }

        return 0;
    }
}
