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
use App\Services\PricingService;
use App\Services\ConsolidationService;
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
        AlertService $alertService,
        ConsolidationService $consolidationService,
        PricingService $pricingService
    ) {
        $storeId = auth()->user()->store_id ?? 1;
        $cacheKey = "dashboard_metrics_store_{$storeId}";

        $data = \Illuminate\Support\Facades\Cache::remember($cacheKey, now()->addMinutes(10), function() use (
            $storeId, 
            $replenishmentService, 
            $cashflowService, 
            $stockService, 
            $competitorService,
            $consolidationService,
            $pricingService
        ) {
            // Initialize defaults
            $totalProducts = 0;
            $totalCustomers = 0;
            $todaySales = 0;
            $thisMonthSales = 0;
            $pendingAlerts = [];
            $backupCount = 0;
            $salesHistory = [];
            $topProducts = [];
            $recommendations = [];
            $cashflowProjections = [];
            $stockData = null;
            $pricingData = [];
            $alerts = [];

            // 1. Basic Metrics
            try {
                $totalProducts = Product::where('store_id', $storeId)->count();
                $totalCustomers = Customer::where('store_id', $storeId)->count();
                
                $todaySales = Transaction::where('store_id', $storeId)
                    ->whereDate('created_at', now()->today())
                    ->sum('grand_total');

                $thisMonthSales = Transaction::where('store_id', $storeId)
                    ->whereMonth('created_at', now()->month)
                    ->sum('grand_total');

                $pendingAlerts = FraudAlert::where('resolved_at', null)->latest()->take(5)->get();
            } catch (\Throwable $e) {
                \Illuminate\Support\Facades\Log::error("Dashboard Basic Metrics Error: " . $e->getMessage());
            }

            // 2. System Health
            try {
                $backupCount = count(Storage::files('backups'));
            } catch (\Throwable $e) {}
            
            // 3. Charts & Analytics
            try {
                $salesHistory = Transaction::where('store_id', $storeId)
                    ->where('created_at', '>=', now()->subDays(30))
                    ->select(DB::raw("DATE(created_at) as date"), DB::raw("SUM(grand_total) as total"))
                    ->groupBy('date')
                    ->orderBy('date')
                    ->get()
                    ->mapWithKeys(fn($item) => [$item->date => (float)$item->total])
                    ->toArray();

                $topProducts = DB::table('transaction_items')
                    ->join('products', 'transaction_items.product_id', '=', 'products.id')
                    ->select('products.name', DB::raw('SUM(transaction_items.quantity) as total_sold'), DB::raw('SUM(transaction_items.total) as revenue'))
                    ->where('products.store_id', $storeId)
                    ->groupBy('products.id', 'products.name')
                    ->orderBy('revenue', 'desc')
                    ->take(5)
                    ->get();
            } catch (\Throwable $e) {
                \Illuminate\Support\Facades\Log::error("Dashboard Analytics Error: " . $e->getMessage());
            }

            // 4. Advanced Services (Fetch existing data instead of regenerating for speed)
            try {
                $recommendations = $replenishmentService->getRecommendations($storeId);
                $cashflowProjections = \App\Models\CashflowProjection::where('store_id', $storeId)
                    ->where('projection_date', '>=', now()->toDateString())
                    ->orderBy('projection_date')
                    ->take(30)
                    ->get();

                $stockData = $stockService->getStockMetrics($storeId);
                $pricingData = $competitorService->getPricingAnalysis($storeId);

                $alerts = \App\Models\SystemAlert::where('store_id', $storeId)
                    ->latest()
                    ->take(10)
                    ->get();
            } catch (\Throwable $e) {
                \Illuminate\Support\Facades\Log::error("Dashboard Services Error: " . $e->getMessage());
            }

            // 5. Enterprise Consolidation (HQ Level)
            $consolidatedData = [];
            $marginAlerts = [];
            try {
                // If user is Owner/Admin, show group performance
                if (auth()->user()->role === 'owner' || auth()->user()->role === 'admin') {
                    $consolidatedData = $consolidationService->getConsolidatedSales(now()->startOfMonth(), now()->endOfMonth());
                }

                // Check for margin violations
                $lowMarginProducts = Product::where('store_id', $storeId)
                    ->whereRaw('(price - cost_price) / NULLIF(price, 0) * 100 < min_margin')
                    ->take(5)
                    ->get();
                
                foreach ($lowMarginProducts as $product) {
                    $marginAlerts[] = [
                        'name' => $product->name,
                        'current_margin' => $pricingService->calculateMargin($product, $product->price),
                        'min_margin' => $product->min_margin
                    ];
                }
            } catch (\Throwable $e) {
                \Illuminate\Support\Facades\Log::error("Dashboard Enterprise Error: " . $e->getMessage());
            }

            return compact(
                'totalProducts', 'totalCustomers', 'todaySales', 'thisMonthSales', 
                'pendingAlerts', 'backupCount', 'salesHistory', 'topProducts', 
                'recommendations', 'cashflowProjections', 'stockData', 'pricingData', 'alerts',
                'consolidatedData', 'marginAlerts'
            );
        });

        // Data that shouldn't be cached long-term or needs fresh lookup
        $healthScore = BusinessHealthScore::where('store_id', $storeId)->latest('calculated_at')->first();
        $riskScore = ProfitRiskScore::where('store_id', $storeId)->whereNull('user_id')->latest('calculated_at')->first();
        $aiInsights = \App\Models\AIInsight::where('store_id', $storeId)
            ->where('status', 'pending')
            ->latest()
            ->get();

        $employeeRisks = [];
        if (auth()->user() && (auth()->user()->role === 'owner' || auth()->user()->role === 'admin')) {
            $employeeRisks = \App\Models\EmployeeRiskScore::where('store_id', $storeId)
                ->with('user')
                ->latest('calculated_at')
                ->take(5)
                ->get();
        }

        return \Inertia\Inertia::render('Dashboard', array_merge($data, [
            'healthScore' => $healthScore,
            'riskScore' => $riskScore,
            'employeeRisks' => $employeeRisks,
            'aiInsights' => $aiInsights,
        ]));
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
