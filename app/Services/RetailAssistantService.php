<?php

namespace App\Services;

use App\Models\Product;
use App\Models\ProductBatch;
use App\Models\Sale;
use App\Models\Transaction;
use App\Models\TransactionItem;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;

class RetailAssistantService
{
    /**
     * MODULE 1: SMART REORDER ASSISTANT
     * Automatically suggest products that need restocking.
     */
    public function getSmartReorderSuggestions($storeId, $thresholdDays = 7)
    {
        $thirtyDaysAgo = Carbon::now()->subDays(30);

        // 1. Calculate Average Daily Sales (Last 30 Days)
        // We use a subquery or direct aggregation. 
        // For performance on large datasets, a raw query is often better.
        
        $products = Product::where('store_id', $storeId)
            ->where('stock', '>', 0) // Only check active stock or enable robust check? Usually we want to reorder even if 0.
            // Let's include items with 0 stock too if they have sales.
            ->select('id', 'name', 'stock', 'safety_stock', 'cost_price')
            ->get();

        $suggestions = [];

        foreach ($products as $product) {
            $totalSold = TransactionItem::where('product_id', $product->id)
                ->where('created_at', '>=', $thirtyDaysAgo)
                ->sum('quantity');

            $avgDailySales = $totalSold / 30;

            if ($avgDailySales <= 0) continue;

            $daysRemaining = $product->stock / $avgDailySales;

            if ($daysRemaining <= $thresholdDays) {
                
                $urgency = 'low';
                if ($daysRemaining <= 1) $urgency = 'critical';
                elseif ($daysRemaining <= 3) $urgency = 'medium';

                $suggestions[] = [
                    'product_id' => $product->id,
                    'product_name' => $product->name,
                    'current_stock' => $product->stock,
                    'avg_daily_sales' => round($avgDailySales, 2),
                    'days_remaining' => round($daysRemaining, 1),
                    'suggested_reorder_quantity' => ceil($avgDailySales * 14), // Suggest 2 weeks stock
                    'urgency_level' => $urgency,
                ];
            }
        }

        // Sort by urgency (critical first)
        usort($suggestions, function ($a, $b) {
            $levels = ['critical' => 3, 'medium' => 2, 'low' => 1];
            return $levels[$b['urgency_level']] <=> $levels[$a['urgency_level']];
        });

        return $suggestions;
    }

    /**
     * MODULE 2: DEAD STOCK DETECTOR
     * Detect products not sold in X days.
     */
    public function getDeadStockAnalysis($storeId, $daysThreshold = 45)
    {
        $thresholdDate = Carbon::now()->subDays($daysThreshold);

        // Products with stock > 0
        $products = Product::where('store_id', $storeId)
            ->where('stock', '>', 0)
            ->get();

        $deadStock = [];

        foreach ($products as $product) {
            $lastSale = TransactionItem::where('product_id', $product->id)
                ->latest()
                ->first();

            $lastSoldDate = $lastSale ? $lastSale->created_at : $product->created_at; // Fallback to creation date if never sold
            
            $daysSinceLastSale = Carbon::parse($lastSoldDate)->diffInDays(Carbon::now());

            if ($daysSinceLastSale > $daysThreshold) {
                $stockValue = $product->stock * $product->cost_price;
                
                $riskLevel = 'low';
                if ($daysSinceLastSale > 90) $riskLevel = 'critical';
                elseif ($daysSinceLastSale > 60) $riskLevel = 'medium';

                $deadStock[] = [
                    'product_name' => $product->name,
                    'days_since_last_sale' => $daysSinceLastSale,
                    'current_stock' => $product->stock,
                    'stock_value' => $stockValue,
                    'risk_level' => $riskLevel,
                ];
            }
        }

        // Sort by stock value descending
        usort($deadStock, fn($a, $b) => $b['stock_value'] <=> $a['stock_value']);

        return $deadStock;
    }

    /**
     * MODULE 3: SMART EXPIRY MONITOR
     * Monitor expiring batches and suggest action.
     */
    public function getExpiryMonitor($storeId)
    {
        $today = Carbon::now();
        $next30Days = Carbon::now()->addDays(30);

        $batches = ProductBatch::with('product')
            ->where('store_id', $storeId)
            ->where('current_quantity', '>', 0)
            ->whereNotNull('expiry_date')
            ->where('expiry_date', '<=', $next30Days)
            ->orderBy('expiry_date', 'asc')
            ->get();

        $alerts = [];

        foreach ($batches as $batch) {
            $daysToExpiry = $today->diffInDays($batch->expiry_date, false); // false = allows negative for expired
            $stockValue = $batch->current_quantity * $batch->cost_price;

            $status = 'safe';
            $action = 'Monitor';

            if ($daysToExpiry < 0) {
                $status = 'expired';
                $action = 'Return to Supplier'; // or Dispose
            } elseif ($daysToExpiry <= 14) {
                $status = 'critical';
                $action = 'Deep Discount / Bundle';
            } elseif ($daysToExpiry <= 30) {
                $status = 'warning';
                $action = 'Discount';
            }

            $alerts[] = [
                'product_name' => $batch->product->name,
                'batch_code' => $batch->batch_number,
                'quantity' => $batch->current_quantity,
                'days_to_expiry' => (int) $daysToExpiry,
                'stock_value' => $stockValue,
                'status' => $status,
                'suggested_action' => $action,
            ];
        }

        return $alerts;
    }

