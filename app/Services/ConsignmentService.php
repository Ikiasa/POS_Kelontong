<?php

namespace App\Services;

use App\Models\Product;
use App\Models\Supplier;
use App\Models\TransactionItem;
use Illuminate\Support\Facades\DB;

class ConsignmentService
{
    /**
     * Calculate the payout amount for a supplier based on sold consignment items.
     */
    public function calculatePayout(int $supplierId, string $startDate, string $endDate): array
    {
        $soldItems = TransactionItem::whereHas('product', function($q) use ($supplierId) {
                $q->where('supplier_id', $supplierId)
                  ->where('is_consignment', true);
            })
            ->whereBetween('created_at', [$startDate, $endDate])
            ->get();

        $totalPayout = 0;
        $itemsBreakdown = [];

        foreach ($soldItems as $item) {
            $product = $item->product;
            
            // Payout calculation: (Cost Price OR Net Price - Commission)
            // If commission_rate is 10%, store keeps 10%, payout is 90%
            $payoutPerUnit = $item->cost_price;
            
            if ($product->commission_rate > 0) {
                $payoutPerUnit = $item->price * (1 - ($product->commission_rate / 100));
            }

            $subtotal = $payoutPerUnit * $item->quantity;
            $totalPayout += $subtotal;

            $itemsBreakdown[] = [
                'name' => $product->name,
                'quantity' => $item->quantity,
                'sold_price' => $item->price,
                'payout_per_unit' => $payoutPerUnit,
                'subtotal' => $subtotal
            ];
        }

        return [
            'supplier_id' => $supplierId,
            'total_payout' => $totalPayout,
            'items' => $itemsBreakdown
        ];
    }
}
