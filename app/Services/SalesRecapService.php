<?php

namespace App\Services;

use App\Models\Transaction;
use App\Models\TransactionItem;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class SalesRecapService
{
    /**
     * Get aggregated product sales summary.
     */
    public function getProductSalesSummary(int $storeId, $startDate, $endDate, $limit = null)
    {
        $query = DB::table('transaction_items as ti')
            ->join('transactions as t', 'ti.transaction_id', '=', 't.id')
            ->join('products as p', 'ti.product_id', '=', 'p.id')
            ->select(
                'p.id as product_id',
                'p.name as product_name',
                DB::raw('SUM(ti.quantity) as total_quantity_sold'),
                DB::raw('SUM(ti.quantity * ti.price) as total_revenue'),
                DB::raw('SUM(ti.quantity * ti.cost_price) as total_cost'),
                DB::raw('SUM(ti.quantity * (ti.price - ti.cost_price)) as gross_profit'),
                // Margin = (Profit / Revenue) * 100. Handle divide by zero.
                DB::raw('CASE WHEN SUM(ti.quantity * ti.price) > 0 
                    THEN (SUM(ti.quantity * (ti.price - ti.cost_price)) / SUM(ti.quantity * ti.price)) * 100 
                    ELSE 0 END as margin_percentage')
            )
            ->where('t.store_id', $storeId)
            ->whereBetween('t.transaction_date', [$startDate, $endDate])
            ->whereNull('t.deleted_at') // Soft deletes check if applicable, or explicit status check
            ->groupBy('p.id', 'p.name')
            ->orderByDesc('gross_profit'); // Default sort by profit

        if ($limit) {
            $query->limit($limit);
        }

        return $query->get();
    }

    /**
     * Get daily sales recap for charts.
     */
    public function getDailyRecap(int $storeId, $startDate, $endDate)
    {
        return DB::table('transaction_items as ti')
            ->join('transactions as t', 'ti.transaction_id', '=', 't.id')
            ->select(
                DB::raw('DATE(t.transaction_date) as date'),
                DB::raw('COUNT(DISTINCT t.id) as total_transactions'),
                DB::raw('SUM(ti.quantity) as items_sold'),
                DB::raw('SUM(ti.quantity * ti.price) as revenue'),
                DB::raw('SUM(ti.quantity * (ti.price - ti.cost_price)) as profit')
            )
            ->where('t.store_id', $storeId)
            ->whereBetween('t.transaction_date', [$startDate, $endDate])
            ->groupBy(DB::raw('DATE(t.transaction_date)'))
            ->orderBy('date')
            ->get();
    }

    /**
     * Get KPI Summary.
     */
    public function getKpiSummary(int $storeId, $startDate, $endDate)
    {
        $current = DB::table('transaction_items as ti')
            ->join('transactions as t', 'ti.transaction_id', '=', 't.id')
            ->select(
                DB::raw('SUM(ti.quantity * ti.price) as revenue'),
                DB::raw('SUM(ti.quantity * (ti.price - ti.cost_price)) as profit'),
                DB::raw('SUM(ti.quantity) as items_sold')
            )
            ->where('t.store_id', $storeId)
            ->whereBetween('t.transaction_date', [$startDate, $endDate])
            ->first();

        // Calculate Margin
        $margin = ($current->revenue > 0) 
            ? ($current->profit / $current->revenue) * 100 
            : 0;

        return [
            'revenue' => (float) $current->revenue,
            'profit' => (float) $current->profit,
            'items_sold' => (int) $current->items_sold,
            'margin' => round($margin, 2),
        ];
    }

    /**
     * Get Top Products (wrapper for summary with limit).
     */
    public function getTopProducts(int $storeId, $startDate, $endDate, $limit = 10)
    {
        return $this->getProductSalesSummary($storeId, $startDate, $endDate, $limit);
    }
}
