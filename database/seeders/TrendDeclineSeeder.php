<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Product;
use App\Models\Transaction;
use App\Models\TransactionItem;
use App\Models\Store;
use App\Models\User;
use Illuminate\Support\Str;

class TrendDeclineSeeder extends Seeder
{
    public function run(): void
    {
        $store = Store::first();
        $user = User::first();
        if (!$store || !$user) return;

        // Create a product that WAS popular but is now declining
        $decliningProduct = Product::updateOrCreate(
            ['barcode' => '888000444'],
            [
                'store_id' => $store->id,
                'name' => 'Kopi Kapal Api 165g',
                'price' => 12500,
                'cost_price' => 10000,
                'stock' => 50
            ]
        );

        // Previous 7 days: 10 sales
        for ($i = 7; $i < 12; $i++) {
             $tx = Transaction::create([
                'id' => (string) Str::uuid(),
                'store_id' => $store->id,
                'user_id' => $user->id,
                'invoice_number' => 'INV-TREND-OLD-' . $i,
                'subtotal' => 25000,
                'grand_total' => 25000,
                'payment_method' => 'cash',
                'transaction_date' => now()->subDays($i),
            ]);

            TransactionItem::create([
                'transaction_id' => $tx->id, 'product_id' => $decliningProduct->id, 'product_name' => $decliningProduct->name,
                'price' => 12500, 'cost_price' => 10000, 'quantity' => 2, 'total' => 25000
            ]);
        }

        // Current 7 days: Only 1 sale
        $tx = Transaction::create([
            'id' => (string) Str::uuid(),
            'store_id' => $store->id,
            'user_id' => $user->id,
            'invoice_number' => 'INV-TREND-NEW',
            'subtotal' => 12500,
            'grand_total' => 12500,
            'payment_method' => 'cash',
            'transaction_date' => now()->subDays(2),
        ]);

        TransactionItem::create([
            'transaction_id' => $tx->id, 'product_id' => $decliningProduct->id, 'product_name' => $decliningProduct->name,
            'price' => 12500, 'cost_price' => 10000, 'quantity' => 1, 'total' => 12500
        ]);

        // Trigger Insight Generator
        app(\App\Services\InsightEngineService::class)->generateInsights($store->id);
    }
}
