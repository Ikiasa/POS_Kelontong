<?php

namespace App\Services;

use App\Models\Product;
use App\Models\PurchaseRequest;
use App\Models\PurchaseRequestItem;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class AutoReplenishmentService
{
    /**
     * Run the scan and generate PRs for all low-stock items
     */
    public function run(int $storeId): ?PurchaseRequest
    {
        return DB::transaction(function () use ($storeId) {
            // Find products below min_stock
            $lowStockProducts = Product::where('store_id', $storeId)
                ->whereRaw('stock <= min_stock')
                ->get();

            if ($lowStockProducts->isEmpty()) {
                return null;
            }

            // Create PR
            $pr = PurchaseRequest::create([
                'store_id' => $storeId,
                'user_id' => auth()->id() ?? 1, // Fallback to admin if run by system
                'pr_number' => 'PR-' . strtoupper(Str::random(8)),
                'status' => 'draft',
                'notes' => 'Generated automatically by Inventory AI Assistant for low-stock items.',
            ]);

            foreach ($lowStockProducts as $product) {
                PurchaseRequestItem::create([
                    'purchase_request_id' => $pr->id,
                    'product_id' => $product->id,
                    'quantity' => $product->suggested_order_qty,
                    'estimated_cost' => $product->cost_price * $product->suggested_order_qty,
                ]);
            }

            return $pr;
        });
    }
}
