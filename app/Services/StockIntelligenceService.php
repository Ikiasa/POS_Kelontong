<?php

namespace App\Services;

use App\Models\Product;
use App\Models\TransactionItem;
use Illuminate\Support\Facades\DB;

class StockIntelligenceService
{
    protected $alertService;

    public function __construct(AlertService $alertService)
    {
        $this->alertService = $alertService;
    }

    public function getStockMetrics(int $storeId)
    {
        $products = Product::where('store_id', $storeId)->get();
        $metrics = [];
        $totalCapitalLocked = 0;

        foreach ($products as $product) {
            $last30DaysSales = TransactionItem::where('product_id', $product->id)
                ->where('created_at', '>=', now()->subDays(30))
                ->sum('quantity');

            $velocity = $last30DaysSales / 30; // Average per day
            
            $classification = 'dead';
            if ($velocity > 2) $classification = 'fast';
            elseif ($velocity > 0.5) $classification = 'medium';
            elseif ($velocity > 0) $classification = 'slow';

            // Threshold Alert Trigger
            if ($product->stock <= 10 && $classification === 'fast') {
                $this->alertService->trigger(
                    $storeId,
                    'low_stock',
                    "CRITICAL: Fast-moving product '{$product->name}' is almost out of stock ({$product->stock} remaining).",
                    'critical',
                    ['product_id' => $product->id, 'stock' => $product->stock]
                );
            }

            $capitalLocked = $product->stock * $product->cost_price;
            $totalCapitalLocked += $capitalLocked;

            // Turnover Calculation
            // Simplified: Sales COGS / Average Inventory Value
            // For now, let's use Sales Quantity / Current Stock as a proxy for velocity ratio
            $turnoverRatio = $product->stock > 0 ? ($last30DaysSales / $product->stock) : 0;
            $daysOnHand = $velocity > 0 ? ($product->stock / $velocity) : ($product->stock > 0 ? 999 : 0);

            $metrics[] = [
                'product' => $product,
                'classification' => $classification,
                'velocity' => round($velocity, 2),
                'capital_locked' => $capitalLocked,
                'turnover_ratio' => round($turnoverRatio, 2),
                'days_on_hand' => round($daysOnHand, 0),
            ];
        }

        return [
            'products' => $metrics,
            'total_capital_locked' => $totalCapitalLocked,
            'summary' => [
                'fast' => collect($metrics)->where('classification', 'fast')->count(),
                'medium' => collect($metrics)->where('classification', 'medium')->count(),
                'slow' => collect($metrics)->where('classification', 'slow')->count(),
                'dead' => collect($metrics)->where('classification', 'dead')->count(),
            ]
        ];
    }
}
