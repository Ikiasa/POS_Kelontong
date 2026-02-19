<?php

namespace App\Services;

use App\Models\Transaction;
use App\Models\Installment;
use App\Models\PurchaseOrder;
use App\Models\CashflowProjection;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

class CashflowProjectionService
{
    /**
     * Generate a 30-day rolling cashflow projection.
     */
    public function generate(int $storeId)
    {
        $startDate = now()->startOfDay();
        $projections = [];
        
        // 1. Calculate historical daily sales avg (90 days) for baseline forecast
        $dailySalesAvg = Transaction::where('store_id', $storeId)
            ->where('created_at', '>=', now()->subDays(90))
            ->sum('grand_total') / 90;

        for ($i = 0; $i < 30; $i++) {
            $date = $startDate->copy()->addDays($i);
            $dateString = $date->toDateString();

            // Expected Incoming: Sales Forecast + Scheduled Installments
            $forecastSales = $dailySalesAvg;
            $scheduledInstallments = Installment::whereHas('transaction', function($q) use ($storeId) {
                $q->where('store_id', $storeId);
            })->whereDate('due_date', $dateString)
            ->where('status', 'pending')
            ->sum('amount');

            $incoming = $forecastSales + $scheduledInstallments;

            // Expected Outgoing: PO Payables + Fixed Expenses (Mocked)
            $poPayables = PurchaseOrder::where('store_id', $storeId)
                ->whereDate('expected_at', $dateString)
                ->whereIn('status', ['sent', 'confirmed'])
                ->sum('total_amount');
            
            $fixedExpenses = 50000; // Simulated daily overhead (electricity, rent/30, etc.)
            
            $outgoing = $poPayables + $fixedExpenses;

            $projections[] = [
                'store_id' => $storeId,
                'projection_date' => $dateString,
                'projected_incoming' => round($incoming, 2),
                'projected_outgoing' => round($outgoing, 2),
                'net_balance' => round($incoming - $outgoing, 2),
                'source_data' => [
                    'sales_forecast' => round($forecastSales, 2),
                    'installments' => round($scheduledInstallments, 2),
                    'purchase_orders' => round($poPayables, 2),
                    'fixed_expenses' => $fixedExpenses
                ],
            ];
        }

        // Save projections (Upsert logic)
        foreach ($projections as $p) {
            CashflowProjection::updateOrCreate(
                ['store_id' => $storeId, 'projection_date' => $p['projection_date']],
                $p
            );
        }

        return $projections;
    }

    /**
     * Perform a What-If simulation by increasing sales.
     */
    public function simulateGrowth(int $storeId, float $growthPercentage)
    {
        $projections = $this->generate($storeId);
        $multiplier = 1 + ($growthPercentage / 100);

        return array_map(function($p) use ($multiplier) {
            $p['projected_incoming'] *= $multiplier;
            $p['net_balance'] = $p['projected_incoming'] - $p['projected_outgoing'];
            return $p;
        }, $projections);
    }
}