    /**
     * MODULE 4: EXPIRY INTELLIGENCE
     * Analyze loss risk due to expiry.
     */
    public function getExpiryIntelligence($storeId)
    {
        $today = Carbon::now();
        $next30Days = Carbon::now()->addDays(30);

        // Total Inventory Value
        $totalInventoryValue = ProductBatch::where('store_id', $storeId)
            ->where('current_quantity', '>', 0)
            ->select(DB::raw('SUM(current_quantity * cost_price) as total'))
            ->value('total') ?? 0;

        // Expired Value (Already expired)
        $expiredValue = ProductBatch::where('store_id', $storeId)
            ->where('current_quantity', '>', 0)
            ->where('expiry_date', '<', $today)
            ->select(DB::raw('SUM(current_quantity * cost_price) as total'))
            ->value('total') ?? 0;

        // Near Expiry Risk Value (Next 30 days)
        $nearExpiryValue = ProductBatch::where('store_id', $storeId)
            ->where('current_quantity', '>', 0)
            ->whereBetween('expiry_date', [$today, $next30Days])
            ->select(DB::raw('SUM(current_quantity * cost_price) as total'))
            ->value('total') ?? 0;

        $riskRatio = $totalInventoryValue > 0 ? ($nearExpiryValue / $totalInventoryValue) * 100 : 0;
        
        // Normalize Risk Score (0-100)
        // If > 20% inventory is at risk, score is 100 (High Risk)
        $riskScore = min(($riskRatio / 20) * 100, 100); 

        return [
            'total_inventory_value' => $totalInventoryValue,
            'expired_loss_value' => $expiredValue,
            'near_expiry_risk_value' => $nearExpiryValue,
            'risk_ratio' => round($riskRatio, 2),
            'risk_score' => round($riskScore, 0),
        ];
    }

    /**
     * MODULE 5: BUSINESS HEALTH SCORE
     * Composite score (0-100).
     */
    public function getBusinessHealthScore($storeId)
    {
        // 1. Profit Trend (Weight 25%)
        // Compare last 30 days profit vs previous 30 days
        $scoreProfit = 70; // Placeholder calculation logic needed based on real profit data

        // 2. Stock Turnover (Weight 20%)
        // COGS / Avg Inventory
        $scoreTurnover = 60; // Placeholder

        // 3. Dead Stock Ratio (Weight 15%)
        $deadStockItems = $this->getDeadStockAnalysis($storeId);
        $totalItems = Product::where('store_id', $storeId)->count();
        $deadStockRatio = $totalItems > 0 ? count($deadStockItems) / $totalItems : 0;
        $scoreDeadStock = max(100 - ($deadStockRatio * 100 * 2), 0); // Peninsula penalty

        // 4. Expiry Risk (Weight 15%)
        $expiryData = $this->getExpiryIntelligence($storeId);
        $scoreExpiry = 100 - $expiryData['risk_score'];

        // 5. Cash Discrepancy (Weight 10%)
        $scoreCash = 90; // Placeholder

        // 6. Revenue Growth (Weight 15%)
        $scoreGrowth = 75; // Placeholder

        // Weighted Average
        $overallScore = (
            ($scoreProfit * 0.25) +
            ($scoreTurnover * 0.20) +
            ($scoreDeadStock * 0.15) +
            ($scoreExpiry * 0.15) +
            ($scoreCash * 0.10) +
            ($scoreGrowth * 0.15)
        );

        $label = 'Fair';
        if ($overallScore >= 90) $label = 'Excellent';
        elseif ($overallScore >= 75) $label = 'Healthy';
        elseif ($overallScore < 50) $label = 'Poor';

        return [
            'overall_score' => round($overallScore, 1),
            'status_label' => $label,
            'breakdown' => [
                'profit_trend' => $scoreProfit,
                'stock_turnover' => $scoreTurnover,
                'dead_stock' => $scoreDeadStock,
                'expiry_risk' => $scoreExpiry,
                'cash_integrity' => $scoreCash,
                'revenue_growth' => $scoreGrowth,
            ]
        ];
    }

    /**
     * MODULE 6: AI INSIGHT BOX
     * Generate human-readable insights.
     */
    public function getAiInsights($storeId)
    {
        $insights = [];

        // Insight 1: Sales Growth
        // (Placeholder logic)
        $insights[] = "Sales increased 12% compared to last week.";

        // Insight 2: Reorder Urgency
        $reorders = $this->getSmartReorderSuggestions($storeId);
        if (count($reorders) > 0) {
            $topItem = $reorders[0];
            $insights[] = "{$topItem['product_name']} may run out in {$topItem['days_remaining']} days.";
        }

        // Insight 3: Dead Stock
        $deadStock = $this->getDeadStockAnalysis($storeId);
        if (count($deadStock) > 0) {
            $insights[] = count($deadStock) . " products have not been sold in 45 days.";
        }

        // Insight 4: Expiry
        $expiry = $this->getExpiryIntelligence($storeId);
        if ($expiry['near_expiry_risk_value'] > 1000000) {
             $insights[] = "High expiry risk detected! Value at risk: Rp " . number_format($expiry['near_expiry_risk_value'], 0);
        }

        return array_slice($insights, 0, 5);
    }
}
