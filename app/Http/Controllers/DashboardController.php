<?php

namespace App\Http\Controllers;

use App\Models\BusinessHealthScore;
use App\Models\ProfitRiskScore;
use App\Models\Customer;
use App\Models\FraudAlert;
use App\Models\Product;
use App\Models\Transaction;
use App\Services\ReplenishmentService;
use App\Services\CashflowProjectionService;
use App\Services\EmployeeRiskService;
use App\Services\InsightEngineService;
use App\Services\StockIntelligenceService;
use App\Services\CompetitorPriceService;
use App\Services\AlertService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class DashboardController extends Controller
{
    public function index(
        ReplenishmentService $replenishmentService,
        CashflowProjectionService $cashflowService,
        EmployeeRiskService $riskService,
        InsightEngineService $insightService,
        StockIntelligenceService $stockService,
        CompetitorPriceService $competitorService,
        AlertService $alertService
    ) {
        $storeId = auth()->user()->store_id ?? 1;

        // Metrics
        $totalProducts = Product::where('store_id', $storeId)->count();
        $totalCustomers = Customer::where('store_id', $storeId)->count();
        
        $todaySales = Transaction::where('store_id', $storeId)
            ->whereDate('created_at', now()->today())
            ->sum('grand_total');

        $thisMonthSales = Transaction::where('store_id', $storeId)
            ->whereMonth('created_at', now()->month)
            ->sum('grand_total');

        // Security Alerts
        $pendingAlerts = FraudAlert::where('resolved_at', null)->latest()->take(5)->get();

        // System Health
        $backupCount = count(Storage::files('backups'));
        
        // Sales History (Last 30 Days) for Chart
        $salesHistory = Transaction::where('store_id', $storeId)
            ->where('created_at', '>=', now()->subDays(30))
            ->select(DB::raw("DATE(created_at) as date"), DB::raw("SUM(grand_total) as total"))
            ->groupBy('date')
            ->orderBy('date')
            ->get()
            ->mapWithKeys(fn($item) => [$item->date => (float)$item->total])
            ->toArray();

        // Top Selling Products (By Revenue)
        $topProducts = DB::table('transaction_items')
            ->join('products', 'transaction_items.product_id', '=', 'products.id')
            ->select('products.name', DB::raw('SUM(transaction_items.quantity) as total_sold'), DB::raw('SUM(transaction_items.total) as revenue'))
            ->where('products.store_id', $storeId)
            ->groupBy('products.id', 'products.name')
            ->orderBy('revenue', 'desc')
            ->take(5)
            ->get();

        $healthScore = BusinessHealthScore::where('store_id', $storeId)->latest('calculated_at')->first();
        $riskScore = ProfitRiskScore::where('store_id', $storeId)->whereNull('user_id')->latest('calculated_at')->first();
        $recommendations = $replenishmentService->getRecommendations($storeId);
        $cashflowProjections = $cashflowService->generate($storeId);
        
        // AI Insights
        $insightService->generateInsights($storeId);
        $aiInsights = \App\Models\AIInsight::where('store_id', $storeId)
            ->where('status', 'pending')
            ->latest()
            ->get();

        // Stock Intelligence
        $stockData = $stockService->getStockMetrics($storeId);

        // Competitor Intelligence
        $pricingData = $competitorService->getPricingAnalysis($storeId);

        // System Alerts
        $alerts = \App\Models\SystemAlert::where('store_id', $storeId)
            ->latest()
            ->take(10)
            ->get();
        
        $employeeRisks = [];
        if (auth()->user() && (auth()->user()->role === 'owner' || auth()->user()->role === 'admin')) {
            $employeeRisks = \App\Models\EmployeeRiskScore::where('store_id', $storeId)
                ->with('user')
                ->latest('calculated_at')
                ->take(5)
                ->get();
        }

        return \Inertia\Inertia::render('Dashboard', [
            'totalProducts' => (int) $totalProducts, 
            'totalCustomers' => (int) $totalCustomers, 
            'todaySales' => (float) $todaySales, 
            'thisMonthSales' => (float) $thisMonthSales, 
            'pendingAlerts' => $pendingAlerts,
            'backupCount' => (int) $backupCount,
            'salesHistory' => $salesHistory,
            'topProducts' => $topProducts,
            'healthScore' => $healthScore,
            'riskScore' => $riskScore,
            'recommendations' => $recommendations,
            'cashflowProjections' => $cashflowProjections,
            'employeeRisks' => $employeeRisks,
            'aiInsights' => $aiInsights,
            'stockData' => $stockData,
            'pricingData' => $pricingData,
            'alerts' => $alerts
        ]);
    }

    public function getLiveMetrics()
    {
        $storeId = auth()->user()->store_id ?? 1;

        $todaySales = Transaction::where('store_id', $storeId)
            ->whereDate('created_at', now()->today())
            ->sum('grand_total');

        $todayTransactionCount = Transaction::where('store_id', $storeId)
            ->whereDate('created_at', now()->today())
            ->count();

        // Check for new high priority alerts
        $recentAlerts = \App\Models\SystemAlert::where('store_id', $storeId)
            ->latest()
            ->take(5)
            ->get();

        return response()->json([
            'todaySales' => (float) $todaySales,
            'todayTransactionCount' => (int) $todayTransactionCount,
            'alerts' => $recentAlerts
        ]);
    }
}
