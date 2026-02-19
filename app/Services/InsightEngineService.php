<?php

namespace App\Services;

use App\Models\Product;
use App\Models\Transaction;
use App\Models\TransactionItem;
use App\Models\AIInsight;
use Illuminate\Support\Facades\DB;

class InsightEngineService
{
    /**
     * Run all rules for a store and generate insights.
     */
    public function generateInsights(int $storeId)
    {
        $this->analyzePriceIncreases($storeId);
        $this->analyzeSlowMovers($storeId);
        $this->analyzeBundles($storeId);
        $this->analyzeDecliningTrends($storeId);
    }

    protected function analyzePriceIncreases(int $storeId)
    {
        // Rule: High demand (sold daily for last 14 days) + low margin (< 10%)
        $products = Product::where('store_id', $storeId)->get();

        // Optimize: Fetch sales counts for all products in one query
        $salesCounts = TransactionItem::whereIn('product_id', $products->pluck('id'))
            ->where('created_at', '>=', now()->subDays(14))
            ->select('product_id', DB::raw('COUNT(DISTINCT DATE(created_at)) as days_sold'))
            ->groupBy('product_id')
            ->pluck('days_sold', 'product_id');

        foreach ($products as $product) {
            $salesCount = $salesCounts[$product->id] ?? 0;

            $margin = $product->cost_price > 0 ? (($product->price - $product->cost_price) / $product->cost_price) : 0;

            if ($salesCount >= 12 && $margin < 0.12) {
                AIInsight::updateOrCreate(
                    ['store_id' => $storeId, 'type' => 'price_increase', 'suggestion_data->product_id' => $product->id, 'status' => 'pending'],
                    [
                        'title' => "Penyesuaian Harga: {$product->name}",
                        'description' => "Permintaan untuk {$product->name} sangat stabil tetapi margin tipis.",
                        'explanation' => "Produk ini terjual pada {$salesCount} dari 14 hari terakhir. Kenaikan harga 5% kemungkinan tidak akan mempengaruhi volume penjualan tetapi akan meningkatkan keuntungan sekitar Rp " . number_format($product->price * 0.05, 0),
                        'suggestion_data' => [
                            'product_id' => $product->id,
                            'current_price' => $product->price,
                            'suggested_price' => $product->price * 1.05
                        ],
                        'estimated_impact' => 50000, // Hardcoded placeholder for now
                    ]
                );
            }
        }
    }

    protected function analyzeSlowMovers(int $storeId)
    {
        // Rule: High stock (> 50) + low sales (< 5 items in last 30 days)
        $products = Product::where('store_id', $storeId)
            ->where('stock', '>', 50)
            ->get();

        // Optimize: Fetch total sold for all candidates in one query
        $salesData = TransactionItem::whereIn('product_id', $products->pluck('id'))
            ->where('created_at', '>=', now()->subDays(30))
            ->select('product_id', DB::raw('SUM(quantity) as total_sold'))
            ->groupBy('product_id')
            ->pluck('total_sold', 'product_id');

        foreach ($products as $product) {
            $totalSold = $salesData[$product->id] ?? 0;

            if ($totalSold < 5) {
                AIInsight::updateOrCreate(
                    ['store_id' => $storeId, 'type' => 'discount', 'suggestion_data->product_id' => $product->id, 'status' => 'pending'],
                    [
                        'title' => "Cuci Gudang: {$product->name}",
                        'description' => "Stok untuk {$product->name} tidak bergerak.",
                        'explanation' => "Anda memiliki {$product->stock} unit stok tetapi hanya terjual {$totalSold} dalam 30 hari terakhir. Pertimbangkan diskon 15% untuk membebaskan modal.",
                        'suggestion_data' => [
                            'product_id' => $product->id,
                            'current_price' => $product->price,
                            'suggested_price' => $product->price * 0.85
                        ],
                        'estimated_impact' => -10000, 
                    ]
                );
            }
        }
    }

