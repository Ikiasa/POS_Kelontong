<?php

namespace App\Services;

use App\Models\Budget;
use App\Models\JournalItem;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;

class BudgetService
{
    /**
     * Set a budget for a category.
     */
    public function setBudget(int $storeId, string $category, float $amount, Carbon $start, Carbon $end): Budget
    {
        return Budget::updateOrCreate(
            [
                'store_id' => $storeId,
                'category_name' => $category,
                'start_date' => $start->toDateString(),
                'end_date' => $end->toDateString(),
            ],
            [
                'amount_limit' => $amount,
            ]
        );
    }

    /**
     * Get budget status including actual usage.
     */
    public function getBudgetStatus(int $storeId, ?Carbon $month = null): array
    {
        $month = $month ?? now();
        $start = $month->copy()->startOfMonth();
        $end = $month->copy()->endOfMonth();

        $budgets = Budget::where('store_id', $storeId)
            ->where('start_date', '<=', $end)
            ->where('end_date', '>=', $start)
            ->get();

        $status = [];

        foreach ($budgets as $budget) {
            // Calculate Actual Expense from Journal
            // Assuming Expense accounts start with '5' or '6' or mapped by name
            // For simplicity, we match account_name to category_name loosely or exact
            
            $actual = JournalItem::whereHas('journalEntry', function ($q) use ($storeId, $start, $end) {
                    $q->where('store_id', $storeId)
                      ->whereBetween('transaction_date', [$start, $end]);
                })
                ->where('account_name', 'LIKE', "%{$budget->category_name}%") // Loose match for demo
                ->where('debit', '>', 0) // Expenses are typically debits
                ->sum('debit');

            $percentage = $budget->amount_limit > 0 ? ($actual / $budget->amount_limit) * 100 : 0;
            
            $state = 'ok';
            if ($percentage >= 100) $state = 'over';
            elseif ($percentage >= 80) $state = 'warning';

            $status[] = [
                'category' => $budget->category_name,
                'limit' => $budget->amount_limit,
                'actual' => $actual,
                'percentage' => round($percentage, 2),
                'remaining' => $budget->amount_limit - $actual,
                'status' => $state,
            ];
        }

        return $status;
    }
}
