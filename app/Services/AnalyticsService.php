<?php

namespace App\Services;

use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class AnalyticsService
{
    /**
     * Get sales aggregated by hour of day.
     */
    public function getSalesTrend(int $storeId, int $days = 30): array
    {
        $connection = config('database.default');
        $driver = config("database.connections.{$connection}.driver");
        
        $dateExtract = $driver === 'sqlite' 
            ? "date(created_at)" 
            : "DATE(created_at)";

        $salesData = DB::table('transactions')
            ->select(DB::raw("$dateExtract as date"))
            ->selectRaw('SUM(grand_total) as revenue')
            ->selectRaw('COUNT(*) as count')
            ->where('store_id', $storeId)
            ->where('created_at', '>=', now()->subDays($days))
            ->groupBy('date')
            ->orderBy('date')
            ->get();

        // Fill missing dates
        $formatted = [];
        for ($i = $days - 1; $i >= 0; $i--) {
            $date = now()->subDays($i)->format('Y-m-d');
            $found = $salesData->firstWhere('date', $date);

            $formatted[] = [
                'date' => $date, // Y-m-d
                'revenue' => $found ? floatval($found->revenue) : 0,
                'count' => $found ? $found->count : 0,
            ];
        }

        return $formatted;
    }

    public function getCategoryDistribution(int $storeId, int $days = 30): array
    {
        return DB::table('transaction_items')
            ->join('transactions', 'transaction_items.transaction_id', '=', 'transactions.id')
            ->join('products', 'transaction_items.product_id', '=', 'products.id')
            ->join('categories', 'products.category_id', '=', 'categories.id')
            ->select('categories.name as category')
            ->selectRaw('SUM(transaction_items.total) as total_sales')
            ->where('transactions.store_id', $storeId)
            ->where('transactions.created_at', '>=', now()->subDays($days))
            ->groupBy('categories.name')
            ->orderByDesc('total_sales')
            ->limit(5)
            ->get()
            ->toArray();
    }

    public function getTopProducts(int $storeId, int $days = 30, int $limit = 5): array
    {
        return DB::table('transaction_items')
            ->join('transactions', 'transaction_items.transaction_id', '=', 'transactions.id')
            ->join('products', 'transaction_items.product_id', '=', 'products.id')
            ->select('products.name', 'products.stock')
            ->selectRaw('SUM(transaction_items.quantity) as total_qty')
            ->selectRaw('SUM(transaction_items.total) as total_revenue')
            ->where('transactions.store_id', $storeId)
            ->where('transactions.created_at', '>=', now()->subDays($days))
            ->groupBy('products.id', 'products.name', 'products.stock')
            ->orderByDesc('total_revenue')
            ->limit($limit)
            ->get()
            ->toArray();
    }
    public function getPeakHourAnalytics(int $storeId, int $days = 30): array
    {
        $connection = config('database.default');
        $driver = config("database.connections.{$connection}.driver");

        // Extract hour based on driver
        $hourExtract = $driver === 'sqlite' 
            ? "strftime('%H', created_at)" 
            : "EXTRACT(HOUR FROM created_at)";

        return DB::table('transactions')
            ->select(DB::raw("$hourExtract as hour"))
            ->selectRaw('SUM(grand_total) as revenue')
            ->selectRaw('COUNT(*) as count')
            ->where('store_id', $storeId)
            ->where('created_at', '>=', now()->subDays($days))
            ->groupBy('hour')
            ->orderBy('hour')
            ->get()
            ->toArray();
    }
}
