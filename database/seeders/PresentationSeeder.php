<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Category;
use App\Models\Supplier;
use App\Models\Product;
use App\Models\Transaction;
use App\Models\TransactionItem;
use App\Models\BusinessHealthScore;
use App\Models\AIInsight;
use App\Models\Store;
use App\Models\User;
use App\Models\Customer;
use App\Models\Shift;
use App\Models\Voucher;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;
use Carbon\Carbon;

class PresentationSeeder extends Seeder
{
    public function run(): void
    {
        // 0. Clear old dummy data
        Schema::disableForeignKeyConstraints();
        DB::table('transaction_items')->truncate();
        DB::table('transaction_payments')->truncate();
        DB::table('transactions')->truncate();
        DB::table('product_batches')->truncate();
        DB::table('price_tiers')->truncate();
        DB::table('pending_transactions')->truncate();
        DB::table('vouchers')->truncate();
        DB::table('shifts')->truncate();
        Schema::enableForeignKeyConstraints();

        // 1. Get Main Store and Owner
        $store = Store::first() ?? Store::create(['name' => 'Kelontong Barokah HQ', 'address' => 'Jl. Executive No. 1']);
        
        $user = User::updateOrCreate(
            ['email' => 'ikiasaku@gmail.com'],
            [
                'name' => 'Ikiasaku Master',
                'password' => bcrypt('password'),
                'role' => 'owner',
                'store_id' => $store->id
            ]
        );

        $cashier = User::updateOrCreate(
            ['email' => 'cashier@pos.com'],
            [
                'name' => 'Budi Kasir',
                'password' => bcrypt('password'),
                'role' => 'cashier',
                'store_id' => $store->id
            ]
        );

        // 2. Categories
        $categories = ['Sembako', 'Minuman', 'Makanan Ringan', 'Produk Kebersihan', 'Obat-obatan', 'Alat Tulis'];
        $categoryIds = [];
        foreach ($categories as $cat) {
            $categoryIds[] = Category::updateOrCreate(['name' => $cat])->id;
        }

        // 3. Suppliers
        $suppliers = [
            ['name' => 'PT Indomarco Adi Prima', 'contact' => 'Budi'],
            ['name' => 'PT Wings Surya', 'contact' => 'Santi'],
            ['name' => 'PT Unilever Indonesia', 'contact' => 'Agus'],
            ['name' => 'Sumber Alfaria', 'contact' => 'Dewi'],
        ];
        
        $supplierIds = [];
        foreach ($suppliers as $sup) {
            $supplierIds[] = Supplier::updateOrCreate(
                ['name' => $sup['name']],
                ['contact_person' => $sup['contact'], 'phone' => '0812' . rand(1000000, 9999999)]
            )->id;
        }

        // 4. Products with Multi-Tier Pricing
        $productsData = [
            ['name' => 'Beras Pandan Wangi 5kg', 'cat' => 'Sembako', 'price' => 75000, 'cost' => 65000],
            ['name' => 'Minyak Goreng Filma 2L', 'cat' => 'Sembako', 'price' => 38000, 'cost' => 32000],
            ['name' => 'Gula Pasir Gulaku 1kg', 'cat' => 'Sembako', 'price' => 17500, 'cost' => 15500],
            ['name' => 'Telur Ayam 1kg (Isi 16)', 'cat' => 'Sembako', 'price' => 28000, 'cost' => 24000],
            ['name' => 'Indomie Goreng Original', 'cat' => 'Sembako', 'price' => 3100, 'cost' => 2600],
            ['name' => 'Coca Cola 1.5L', 'cat' => 'Minuman', 'price' => 15000, 'cost' => 12500],
            ['name' => 'Aqua Galon Refill', 'cat' => 'Minuman', 'price' => 6000, 'cost' => 4500],
            ['name' => 'Teh Botol Sosro 450ml', 'cat' => 'Minuman', 'price' => 6500, 'cost' => 5000],
            ['name' => 'Chitato Sapi Panggang', 'cat' => 'Makanan Ringan', 'price' => 11000, 'cost' => 9000],
            ['name' => 'Pocky Chocolate', 'cat' => 'Makanan Ringan', 'price' => 8500, 'cost' => 7000],
            ['name' => 'Rinso Anti Noda 700g', 'cat' => 'Produk Kebersihan', 'price' => 22000, 'cost' => 19000],
            ['name' => 'Pepsodent White 190g', 'cat' => 'Produk Kebersihan', 'price' => 14500, 'cost' => 12000],
            ['name' => 'Sunlight Limau 755ml', 'cat' => 'Produk Kebersihan', 'price' => 18000, 'cost' => 15500],
            ['name' => 'Panadol Extra 10s', 'cat' => 'Obat-obatan', 'price' => 13500, 'cost' => 11000],
            ['name' => 'Promag Tablet 12s', 'cat' => 'Obat-obatan', 'price' => 9500, 'cost' => 7500],
        ];

        $products = [];
        foreach ($productsData as $p) {
            $catId = Category::where('name', $p['cat'])->first()->id;
            $product = Product::updateOrCreate(
                ['name' => $p['name']],
                [
                    'store_id' => $store->id,
                    'category_id' => $catId,
                    'supplier_id' => $supplierIds[array_rand($supplierIds)],
                    'barcode' => (string)rand(100000000000, 999999999999),
                    'price' => $p['price'],
                    'cost_price' => $p['cost'],
                    'stock' => 0, // Will be updated by batches
                    'is_weighted' => (strpos($p['name'], 'Telur') !== false),
                    'attributes' => ['brand' => 'Maison Elite', 'origin' => 'Local'],
                ]
            );
            $products[] = $product;

            // 4a. Create Price Tiers
            \App\Models\PriceTier::create(['product_id' => $product->id, 'store_id' => $store->id, 'tier_name' => 'retail', 'price' => $p['price']]);
            \App\Models\PriceTier::create(['product_id' => $product->id, 'store_id' => $store->id, 'tier_name' => 'wholesale', 'price' => $p['price'] * 0.9, 'min_quantity' => 12]);
            \App\Models\PriceTier::create(['product_id' => $product->id, 'store_id' => $store->id, 'tier_name' => 'member', 'price' => $p['price'] * 0.95]);

            // 4b. Create Product Batches
            $totalStock = 0;
            for ($b = 0; $b < 2; $b++) {
                $qty = rand(10, 100);
                $totalStock += $qty;
                \App\Models\ProductBatch::create([
                    'product_id' => $product->id,
                    'store_id' => $store->id,
                    'batch_number' => 'BATCH-' . strtoupper(Str::random(6)),
                    'current_quantity' => $qty,
                    'initial_quantity' => $qty,
                    'cost_price' => $p['cost'],
                    'expiry_date' => Carbon::now()->addMonths(rand(6, 24)),
                    'received_at' => Carbon::now()->subMonths(rand(0, 3)),
                ]);
            }
            $product->update(['stock' => $totalStock]);
        }

        // 4.1 Customers
        $customersData = [
            ['name' => 'Andi Pratama', 'phone' => '081234567890', 'points' => 1250],
            ['name' => 'Siti Aminah', 'phone' => '082198765432', 'points' => 450],
            ['name' => 'Budi Santoso', 'phone' => '085611223344', 'points' => 2100],
        ];

        $customers = [];
        foreach ($customersData as $c) {
            $customers[] = Customer::create([
                'name' => $c['name'],
                'phone' => $c['phone'],
                'points_balance' => $c['points'],
                'store_id' => $store->id
            ]);
        }

        // 4.2 Shifts
        for ($s = 1; $s <= 5; $s++) {
            $shiftDate = Carbon::now()->subDays($s);
            Shift::create([
                'store_id' => $store->id, 'user_id' => $cashier->id,
                'opening_balance' => 500000, 'closing_balance' => 1250000,
                'cash_recorded' => 1250000, 'status' => 'closed',
                'opened_at' => $shiftDate->copy()->hour(8), 'closed_at' => $shiftDate->copy()->hour(17),
            ]);
        }
        Shift::create(['store_id' => $store->id, 'user_id' => $user->id, 'opening_balance' => 500000, 'status' => 'open', 'opened_at' => Carbon::now()->startOfDay()->hour(8)]);

        // 5. Transactions with Split Payments
        for ($i = 0; $i < 50; $i++) {
            $date = Carbon::now()->subDays(rand(0, 30))->subHours(rand(0, 24));
            $numItems = rand(1, 4);
            $randomProducts = collect($products)->random($numItems);
            
            $subtotal = 0;
            foreach ($randomProducts as $prod) { $subtotal += $prod->price * rand(1, 3); }
            $tax = $subtotal * 0.11;
            $grand_total = $subtotal + $tax;
            
            $transaction = Transaction::create([
                'id' => (string)Str::uuid(), 'store_id' => $store->id, 'user_id' => $user->id,
                'invoice_number' => 'INV-' . $date->format('ymd') . '-' . str_pad($i + 1, 4, '0', STR_PAD_LEFT),
                'subtotal' => $subtotal, 'tax' => $tax, 'grand_total' => $grand_total,
                'payment_method' => ($i % 5 === 0) ? 'split' : (rand(0, 1) ? 'cash' : 'qris'),
                'status' => 'completed', 'transaction_date' => $date, 'created_at' => $date,
            ]);
            
            if ($transaction->payment_method === 'split') {
                \App\Models\TransactionPayment::create(['transaction_id' => $transaction->id, 'method' => 'cash', 'amount' => $grand_total / 2]);
                \App\Models\TransactionPayment::create(['transaction_id' => $transaction->id, 'method' => 'qris', 'amount' => $grand_total / 2]);
            } else {
                \App\Models\TransactionPayment::create(['transaction_id' => $transaction->id, 'method' => $transaction->payment_method, 'amount' => $grand_total]);
            }

            foreach ($randomProducts as $prod) {
                TransactionItem::create([
                    'transaction_id' => $transaction->id, 'product_id' => $prod->id,
                    'product_name' => $prod->name, 'price' => $prod->price, 'cost_price' => $prod->cost_price,
                    'quantity' => rand(1, 3), 'total' => $prod->price * rand(1, 3),
                ]);
            }
        }

        // 8. Vouchers
        Voucher::create(['code' => 'LOYALTY50K', 'name' => 'Potongan Loyalitas 50rb', 'type' => 'discount', 'value' => 50000, 'is_active' => true, 'store_id' => $store->id, 'expiry_date' => now()->addMonths(3)]);
        Voucher::create(['code' => 'RETURN10K', 'name' => 'Voucher Retur Barang', 'type' => 'return', 'value' => 10000, 'is_active' => true, 'store_id' => $store->id, 'expiry_date' => now()->addMonth()]);

        // 9. Pending Transactions (Park Sale)
        for ($p = 0; $p < 3; $p++) {
            \App\Models\PendingTransaction::create([
                'id' => Str::uuid(), 'store_id' => $store->id, 'user_id' => $user->id,
                'customer_id' => $customers[array_rand($customers)]->id,
                'cart_data' => [['id' => $products[0]->id, 'name' => $products[0]->name, 'price' => $products[0]->price, 'qty' => 2]],
                'total' => 150000,
                'status' => 'pending'
            ]);
        }

        \App\Models\BusinessHealthScore::create(['store_id' => $store->id, 'score' => 82, 'breakdown' => ['profit_margin' => 15.2, 'inventory_turnover' => 4.8, 'customer_retention' => 65.0], 'explanation' => 'Performa toko stabil.', 'calculated_at' => now()]);

        // 7. AI Insights
        $p1 = $products[0]; // Beras
        AIInsight::updateOrCreate(
            ['store_id' => $store->id, 'type' => 'price_increase'],
            [
                'title' => 'Potensi Kenaikan Harga: ' . $p1->name,
                'description' => 'Produk ini memiliki perputaran tinggi (fast moving) namun margin saat ini di bawah rata-rata kategori.',
                'explanation' => 'Data menunjukkan kenaikan permintaan sebesar 15% di minggu terakhir. Anda bisa menaikkan harga sebesar Rp 1.000 tanpa mengurangi volume penjualan signifikan.',
                'suggestion_data' => ['product_id' => $p1->id, 'suggested_price' => $p1->price + 1000],
                'estimated_impact' => 250000,
                'status' => 'pending'
            ]
        );

        // 8. Vouchers
        Voucher::updateOrCreate(
            ['code' => 'LOYALTY50K'],
            [
                'name' => 'Potongan Loyalitas 50rb',
                'type' => 'discount',
                'value' => 50000,
                'is_active' => true,
                'store_id' => $store->id,
                'expiry_date' => now()->addMonths(3)
            ]
        );

        Voucher::updateOrCreate(
            ['code' => 'RETURN10K'],
            [
                'name' => 'Voucher Retur Barang',
                'type' => 'return',
                'value' => 10000,
                'is_active' => true,
                'store_id' => $store->id,
                'expiry_date' => now()->addMonth()
            ]
        );

        $this->command->info('Seeding completed successfully!');
    }
}
