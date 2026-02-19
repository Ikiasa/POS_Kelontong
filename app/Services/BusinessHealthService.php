<?php

namespace App\Services;

use App\Models\BusinessHealthScore;
use App\Models\Transaction;
use App\Models\Product;
use App\Models\Installment;
use App\Models\Budget;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

class BusinessHealthService
{
    protected $weights = [
        'margin_trend' => 25,
        'stock_turnover' => 20,
        'dead_stock' => 15,
        'cashflow' => 20,
        'receivables' => 10,
        'expense_ratio' => 10,
    ];

    public function calculate(int $storeId)
    {
        $breakdown = [
            'margin_trend' => $this->getMarginTrendScore($storeId),
            'stock_turnover' => $this->getStockTurnoverScore($storeId),
            'dead_stock' => $this->getDeadStockScore($storeId),
            'cashflow' => $this->getCashflowScore($storeId),
            'receivables' => $this->getReceivableScore($storeId),
            'expense_ratio' => $this->getExpenseRatioScore($storeId),
        ];

        $totalScore = 0;
        foreach ($breakdown as $key => $score) {
            $totalScore += ($score * $this->weights[$key]) / 100;
        }

        $totalScore = round($totalScore);

        return BusinessHealthScore::create([
            'store_id' => $storeId,
            'score' => $totalScore,
            'breakdown' => $breakdown,
            'explanation' => $this->generateExplanation($breakdown),
            'calculated_at' => now()->toDateString(),
        ]);
    }

    protected function getMarginTrendScore($storeId)
    {
        $currentMonth = DB::table('transactions')
            ->join('transaction_items', 'transactions.id', '=', 'transaction_items.transaction_id')
            ->where('transactions.store_id', $storeId)
            ->whereMonth('transactions.created_at', now()->month)
            ->select(
                DB::raw('SUM(transaction_items.total) as revenue'),
                DB::raw('SUM(transaction_items.cost_price * transaction_items.quantity) as cost')
            )
            ->first();
        
        $margin = ($currentMonth && $currentMonth->revenue > 0) 
            ? (($currentMonth->revenue - $currentMonth->cost) / $currentMonth->revenue) * 100 
            : 0;

        return min(max($margin * 2, 0), 100);
    }

    protected function getStockTurnoverScore($storeId)
    {
        // Sales in 30 days / Average inventory
        $sales30 = Transaction::where('store_id', $storeId)
            ->where('created_at', '>=', now()->subDays(30))
            ->count();
        
        $inventory = Product::where('store_id', $storeId)->sum('stock');
        
        if ($inventory == 0) return 0;
        $turnover = ($sales30 / $inventory);
        return min($turnover * 50, 100);
    }

    protected function getDeadStockScore($storeId)
    {
        $totalProducts = Product::where('store_id', $storeId)->count();
        if ($totalProducts == 0) return 100;

        $deadStock = Product::where('store_id', $storeId)
            ->where(function($q) {
                $q->whereNull('last_sold_at')
                  ->orWhere('last_sold_at', '<', now()->subDays(90));
            })
            ->count();
        
        $ratio = ($deadStock / $totalProducts) * 100;
        return 100 - $ratio;
    }

    protected function getCashflowScore($storeId)
    {
        // Simple ratio of current cash vs monthly expenses
        return 85; // Simulated
    }

    protected function getReceivableScore($storeId)
    {
        $overdueCount = Installment::whereHas('transaction', function($q) use ($storeId) {
                $q->where('store_id', $storeId);
            })
            ->where('due_date', '<', now())
            ->where('status', 'pending')
            ->count();
        
        return max(100 - ($overdueCount * 5), 0);
    }

    protected function getExpenseRatioScore($storeId)
    {
        $revenue = Transaction::where('store_id', $storeId)->whereMonth('created_at', now()->month)->sum('grand_total');
        if ($revenue == 0) return 0;

        $expenses = Budget::where('store_id', $storeId)->sum('amount_limit'); // Simulated expenses
        $ratio = ($expenses / $revenue) * 100;
        
        if ($ratio < 30) return 100;
        if ($ratio > 70) return 30;
        return 100 - ($ratio - 30);
    }

    protected function generateExplanation(array $breakdown)
    {
        $reasons = [];
        if ($breakdown['margin_trend'] < 40) $reasons[] = "Profit margins are below threshold.";
        if ($breakdown['dead_stock'] < 60) $reasons[] = "High volume of slow-moving inventory detected.";
        if ($breakdown['receivables'] < 70) $reasons[] = "Significant overdue installments impacting health.";

        return count($reasons) > 0 ? implode(" ", $reasons) : "Business health is stable across all metrics.";
    }
}
