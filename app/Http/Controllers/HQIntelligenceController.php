<?php

namespace App\Http\Controllers;

use App\Models\Product;
use App\Models\Store;
use App\Services\ConsolidationService;
use App\Services\PricingService;
use App\Services\ReplenishmentService;
use Illuminate\Http\Request;
use Inertia\Inertia;

class HQIntelligenceController extends Controller
{
    public function index(
        ConsolidationService $consolidationService,
        PricingService $pricingService,
        ReplenishmentService $replenishmentService
    ) {
        $storeId = auth()->user()->store_id ?? 1;

        // 1. Group Consolidation
        $consolidatedSales = $consolidationService->getConsolidatedSales(
            now()->startOfMonth(), 
            now()->endOfMonth()
        );

        // 2. Margin Guardian
        $marginViolations = Product::whereRaw('(price - cost_price) / NULLIF(price, 0) * 100 < min_margin')
            ->with('store')
            ->take(10)
            ->get()
            ->map(function($product) use ($pricingService) {
                return [
                    'id' => $product->id,
                    'name' => $product->name,
                    'store' => $product->store->name ?? 'Unknown',
                    'price' => $product->price,
                    'cost' => $product->cost_price,
                    'margin' => $pricingService->calculateMargin($product, $product->price),
                    'target_margin' => $product->min_margin,
                ];
            });

        // 3. Global Replenishment Alerts
        $replenishmentNeeded = Product::whereRaw('stock <= min_stock')
            ->with('store')
            ->take(10)
            ->get();

        // 4. Branch Profit Comparison
        $branches = Store::all()->map(function($store) {
            $sales = \App\Models\Transaction::where('store_id', $store->id)
                ->whereMonth('created_at', now()->month)
                ->sum('grand_total');
            
            return [
                'name' => $store->name,
                'monthly_sales' => (float)$sales,
                'status' => $sales > 10000000 ? 'healthy' : 'warning',
            ];
        });

        return Inertia::render('Analytics/HQIntelligence', [
            'consolidated' => $consolidatedSales,
            'marginViolations' => $marginViolations,
            'replenishment' => $replenishmentNeeded,
            'branches' => $branches,
        ]);
    }
}
