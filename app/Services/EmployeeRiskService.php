<?php

namespace App\Services;

use App\Models\User;
use App\Models\AuditLog;
use App\Models\Transaction;
use App\Models\CashDrawer;
use App\Models\EmployeeRiskScore;
use App\Models\FraudAlert;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

class EmployeeRiskService
{
    protected $alertService;

    public function __construct(AlertService $alertService)
    {
        $this->alertService = $alertService;
    }

    /**
     * Calculate and store risk score for a specific employee.
     */
    public function calculateScore(int $userId, int $storeId)
    {
        $last30Days = now()->subDays(30);
        $indicators = [];

        // 1. Voids (Weight: 20%)
        $voidCount = AuditLog::where('user_id', $userId)
            ->where('action', 'void')
            ->where('created_at', '>=', $last30Days)
            ->count();
        $voidScore = min(($voidCount / 5) * 100, 100) * 0.20;
        $indicators['voids'] = ['count' => $voidCount, 'score' => round($voidScore, 2)];

        // 2. Discounts (Weight: 15%)
        $avgDiscount = Transaction::where('user_id', $userId)
            ->where('created_at', '>=', $last30Days)
            ->where('discount', '>', 0)
            ->avg('discount') ?? 0;
        // Assume avg discount over 50k is significant for a small grocery (kelontong)
        $discountScore = min(($avgDiscount / 50000) * 100, 100) * 0.15; 
        $indicators['discounts'] = ['avg' => round($avgDiscount, 2), 'score' => round($discountScore, 2)];

        // 3. Price Edits (Weight: 20%)
        $priceEdits = AuditLog::where('user_id', $userId)
            ->where('action', 'update')
            ->where('target_type', 'App\Models\Product')
            ->where('created_at', '>=', $last30Days)
            ->count();
        $priceScore = min(($priceEdits / 3) * 100, 100) * 0.20;
        $indicators['price_edits'] = ['count' => $priceEdits, 'score' => round($priceScore, 2)];

        // 4. Cash Drawer Variance (Weight: 30%)
        $totalVariance = abs(CashDrawer::where('user_id', $userId)
            ->where('closed_at', '>=', $last30Days)
            ->sum('variance'));
        $varianceScore = min(($totalVariance / 100000) * 100, 100) * 0.30;
        $indicators['variance'] = ['amount' => round($totalVariance, 2), 'score' => round($varianceScore, 2)];

        // 5. Late Closings (Weight: 15%)
        $lateClosings = CashDrawer::where('user_id', $userId)
            ->where('closed_at', '>=', $last30Days)
            ->whereRaw("EXTRACT(HOUR FROM closed_at) >= 22") // After 10 PM
            ->count();
        $lateScore = min(($lateClosings / 2) * 100, 100) * 0.15;
        $indicators['late_closings'] = ['count' => $lateClosings, 'score' => round($lateScore, 2)];

        $totalScore = $voidScore + $discountScore + $priceScore + $varianceScore + $lateScore;

        $level = 'low';
        if ($totalScore > 75) $level = 'critical';
        elseif ($totalScore > 50) $level = 'high';
        elseif ($totalScore > 25) $level = 'medium';

        $risk = EmployeeRiskScore::updateOrCreate(
            ['user_id' => $userId, 'store_id' => $storeId, 'calculated_at' => now()->startOfDay()],
            [
                'risk_score' => round($totalScore, 2),
                'risk_level' => $level,
                'indicators' => $indicators,
                'metadata' => [
                    'calculation_version' => '1.0',
                    'period' => '30d'
                ]
            ]
        );

        // Escalation Logic
        if ($level === 'high' || $level === 'critical') {
            $this->escalateAlert($risk);
        }

        return $risk;
    }

    protected function escalateAlert(EmployeeRiskScore $risk)
    {
        // System Alert Integration
        $this->alertService->trigger(
            $risk->store_id,
            'high_risk',
            "SECURITY: High-risk behavior detected for {$risk->user->name}. Score: {$risk->risk_score}",
            $risk->risk_level === 'critical' ? 'critical' : 'warning',
            ['risk_id' => $risk->id, 'score' => $risk->risk_score]
        );
    }

    protected function getTopIndicator(array $indicators)
    {
        uasort($indicators, fn($a, $b) => $b['score'] <=> $a['score']);
        return key($indicators);
    }
}
