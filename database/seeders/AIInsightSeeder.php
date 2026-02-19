<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Product;
use App\Models\Transaction;
use App\Models\TransactionItem;
use App\Models\Store;
use App\Models\User;
use Illuminate\Support\Str;

class AIInsightSeeder extends Seeder
{
    public function run(): void
    {
        $store = Store::first();
        $user = User::first();
        if (!$store || !$user) return;

        // 1. Prepare products for "Price Increase" rule
        $stableProduct = Product::updateOrCreate(
            ['barcode' => '888000111'],
            [
                'store_id' => $store->id,
                'name' => 'Beras Anak Raja 5kg',
                'price' => 65000,
                'cost_price' => 60000,
                'stock' => 100
            ]
        );

        for ($i = 0; $i < 14; $i++) {
            $tx = Transaction::firstOrCreate(
                ['invoice_number' => 'INV-STABLE-' . $i, 'store_id' => $store->id],
                [
                    'id' => (string) Str::uuid(),
                    'user_id' => $user->id,
                    'subtotal' => 65000,
                    'grand_total' => 65000,
                    'payment_method' => 'cash',
                    'transaction_date' => now()->subDays($i),
                ]
            );

            TransactionItem::firstOrCreate(
                ['transaction_id' => $tx->id, 'product_id' => $stableProduct->id],
                [
                    'product_name' => $stableProduct->name,
                    'price' => 65000, 'cost_price' => 60000, 'quantity' => 1, 'total' => 65000
                ]
            );
        }

        // 2. Prepare products for "Slow Mover" rule
        Product::updateOrCreate(
            ['barcode' => '888000222'],
            [
                'store_id' => $store->id,
                'name' => 'Payung Pelangi (Seasonal)',
                'price' => 45000,
                'cost_price' => 30000,
                'stock' => 60
            ]
        );

        // 3. Prepare products for "Bundle" rule
        $p1 = Product::updateOrCreate(
            ['barcode' => '888000331'],
            ['store_id' => $store->id, 'name' => 'Indomie Goreng', 'price' => 3000, 'cost_price' => 2500, 'stock' => 200]
        );
        $p2 = Product::updateOrCreate(
            ['barcode' => '888000332'],
            ['store_id' => $store->id, 'name' => 'Telur Ayam (Butir)', 'price' => 2000, 'cost_price' => 1600, 'stock' => 500]
        );

        for ($i = 0; $i < 5; $i++) {
            $tx = Transaction::firstOrCreate(
                ['invoice_number' => 'INV-BUNDLE-' . $i, 'store_id' => $store->id],
                [
                    'id' => (string) Str::uuid(),
                    'user_id' => $user->id,
                    'subtotal' => 5000,
                    'grand_total' => 5000,
                    'payment_method' => 'cash',
                    'transaction_date' => now()->subDays($i),
                ]
            );

            TransactionItem::firstOrCreate(['transaction_id' => $tx->id, 'product_id' => $p1->id], ['product_name' => $p1->name, 'price' => 3000, 'cost_price' => 2500, 'quantity' => 1, 'total' => 3000]);
            TransactionItem::firstOrCreate(['transaction_id' => $tx->id, 'product_id' => $p2->id], ['product_name' => $p2->name, 'price' => 2000, 'cost_price' => 1600, 'quantity' => 1, 'total' => 2000]);
        }

        // 4. Trigger Insight Generator
        app(\App\Services\InsightEngineService::class)->generateInsights($store->id);
    }
}
