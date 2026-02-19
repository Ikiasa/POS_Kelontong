<?php

namespace App\Services;

use App\Models\Customer;
use App\Models\LoyaltyLog;
use App\Models\Transaction;
use Illuminate\Support\Facades\DB;

class LoyaltyService
{
    /**
     * Rate: 1 Point per Rp 10.000 spent
     */
    protected const EARN_RATE_DIVISOR = 10000;
    
    /**
     * Redemption Value: 1 Point = Rp 50 discount
     */
    protected const REDEEM_VALUE_PER_POINT = 50;

    /**
     * Calculate and award points for a completed transaction.
     */
    public function awardPoints(Transaction $transaction): void
    {
        if (!$transaction->customer_id) {
            return;
        }

        // Only award points for amount paid in cash/digital (exclude redeemed discount portion if any)
        // For simplicity MVP: based on Grand Total
        $pointsEarned = floor($transaction->grand_total / self::EARN_RATE_DIVISOR);

        if ($pointsEarned <= 0) {
            return;
        }

        DB::transaction(function () use ($transaction, $pointsEarned) {
            $customer = $transaction->customer;
            
            // Log the points
            LoyaltyLog::create([
                'customer_id' => $customer->id,
                'transaction_id' => $transaction->id,
                'points' => $pointsEarned,
                'type' => 'earn',
                'description' => "Earned from transaction #{$transaction->id}",
            ]);

            // Update balance
            $customer->increment('points_balance', $pointsEarned);
            
            // Update Tier Check
            $this->updateTier($customer);
        });
    }

    /**
     * Redeem points for a discount.
     * Returns the discount amount in Rupiah.
     */
    public function redeemPoints(Customer $customer, int $pointsToRedeem, ?Transaction $transaction = null): float
    {
        if ($customer->points_balance < $pointsToRedeem) {
            throw new \Exception("Insufficient points balance.");
        }

        $discountParams = [
            'points' => -$pointsToRedeem, // Negative handling
            'type' => 'redeem',
            'description' => "Redeemed for discount",
        ];

        if ($transaction) {
            $discountParams['transaction_id'] = $transaction->id;
            $discountParams['description'] .= " on transaction #{$transaction->id}";
        }

        LoyaltyLog::create(array_merge([
            'customer_id' => $customer->id,
        ], $discountParams));

        $customer->decrement('points_balance', $pointsToRedeem);

        return $pointsToRedeem * self::REDEEM_VALUE_PER_POINT;
    }
    
    /**
     * Get maximum redeemable discount for a transaction amount.
     */
    public function getMaxRedemption(Customer $customer, float $transactionAmount): array
    {
        // Max redeem: 50% of transaction or total points, whichever is lower
        $maxDiscountValue = $transactionAmount * 0.5;
        $maxPointsByValue = floor($maxDiscountValue / self::REDEEM_VALUE_PER_POINT);
        
        $redeemablePoints = min($customer->points_balance, $maxPointsByValue);
        $discountAmount = $redeemablePoints * self::REDEEM_VALUE_PER_POINT;
        
        return [
            'points' => $redeemablePoints,
            'discount_amount' => $discountAmount
        ];
    }
    
    /**
     * Update customer tier based on total earned points (or total spent logic).
     */
    public function updateTier(Customer $customer): void
    {
        // MVP: Simple Tier based on current balance for now, or lifetime points if tracked.
        // Let's use points_balance for simplicity in MVP.
        $tier = 'silver';
        if ($customer->points_balance >= 5000) {
            $tier = 'platinum';
        } elseif ($customer->points_balance >= 1000) {
            $tier = 'gold';
        }
        
        if ($customer->tier !== $tier) {
            $customer->update(['tier' => $tier]);
        }
    }
}
