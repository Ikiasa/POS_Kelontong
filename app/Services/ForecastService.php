<?php

namespace App\Services;

use App\Models\Transaction;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;

class ForecastService
{
    /**
     * Generate sales forecast for the next month based on 6-month history.
     */
    public function getMonthlyForecast(int $storeId): array
    {
        // 1. Get Monthly Sales (Last 6 Months)
        $history = Transaction::where('store_id', $storeId)
            ->where('created_at', '>=', Carbon::now()->subMonths(6))
            ->select(
                DB::raw("DATE_TRUNC('month', created_at) as month"), 
                DB::raw('sum(grand_total) as total')
            )
            ->groupBy('month')
            ->orderBy('month')
            ->get();

        $dataPoints = $history->pluck('total')->toArray();
        $labels = $history->map(fn($h) => Carbon::parse($h->month)->format('M Y'))->toArray();

        // 2. Calculate Simple Moving Average (SMA)
        $nextMonthPrediction = 0;
        $trend = 'stable';

        if (count($dataPoints) > 0) {
            $average = array_sum($dataPoints) / count($dataPoints);
            
            // Allow for simple weighted trend: Last month matters more
            $lastMonth = end($dataPoints);
            $nextMonthPrediction = ($average + $lastMonth) / 2;

            if ($lastMonth > $average * 1.1) $trend = 'up';
            elseif ($lastMonth < $average * 0.9) $trend = 'down';
        }

        return [
            'history' => [
                'labels' => $labels,
                'data' => $dataPoints,
            ],
            'prediction' => [
                'next_month' => $nextMonthPrediction,
                'trend' => $trend,
                'growth_rate' => count($dataPoints) > 1 ? ((end($dataPoints) - $dataPoints[0]) / $dataPoints[0]) * 100 : 0
            ]
        ];
    }
}
