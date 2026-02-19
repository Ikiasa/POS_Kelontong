<?php

namespace App\Services;

use App\Models\Product;
use Illuminate\Support\Collection;
use Carbon\Carbon;

class DeadStockService
{
    /**
     * Identify products that haven't sold in X days.
     */
    public function getDeadStock(int $storeId, int $daysThreshold = 60): Collection
    {
        $thresholdDate = Carbon::now()->subDays($daysThreshold);

        return Product::where('store_id', $storeId)
            ->where('stock', '>', 0) // Only care if we have stock holding value
            ->where(function ($query) use ($thresholdDate) {
                $query->where('last_sold_at', '<', $thresholdDate)
                      ->orWhere(function ($q) use ($thresholdDate) {
                          $q->whereNull('last_sold_at')
                            ->where('created_at', '<', $thresholdDate);
                      });
            })
            ->with('category')
            ->get()
            ->map(function ($product) use ($daysThreshold) {
                // Calculate potential loss/tied up capital
                $tiedUpCapital = $product->stock * $product->cost_price;
                
                // Days since last sale
                $daysInactive = $product->last_sold_at 
                    ? Carbon::parse($product->last_sold_at)->diffInDays(now()) 
                    : Carbon::parse($product->created_at)->diffInDays(now());

                return [
                    'product_id' => $product->id,
                    'name' => $product->name,
                    'category' => $product->category->name ?? 'Uncategorized',
                    'stock' => $product->stock,
                    'cost_price' => $product->cost_price,
                    'tied_capital' => $tiedUpCapital,
                    'last_sold_at' => $product->last_sold_at,
                    'days_inactive' => $daysInactive,
                    'suggested_action' => $daysInactive > 90 ? 'Clearance (50% Off)' : 'Discount (20% Off)',
                ];
            })
            ->sortByDesc('days_inactive');
    }
}
