<?php

namespace App\Services;

use App\Models\FraudAlert;
use App\Models\Transaction;
use Illuminate\Support\Facades\DB;

class FraudDetectionService
{
    /**
     * Check a transaction for suspicious activity.
     */
    public function checkTransaction(Transaction $transaction): void
    {
        // 1. High Discount Rule (> 20%)
        // Calculate percentage: (discount / (subtotal + tax)) * 100
        $baseAmount = $transaction->subtotal + $transaction->tax;
        if ($baseAmount > 0) {
            $discountPercent = ($transaction->discount / $baseAmount) * 100;
            
            if ($discountPercent > 20) {
                $this->createAlert(
                    $transaction,
                    'High Discount',
                    "Discount of {$discountPercent}% applied (Limit: 20%)",
                    'medium'
                );
            }
        }

        // 2. Negative Margin Rule
        foreach ($transaction->items as $item) {
            if ($item->price < $item->cost_price) {
                $margin = $item->price - $item->cost_price;
                $this->createAlert(
                    $transaction,
                    'Negative Margin',
                    "Item '{$item->product_name}' sold at loss (Margin: {$margin})",
                    'high'
                );
            }
        }

        // 3. Excessive Void/Cancel logic would be in VoidService, not here usually.
        // But if we had a status change log, we could check frequency.
    }

    protected function createAlert(Transaction $transaction, string $rule, string $desc, string $severity): void
    {
        FraudAlert::create([
            'reference_id' => $transaction->id,
            'model_type' => Transaction::class,
            'rule_name' => $rule,
            'description' => $desc,
            'severity' => $severity,
            'user_id' => $transaction->user_id, // Cashier who did it
        ]);
    }
}
