<?php

namespace App\Services;

use App\Models\Transaction;
use App\Models\TransactionItem;
use App\Models\FraudAlert;
use App\Models\AuditLog;
use App\Models\ProfitRiskScore;
use Illuminate\Support\Facades\DB;

class ProfitLeakService
{
    public function analyzeStore(int $storeId)
    {
        $indicators = [
            'low_margin_items' => $this->detectLowMarginItems($storeId),
            'negative_margin_sales' => $this->detectNegativeMarginSales($storeId),
            'discount_leakage' => $this->detectDiscountAbuse($storeId),
            'void_patterns' => $this->detectVoidPatterns($storeId),
            'price_overrides' => $this->detectPriceOverrides($storeId),
        ];

        $riskScore = $this->calculateRiskScore($indicators);

        $result = ProfitRiskScore::create([
            'store_id' => $storeId,
            'risk_score' => $riskScore,
            'indicators' => $indicators,
            'calculated_at' => now()->toDateString(),
        ]);

        $this->generateAlerts($storeId, $indicators);

        return $result;
    }

    protected function detectLowMarginItems($storeId)
    {
        return TransactionItem::whereHas('transaction', fn($q) => $q->where('store_id', $storeId))
            ->whereRaw('(price - cost_price) / NULLIF(price, 0) < 0.05')
            ->count();
    }

    protected function detectNegativeMarginSales($storeId)
    {
        return TransactionItem::whereHas('transaction', fn($q) => $q->where('store_id', $storeId))
            ->whereRaw('price < cost_price')
            ->count();
    }

    protected function detectDiscountAbuse($storeId)
    {
        $avgDiscount = Transaction::where('store_id', $storeId)->avg('discount');
        return Transaction::where('store_id', $storeId)
            ->where('discount', '>', $avgDiscount * 3)
            ->count();
    }

    protected function detectVoidPatterns($storeId)
    {
        return Transaction::where('store_id', $storeId)
            ->where('status', 'voided')
            ->count();
    }

    protected function detectPriceOverrides($storeId)
    {
        return AuditLog::where('action', 'price_override')
            ->whereRaw("new_values->>'store_id' = ?", [(string)$storeId])
            ->count();
    }

    protected function calculateRiskScore($indicators)
    {
        $score = array_sum($indicators) * 2;
        return min($score, 100);
    }

    protected function generateAlerts($storeId, $indicators)
    {
        if ($indicators['negative_margin_sales'] > 0) {
            FraudAlert::create([
                'rule_name' => 'Profit Leakage',
                'description' => "Detected {$indicators['negative_margin_sales']} sales reflecting negative margins.",
                'severity' => 'high',
                'store_id' => $storeId,
            ]);
        }
    }

    public function analyzeEmployee(int $userId)
    {
        // Similar logic targeted per user
        $voids = Transaction::where('user_id', $userId)->where('status', 'voided')->count();
        $discounts = Transaction::where('user_id', $userId)->where('discount', '>', 0)->count();

        return ProfitRiskScore::create([
            'store_id' => 1, // Store mapping needed
            'user_id' => $userId,
            'risk_score' => min(($voids * 10) + ($discounts * 2), 100),
            'indicators' => ['voids' => $voids, 'discounts' => $discounts],
            'calculated_at' => now()->toDateString(),
        ]);
    }
}
