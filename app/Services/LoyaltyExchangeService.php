<?php

namespace App\Services;

use App\Models\Customer;
use App\Models\Voucher;
use App\Models\Product;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\DB;

class LoyaltyExchangeService
{
    /**
     * Exchange points for a Cash Voucher.
     */
    public function exchangeForVoucher(Customer $customer, int $points): Voucher
    {
        if ($customer->points_balance < $points) {
            throw new \Exception("Poin tidak cukup.");
        }

        // 1 Point = Rp 50 (Customizable)
        $value = $points * 50;

        return DB::transaction(function () use ($customer, $points, $value) {
            $customer->decrement('points_balance', $points);

            return Voucher::create([
                'code' => 'LOY-' . strtoupper(Str::random(6)),
                'type' => 'cash',
                'value' => $value,
                'is_active' => true,
                'expires_at' => now()->addMonths(3),
                'metadata' => [
                    'source' => 'loyalty_exchange',
                    'points_redeemed' => $points,
                    'customer_id' => $customer->id
                ]
            ]);
        });
    }

    /**
     * Exchange points for physical merchandise.
     */
    public function exchangeForProduct(Customer $customer, Product $product, int $points): bool
    {
        if ($customer->points_balance < $points) {
            throw new \Exception("Poin tidak cukup.");
        }

        if ($product->stock <= 0) {
            throw new \Exception("Stok merchandise habis.");
        }

        return DB::transaction(function () use ($customer, $product, $points) {
            $customer->decrement('points_balance', $points);
            $product->decrement('stock', 1);

            // Record this in a 'RewardHistory' or similar if model exists
            // For now, we just deduct stock and points
            return true;
        });
    }
}
