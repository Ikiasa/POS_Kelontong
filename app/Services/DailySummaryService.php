<?php

namespace App\Services;

use App\Models\Transaction;
use App\Models\TransactionItem;
use App\Models\Product;
use App\Models\SystemAlert;
use App\Models\Store;
use Illuminate\Support\Facades\DB;

class DailySummaryService
{
    public function generateDailySummary(int $storeId, string $date = null)
    {
        $date = $date ?? now()->toDateString();
        $store = Store::find($storeId);

        $salesMetrics = Transaction::where('store_id', $storeId)
            ->whereDate('transaction_date', $date)
            ->select(
                DB::raw('COUNT(*) as total_transactions'),
                DB::raw('SUM(grand_total) as total_sales'),
                DB::raw('SUM(subtotal - (SELECT SUM(cost_price * quantity) FROM transaction_items WHERE transaction_id = transactions.id)) as gross_profit')
            )->first();

        $bestSeller = TransactionItem::join('transactions', 'transaction_items.transaction_id', '=', 'transactions.id')
            ->where('transactions.store_id', $storeId)
            ->whereDate('transactions.transaction_date', $date)
            ->select('product_name', DB::raw('SUM(quantity) as total_qty'))
            ->groupBy('product_name')
            ->orderByDesc('total_qty')
            ->first();

        $criticalAlerts = SystemAlert::where('store_id', $storeId)
            ->whereDate('created_at', $date)
            ->where('severity', 'critical')
            ->count();

        $deadStockCount = Product::where('store_id', $storeId)
            ->where('stock', '>', 0)
            ->whereNotExists(function($query) use ($storeId) {
                $query->select(DB::raw(1))
                    ->from('transaction_items')
                    ->join('transactions', 'transaction_items.transaction_id', '=', 'transactions.id')
                    ->whereColumn('transaction_items.product_id', 'products.id')
                    ->where('transactions.transaction_date', '>=', now()->subDays(90));
            })->count();

        return [
            'store_name' => $store->name,
            'date' => $date,
            'total_sales' => $salesMetrics->total_sales ?? 0,
            'gross_profit' => $salesMetrics->gross_profit ?? 0,
            'net_profit' => ($salesMetrics->gross_profit ?? 0) * 0.85, // Simple estimate minus overhead
            'best_seller' => $bestSeller ? $bestSeller->product_name : 'N/A',
            'dead_stock_warning' => $deadStockCount,
            'critical_alerts' => $criticalAlerts,
            'status' => $criticalAlerts > 0 ? 'NEEDS ATTENTION' : 'HEALTHY'
        ];
    }

    public function formatForWhatsApp(array $summary)
    {
        return "📊 *Daily Business Summary: {$summary['store_name']}*\n" .
               "📅 Date: {$summary['date']}\n\n" .
               "💰 *Total Sales:* Rp " . number_format($summary['total_sales'], 0, ',', '.') . "\n" .
               "📈 *Gross Profit:* Rp " . number_format($summary['gross_profit'], 0, ',', '.') . "\n" .
               "📦 *Best Seller:* {$summary['best_seller']}\n" .
               "⚠️ *Dead Stock Items:* {$summary['dead_stock_warning']}\n" .
               "🚨 *Critical Alerts:* {$summary['critical_alerts']}\n\n" .
               "Status: " . ($summary['status'] === 'HEALTHY' ? "✅ {$summary['status']}" : "🛑 {$summary['status']}");
    }
}
