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
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;
use Carbon\Carbon;

class PresentationSeeder extends Seeder
{
    public function run(): void
    {
        // 0. Clear old dummy data to avoid unique conflicts
        Schema::disableForeignKeyConstraints();
        TransactionItem::truncate();
        Transaction::truncate();
        Schema::enableForeignKeyConstraints();

        // 1. Get Main Store and Owner
        $store = Store::first() ?? Store::create(['name' => 'Kelontong Barokah']);
        $user = User::where('email', 'ikiasaku@gmail.com')->first() ?? User::first();
        
        if (!$user) {
            $user = User::create([
                'name' => 'Demo User',
                'email' => 'demo@pos.com',
                'password' => bcrypt('password'),
                'role' => 'owner',
                'store_id' => $store->id
            ]);
        }

        // 2. Categories
        $categories = [
            'Sembako', 'Minuman', 'Makanan Ringan', 'Produk Kebersihan', 'Obat-obatan', 'Alat Tulis'
        ];
        
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

        // 4. Products
        $productsData = [
            ['name' => 'Beras Pandan Wangi 5kg', 'cat' => 'Sembako', 'price' => 75000, 'cost' => 65000, 'stock' => 20],
            ['name' => 'Minyak Goreng Filma 2L', 'cat' => 'Sembako', 'price' => 38000, 'cost' => 32000, 'stock' => 15],
            ['name' => 'Gula Pasir Gulaku 1kg', 'cat' => 'Sembako', 'price' => 17500, 'cost' => 15500, 'stock' => 50],
            ['name' => 'Telur Ayam 1kg (Isi 16)', 'cat' => 'Sembako', 'price' => 28000, 'cost' => 24000, 'stock' => 30],
            ['name' => 'Indomie Goreng Original', 'cat' => 'Sembako', 'price' => 3100, 'cost' => 2600, 'stock' => 200],
            ['name' => 'Coca Cola 1.5L', 'cat' => 'Minuman', 'price' => 15000, 'cost' => 12500, 'stock' => 24],
            ['name' => 'Aqua Galon Refill', 'cat' => 'Minuman', 'price' => 6000, 'cost' => 4500, 'stock' => 10],
            ['name' => 'Teh Botol Sosro 450ml', 'cat' => 'Minuman', 'price' => 6500, 'cost' => 5000, 'stock' => 48],
            ['name' => 'Chitato Sapi Panggang', 'cat' => 'Makanan Ringan', 'price' => 11000, 'cost' => 9000, 'stock' => 36],
            ['name' => 'Pocky Chocolate', 'cat' => 'Makanan Ringan', 'price' => 8500, 'cost' => 7000, 'stock' => 24],
            ['name' => 'Rinso Anti Noda 700g', 'cat' => 'Produk Kebersihan', 'price' => 22000, 'cost' => 19000, 'stock' => 12],
            ['name' => 'Pepsodent White 190g', 'cat' => 'Produk Kebersihan', 'price' => 14500, 'cost' => 12000, 'stock' => 24],
            ['name' => 'Sunlight Limau 755ml', 'cat' => 'Produk Kebersihan', 'price' => 18000, 'cost' => 15500, 'stock' => 20],
            ['name' => 'Panadol Extra 10s', 'cat' => 'Obat-obatan', 'price' => 13500, 'cost' => 11000, 'stock' => 50],
            ['name' => 'Promag Tablet 12s', 'cat' => 'Obat-obatan', 'price' => 9500, 'cost' => 7500, 'stock' => 40],
        ];

        $products = [];
        foreach ($productsData as $p) {
            $catId = Category::where('name', $p['cat'])->first()->id;
            $products[] = Product::updateOrCreate(
                ['name' => $p['name']],
                [
                    'store_id' => $store->id,
                    'category_id' => $catId,
                    'supplier_id' => $supplierIds[array_rand($supplierIds)],
                    'barcode' => (string)rand(100000000000, 999999999999),
                    'price' => $p['price'],
                    'cost_price' => $p['cost'],
                    'stock' => rand(5, 50),
                ]
            );
        }

        // 5. Transactions (Last 30 Days)
        $this->command->info('Generating transactions...');
        $transactionCount = 120;
        
        for ($i = 0; $i < $transactionCount; $i++) {
            $date = Carbon::now()->subDays(rand(0, 30))->subHours(rand(0, 24))->subMinutes(rand(0, 60));
            
            // Pick 1-4 random products
            $numItems = rand(1, 4);
            $randomProducts = collect($products)->random($numItems);
            
            $subtotal = 0;
            $items = [];
            
            foreach ($randomProducts as $prod) {
                $qty = rand(1, 3);
                $total = $prod->price * $qty;
                $subtotal += $total;
                
                $items[] = [
                    'product_id' => $prod->id,
                    'product_name' => $prod->name,
                    'price' => $prod->price,
                    'cost_price' => $prod->cost_price,
                    'quantity' => $qty,
                    'total' => $total,
                    'created_at' => $date,
                    'updated_at' => $date,
                ];
            }
            
            $tax = $subtotal * 0.11; // 11% PPN
            $grand_total = $subtotal + $tax;
            
            $transaction = Transaction::create([
                'id' => (string)Str::uuid(),
                'store_id' => $store->id,
                'user_id' => $user->id,
                'invoice_number' => 'INV-' . $date->format('ymd') . '-' . str_pad($i + 1, 4, '0', STR_PAD_LEFT),
                'subtotal' => $subtotal,
                'tax' => $tax,
                'discount' => 0,
                'grand_total' => $grand_total,
                'payment_method' => rand(0, 1) ? 'cash' : 'qris',
                'status' => 'completed',
                'transaction_date' => $date,
                'created_at' => $date,
                'updated_at' => $date,
            ]);
            
            foreach ($items as $item) {
                $item['transaction_id'] = $transaction->id;
                TransactionItem::create($item);
            }
        }

        // 6. Business Health Score
        BusinessHealthScore::updateOrCreate(
            ['store_id' => $store->id, 'calculated_at' => now()->toDateString()],
            [
                'score' => 82,
                'breakdown' => [
                    'profit_margin' => 15.2,
                    'inventory_turnover' => 4.8,
                    'customer_retention' => 65.0
                ],
                'explanation' => 'Performa toko stabil dengan margin profit yang baik.',
                'calculated_at' => now()
            ]
        );

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

        $this->command->info('Seeding completed successfully!');
    }
}
