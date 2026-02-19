<?php

namespace App\Services;

use App\Models\Transaction;
use App\Models\JournalEntry;
use Illuminate\Support\Facades\DB;

class ConsolidatedReportService
{
    /**
     * Generate a consolidated profit/loss report across all stores
     */
    public function generateProfitLoss(array $storeIds, string $startDate, string $endDate)
    {
        return DB::table('journal_entries')
            ->join('journal_items', 'journal_entries.id', '=', 'journal_items.journal_entry_id')
            ->join('accounts', 'journal_items.account_id', '=', 'accounts.id')
            ->whereIn('journal_entries.store_id', $storeIds)
            ->whereBetween('journal_entries.date', [$startDate, $endDate])
            ->select(
                'accounts.type',
                DB::raw('SUM(journal_items.debit - journal_items.credit) as balance')
            )
            ->groupBy('accounts.type')
            ->get();
    }

    /**
     * Elimination logic for inter-store stock transfers
     * (Simulated: in enterprise level, we usually tag transfers to eliminate revenue/cost)
     */
    public function getEliminations(array $storeIds)
    {
        // Inter-store transfers should not count as external revenue
        return DB::table('stock_transfers')
            ->whereIn('from_store_id', $storeIds)
            ->whereIn('to_store_id', $storeIds)
            ->sum('total_cost');
    }
}
