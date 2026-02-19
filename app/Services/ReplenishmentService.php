<?php

namespace App\Services;

use App\Models\Product;
use App\Models\TransactionItem;
use App\Models\PurchaseOrder;
use App\Models\PurchaseOrderItem;
use App\Models\Supplier;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class ReplenishmentService
{
    /**
     * Calculate reorder recommendations for a store.
     */
    public function getRecommendations(int $storeId)
    {
        $products = Product::where('store_id', $storeId)->with('supplier')->get();
        $recommendations = [];

        // Optimizing: Fetch sales data for all products in one query
        $salesData = TransactionItem::whereIn('product_id', $products->pluck('id'))
            ->where('created_at', '>=', now()->subDays(30))
            ->select('product_id', DB::raw('SUM(quantity) as total_qty'))
            ->groupBy('product_id')
            ->pluck('total_qty', 'product_id');

        // Optimizing: Fetch On Stock data for all products in one query
        $onOrderData = PurchaseOrderItem::whereIn('product_id', $products->pluck('id'))
            ->whereHas('purchaseOrder', function($q) use ($storeId) {
                $q->where('store_id', $storeId)->whereIn('status', ['suggested', 'sent']);
            })
            ->select('product_id', DB::raw('SUM(quantity) as total_qty'))
            ->groupBy('product_id')
            ->pluck('total_qty', 'product_id');

        foreach ($products as $product) {
            // Use pre-fetched sales data
            $totalSales = $salesData[$product->id] ?? 0;
            $dailySalesAvg = $totalSales / 30;
            
            // Reorder formula: (Lead Time + Projection Days) * Avg Sales + Safety Stock
            $leadTime = $product->lead_time_days ?? ($product->supplier->default_lead_time_days ?? 3);
            $projectionDays = 30;
            $safetyStock = $product->safety_stock ?? 10;
            
            $requiredStock = ($leadTime + $projectionDays) * $dailySalesAvg + $safetyStock;
            
            // Use pre-fetched on-order data
            $onOrder = $onOrderData[$product->id] ?? 0;

            $netStock = $product->stock + $onOrder;

            if ($netStock < $requiredStock) {
                $suggestedQty = ceil($requiredStock - $netStock);
                
                $recommendations[] = [
                    'product_id' => $product->id,
                    'product_name' => $product->name,
                    'supplier_id' => $product->supplier_id,
                    'supplier_name' => $product->supplier->name ?? 'Unknown',
                    'current_stock' => $product->stock,
                    'avg_daily_sales' => $dailySalesAvg,
                    'on_order' => $onOrder,
                    'suggested_qty' => $suggestedQty,
                    'projection' => $this->simulate30DayProjection($product->stock, $dailySalesAvg, $onOrder),
                    'explanation' => "Based on lead time ($leadTime days) and 30-day sales velocity.",
                ];
            }
        }

        return $this->groupBySupplier($recommendations);
    }

    protected function calculateDailySalesAvg(int $productId, int $days)
    {
        $totalSales = TransactionItem::where('product_id', $productId)
            ->where('created_at', '>=', now()->subDays($days))
            ->sum('quantity');
        
        return $totalSales / $days;
    }

    protected function simulate30DayProjection($currentStock, $dailySalesAvg, $onOrder)
    {
        $projection = [];
        $runningStock = $currentStock + $onOrder;
        
        for ($day = 1; $day <= 30; $day++) {
            $runningStock -= $dailySalesAvg;
            if ($day % 7 == 0) { // Keep data light
                $projection[] = ['day' => $day, 'stock' => max($runningStock, 0)];
            }
        }
        
        return $projection;
    }

    protected function groupBySupplier(array $recommendations)
    {
        $grouped = [];
        foreach ($recommendations as $rec) {
            $sid = $rec['supplier_id'] ?? 0;
            if (!isset($grouped[$sid])) {
                $grouped[$sid] = [
                    'supplier_name' => $rec['supplier_name'],
                    'items' => [],
                    'total_items' => 0,
                ];
            }
            $grouped[$sid]['items'][] = $rec;
            $grouped[$sid]['total_items'] += 1;
        }
        return $grouped;
    }

    public function createSuggestedPO(int $storeId, int $supplierId, array $productIds)
    {
        // Actually generate a PO record with 'suggested' status
        // Logic to be refined based on user feedback
    }
}
