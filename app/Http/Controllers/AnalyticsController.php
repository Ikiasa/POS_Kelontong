<?php

namespace App\Http\Controllers;

use App\Services\AnalyticsService;
use App\Services\DeadStockService;
use App\Services\MarginService;
use App\Services\ReorderService;
use Illuminate\Http\Request;
use Illuminate\View\View;

class AnalyticsController extends Controller
{
    public function __construct(
        protected ReorderService $reorderService,
        protected DeadStockService $deadStockService,
        protected MarginService $marginService,
        protected AnalyticsService $analyticsService
    ) {}

    public function index(Request $request)
    {
        $days = $request->input('days', 30);
        $storeId = auth()->user()->store_id ?? 1;

        $salesTrend = $this->analyticsService->getSalesTrend($storeId, $days);
        $categoryDist = $this->analyticsService->getCategoryDistribution($storeId, $days);
        $topProducts = $this->analyticsService->getTopProducts($storeId, $days);
        $peakHours = $this->analyticsService->getPeakHourAnalytics($storeId, $days);

        // Calculate KPIs
        $totalRevenue = collect($salesTrend)->sum('revenue');
        $totalTransactions = collect($salesTrend)->sum('count');
        $avgBasketSize = $totalTransactions > 0 ? $totalRevenue / $totalTransactions : 0;

        return \Inertia\Inertia::render('Analytics/Index', [
            'salesTrend' => $salesTrend,
            'categoryDist' => $categoryDist,
            'topProducts' => $topProducts,
            'peakHours' => $peakHours,
            'kpis' => [
                'revenue' => $totalRevenue,
                'transactions' => $totalTransactions,
                'avgBasket' => $avgBasketSize
            ],
            'filters' => [
                'days' => $days
            ]
        ]);
    }
}
