<?php

namespace App\Services;

use App\Models\Transaction;
use App\Models\Store;
use App\Models\StockTransfer;
use Illuminate\Support\Facades\DB;

class ConsolidationService
{
    /**
     * Get consolidated sales report across all stores.
     */
    public function getConsolidatedSales(string $startDate, string $endDate): array
    {
        $branches = Store::all();
        $report = [];
        $totalGroupSales = 0;

        foreach ($branches as $branch) {
            $sales = Transaction::where('store_id', $branch->id)
                ->whereBetween('created_at', [$startDate, $endDate])
                ->sum('grand_total');

            $report[] = [
                'branch_name' => $branch->name,
                'sales' => (float) $sales
            ];
            $totalGroupSales += $sales;
        }

        // Internal Elimination: Subtract value of internal stock transfers to avoid triple-counting
        $internalTransfers = StockTransfer::whereBetween('created_at', [$startDate, $endDate])
            ->where('status', 'received')
            ->get()
            ->sum(function($transfer) {
                return $transfer->items->sum(fn($i) => $i->quantity * ($i->product->cost_price ?? 0));
            });

        return [
            'branches' => $report,
            'gross_group_sales' => $totalGroupSales,
            'internal_elimination' => $internalTransfers,
            'net_group_performance' => $totalGroupSales - $internalTransfers
        ];
    }
}
