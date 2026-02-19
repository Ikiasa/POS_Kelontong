<?php

namespace App\Http\Controllers;

use App\Services\SalesRecapService;
use Illuminate\Http\Request;
use Inertia\Inertia;

class ReportsController extends Controller
{
    public function __construct(protected SalesRecapService $service) {}

    /**
     * Display the analytics dashboard page.
     */
    public function index()
    {
        return Inertia::render('Analytics/Index');
    }

    /**
     * Get JSON data for the analytics dashboard (for lazy loading).
     */
    public function data(Request $request)
    {
        $storeId = auth()->user()->store_id ?? 1;
        $range = $request->get('range', '30_days'); // 7_days, 30_days, this_month, last_month
        
        // Calculate dates
        $endDate = now();
        $startDate = match($range) {
            '7_days' => now()->subDays(7),
            '30_days' => now()->subDays(30),
            'this_month' => now()->startOfMonth(),
            'last_month' => now()->subMonth()->startOfMonth(),
            default => now()->subDays(30),
        };
        
        if ($range === 'last_month') {
            $endDate = now()->subMonth()->endOfMonth();
        }

        // 1. KPI Cards
        $kpi = $this->service->getKpiSummary($storeId, $startDate, $endDate);

        // 2. Chart Data (Daily)
        $chart = $this->service->getDailyRecap($storeId, $startDate, $endDate);

        // 3. Top Products
        $topProducts = $this->service->getTopProducts($storeId, $startDate, $endDate, 5);

        // 4. Heatmap Data (Product Sales Summary)
        // We limit this to top 50 perfomers to avoid browser lag, or maybe top 20
        $heatmap = $this->service->getProductSalesSummary($storeId, $startDate, $endDate, 50);

        return response()->json([
            'kpi' => $kpi,
            'chart' => $chart,
            'top_products' => $topProducts,
            'heatmap' => $heatmap,
            'period' => [
                'start' => $startDate->format('Y-m-d'),
                'end' => $endDate->format('Y-m-d'),
            ]
        ]);
    }
}
