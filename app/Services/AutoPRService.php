<?php

namespace App\Services;

use App\Models\Product;
use App\Models\PurchaseRequest;
use App\Models\PurchaseRequestItem;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class AutoPRService
{
    /**
     * Run the automated Purchase Request generation logic.
     */
    public function generateRequests(int $storeId): ?PurchaseRequest
    {
        // 1. Find products below min_stock that don't have a pending PR already
        $lowStockProducts = Product::where('store_id', $storeId)
            ->whereColumn('stock', '<', 'min_stock')
            ->whereDoesntHave('purchaseRequestItems', function($q) {
                $q->whereHas('purchaseRequest', function($pr) {
                    $pr->whereIn('status', ['draft', 'submitted', 'approved']);
                });
            })
            ->get();

        if ($lowStockProducts->isEmpty()) {
            return null;
        }

        return DB::transaction(function () use ($lowStockProducts, $storeId) {
            // 2. Create the Purchase Request
            $pr = PurchaseRequest::create([
                'store_id' => $storeId,
                'user_id' => 1, // System User / Admin
                'pr_number' => 'AUTOPR-' . strtoupper(Str::random(8)),
                'status' => 'draft',
                'notes' => 'Generated automatically by Inventory Intelligence System.'
            ]);

            // 3. Add items
            foreach ($lowStockProducts as $product) {
                PurchaseRequestItem::create([
                    'purchase_request_id' => $pr->id,
                    'product_id' => $product->id,
                    'quantity' => $product->suggested_order_qty,
                    'estimated_cost' => $product->cost_price ?? 0
                ]);
            }

            return $pr;
        });
    }
}