    protected function analyzeBundles(int $storeId)
    {
        // Simplified Market Basket: Find top pairs bought together
        // Logic: Find transactions with multiple items
        $results = DB::table('transaction_items as t1')
            ->join('transaction_items as t2', 't1.transaction_id', '=', 't2.transaction_id')
            ->join('transactions', 't1.transaction_id', '=', 'transactions.id')
            ->where('transactions.store_id', $storeId)
            ->whereColumn('t1.product_id', '<', 't2.product_id') // Correct Laravel way for column comparison
            ->select('t1.product_id as p1', 't2.product_id as p2', DB::raw('COUNT(*) as frequency'))
            ->groupBy('p1', 'p2')
            ->orderByDesc('frequency')
            ->limit(3)
            ->get();

        foreach ($results as $res) {
            if ($res->frequency >= 3) {
                $p1 = Product::find($res->p1);
                $p2 = Product::find($res->p2);

                AIInsight::updateOrCreate(
                    ['store_id' => $storeId, 'type' => 'bundle', 'suggestion_data->p1' => $res->p1, 'suggestion_data->p2' => $res->p2, 'status' => 'pending'],
                    [
                        'title' => "Saran Bundling: {$p1->name} + {$p2->name}",
                        'description' => "Item ini sering dibeli bersamaan.",
                        'explanation' => "Pelanggan membeli kedua item ini bersamaan sebanyak {$res->frequency} kali baru-baru ini. Buat paket bundling untuk meningkatkan nilai transaksi rata-rata.",
                        'suggestion_data' => [
                            'p1' => $res->p1,
                            'p2' => $res->p2,
                            'bundle_price' => ($p1->price + $p2->price) * 0.95
                        ],
                        'estimated_impact' => 25000,
                    ]
                );
            }
        }
    }

    protected function analyzeDecliningTrends(int $storeId)
    {
        // Rule: Product sales declined by > 50% in the last 7 days compared to the previous 7 days
        $products = Product::where('store_id', $storeId)->get();
        $productIds = $products->pluck('id');

        // Optimize: Fetch current period sales
        $currentSales = TransactionItem::join('transactions', 'transaction_items.transaction_id', '=', 'transactions.id')
            ->whereIn('transaction_items.product_id', $productIds)
            ->where('transactions.transaction_date', '>=', now()->subDays(7))
            ->select('transaction_items.product_id', DB::raw('SUM(transaction_items.quantity) as total_qty'))
            ->groupBy('transaction_items.product_id')
            ->pluck('total_qty', 'product_id');

        // Optimize: Fetch previous period sales
        $previousSales = TransactionItem::join('transactions', 'transaction_items.transaction_id', '=', 'transactions.id')
            ->whereIn('transaction_items.product_id', $productIds)
            ->where('transactions.transaction_date', '>=', now()->subDays(14))
            ->where('transactions.transaction_date', '<', now()->subDays(7))
            ->select('transaction_items.product_id', DB::raw('SUM(transaction_items.quantity) as total_qty'))
            ->groupBy('transaction_items.product_id')
            ->pluck('total_qty', 'product_id');

        foreach ($products as $product) {
            $currentPeriodSales = $currentSales[$product->id] ?? 0;
            $previousPeriodSales = $previousSales[$product->id] ?? 0;

            // Only flag if it was actually a decent mover before (> 5 units)
            if ($previousPeriodSales >= 5 && $currentPeriodSales <= ($previousPeriodSales * 0.4)) {
                AIInsight::updateOrCreate(
                    ['store_id' => $storeId, 'type' => 'trend_decline', 'suggestion_data->product_id' => $product->id, 'status' => 'pending'],
                    [
                        'title' => "Tren Menurun: {$product->name}",
                        'description' => "Penjualan produk ini turun secara signifikan.",
                        'explanation' => "Produk ini terjual {$currentPeriodSales} unit minggu ini, dibandingkan dengan {$previousPeriodSales} minggu lalu (turun ~" . round((1 - ($previousPeriodSales > 0 ? $currentPeriodSales / $previousPeriodSales : 0)) * 100) . "%).",
                        'suggestion_data' => [
                            'product_id' => $product->id,
                            'current_sales' => $currentPeriodSales,
                            'previous_sales' => $previousPeriodSales
                        ],
                        'estimated_impact' => -20000, 
                    ]
                );
            }
        }
    }

    public function applyInsight(int $insightId)
    {
        $insight = AIInsight::findOrFail($insightId);
        $data = $insight->suggestion_data;

        DB::transaction(function() use ($insight, $data) {
            if ($insight->type === 'price_increase' || $insight->type === 'discount') {
                $product = Product::find($data['product_id']);
                if ($product) {
                    $product->update(['price' => $data['suggested_price']]);
                }
            }
            
            $insight->update([
                'status' => 'applied',
                'applied_at' => now()
            ]);
        });

        return true;
    }

    public function approveInsight(int $insightId)
    {
        $insight = AIInsight::findOrFail($insightId);
        $insight->update([
            'status' => 'approved',
            'approved_at' => now()
        ]);
        return true;
    }
}
