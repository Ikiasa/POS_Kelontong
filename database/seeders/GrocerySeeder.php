<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Customer;
use App\Models\Product;
use App\Models\Store;
use App\Models\Transaction;
use App\Models\TransactionItem;
use App\Models\TransactionPayment;
use App\Models\User;
use App\Services\JournalService;
use Carbon\Carbon;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class GrocerySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $journalService = app(JournalService::class);

        // 1. Create/Find Store
        $store = Store::firstOrCreate(
            ['name' => 'Kelontong Madura Barokah'],
            ['address' => 'Jl. Raya Margonda No. 12']
        );

        // 2. Create/Find User
        User::firstOrCreate(
            ['email' => 'owner@kelontong.com'],
            [
                'name' => 'H. Maimun',
                'password' => bcrypt('password'),
                'role' => 'owner',
                'store_id' => $store->id
            ]
        );

        // 3. Categories
        $categories = [
            'Sembako' => ['Beras Cianjur', 'Minyak Goreng Bimoli', 'Gula Pasir Gulaku', 'Telur Ayam'],
            'Minuman' => ['Aqua 600ml', 'Teh Pucuk Harum', 'Kopi Kapal Api', 'Susu Indomilk'],
            'Snack' => ['Indomie Goreng', 'Sarimi', 'Chitato', 'Taro', 'Chocolatos'],
            'Sabun & Diterjen' => ['Rinso Anti Noda', 'Sunlight', 'Lifebuoy', 'Pepsodent'],
            'Rokok' => ['Sampoerna Mild', 'Gudang Garam Filter', 'Djarum Super'],
            'Bumbu' => ['Masako Sapi', 'Royco Ayam', 'Kecap Bango', 'Saus ABC'],
        ];

        $catModels = [];
        foreach ($categories as $catName => $items) {
            $catModels[$catName] = Category::firstOrCreate(['name' => $catName]);
        }

        // 4. Products (~120 products)
        $productModels = [];
        foreach ($categories as $catName => $names) {
            foreach ($names as $baseName) {
                // Variations/Sizes to get more data
                $variations = ['Kecil', 'Sedang', 'Besar', 'Sachet', 'Dus'];
                foreach (array_slice($variations, 0, rand(1, 3)) as $var) {
                    $cost = rand(1000, 50000);
                    $price = ceil(($cost * 1.15) / 100) * 100; // 15% margin rounded up
                    
                    $productModels[] = Product::create([
                        'store_id' => $store->id,
                        'category_id' => $catModels[$catName]->id,
                        'name' => "$baseName $var",
                        'barcode' => strtoupper(substr($catName, 0, 3)) . rand(100000, 999999),
                        'cost_price' => $cost,
                        'price' => $price,
                        'stock' => rand(20, 200)
                    ]);
                }
            }
        }

        // 5. Customers
        $customerNames = ['Budiman', 'Siti', 'Agus', 'Wati', 'Joko', 'Ani', 'Budi', 'Rina', 'Eko', 'Sari'];
        $customers = [];
        foreach ($customerNames as $name) {
            $customers[] = Customer::create([
                'store_id' => $store->id,
                'name' => $name,
                'phone' => '08' . rand(100000000, 999999999),
                'points_balance' => rand(0, 500)
            ]);
        }

        // 6. Transactions (Last 90 days, ~300 transactions)
        $this->command->info('Generating transactions and journals...');
        
        for ($i = 0; $i < 300; $i++) {
            $date = Carbon::now()->subDays(rand(0, 90))->subHours(rand(0, 10));
            $customer = rand(0, 3) > 0 ? $customers[array_rand($customers)] : null;
            $invoice = 'INV-' . strtoupper(Str::random(8));
            
            // Random Items (1-5 per transaction)
            $itemsKeys = array_rand($productModels, rand(1, 4));
            if (!is_array($itemsKeys)) $itemsKeys = [$itemsKeys];
            
            $subtotal = 0;
            $totalCost = 0;
            $tItemsData = [];

            foreach ($itemsKeys as $idx) {
                $p = $productModels[$idx];
                $qty = rand(1, 3);
                $subtotal += $p->price * $qty;
                $totalCost += $p->cost_price * $qty;
                
                $tItemsData[] = [
                    'product_id' => $p->id,
                    'product_name' => $p->name,
                    'quantity' => $qty,
                    'price' => $p->price,
                    'cost_price' => $p->cost_price,
                    'total' => $p->price * $qty
                ];
            }

            $tax = round($subtotal * 0.11);
            $service = round($subtotal * 0.05);
            $grand = $subtotal + $tax + $service;

            $transaction = Transaction::create([
                'id' => Str::uuid(),
                'store_id' => $store->id,
                'user_id' => 1, // Assume first user
                'customer_id' => $customer?->id,
                'invoice_number' => $invoice,
                'subtotal' => $subtotal,
                'tax' => $tax,
                'service_charge' => $service,
                'discount' => 0,
                'grand_total' => $grand,
                'payment_method' => rand(0, 2) == 0 ? 'split' : (rand(0, 1) == 0 ? 'cash' : 'qris'),
                'status' => 'completed',
                'created_at' => $date,
                'transaction_date' => $date->toDateString()
            ]);

            foreach ($tItemsData as $itemData) {
                $itemData['transaction_id'] = $transaction->id;
                TransactionItem::create($itemData);
            }

            // Payments
            $paymentDetails = [];
            if ($transaction->payment_method === 'split') {
                $cashPart = round($grand * 0.4);
                $qrisPart = $grand - $cashPart;
                
                $paymentDetails[] = ['method' => 'cash', 'amount' => $cashPart];
                $paymentDetails[] = ['method' => 'qris', 'amount' => $qrisPart];
            } else {
                $paymentDetails[] = ['method' => $transaction->payment_method, 'amount' => $grand];
            }

            foreach ($paymentDetails as $pd) {
                TransactionPayment::create([
                    'transaction_id' => $transaction->id,
                    'method' => $pd['method'],
                    'amount' => $pd['amount']
                ]);
            }

            // Journal
            try {
                $journalService->recordSaleJournal(
                    $store->id,
                    $invoice,
                    $subtotal,
                    $totalCost,
                    $tax,
                    $service,
                    $paymentDetails
                );
            } catch (\Exception $e) {
                // Silence journal errors in seeder if unbalanced (unlikely)
            }
        }

        $this->command->info('Seeding completed successfully!');
    }
}
