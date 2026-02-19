<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // 1. Create Stores Table first
         if (!Schema::hasTable('stores')) {
            Schema::create('stores', function (Blueprint $table) {
                $table->id();
                $table->string('name');
                $table->string('address')->nullable();
                $table->timestamps();
            });
            
            // Seed default store
            DB::table('stores')->insert([
                'name' => 'Main Store',
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }

        // 2. Update Users
        Schema::table('users', function (Blueprint $table) {
            if (!Schema::hasColumn('users', 'store_id')) {
                $table->foreignId('store_id')->nullable()->constrained();
            }
            if (!Schema::hasColumn('users', 'role')) {
                $table->string('role')->default('cashier'); // owner, admin, cashier
            }
        });

        // 3. Create Categories if missing (was used in frontend but maybe not migration)
        if (!Schema::hasTable('categories')) {
             Schema::create('categories', function (Blueprint $table) {
                $table->id();
                $table->string('name');
                $table->timestamps();
            });
        }

        // 4. Create Products if missing
        if (!Schema::hasTable('products')) {
            Schema::create('products', function (Blueprint $table) {
                $table->id();
                $table->foreignId('store_id')->nullable()->constrained(); // Nullable for global products
                $table->foreignId('category_id')->nullable()->constrained();
                $table->string('name');
                $table->string('barcode')->unique()->nullable();
                $table->decimal('price', 15, 2);
                $table->decimal('cost_price', 15, 2)->default(0);
                $table->integer('stock')->default(0);
                $table->string('image')->nullable();
                $table->timestamps();
                
                $table->index('barcode');
                $table->index('name');
            });
        }

        // 5. Create Transactions table
        if (!Schema::hasTable('transactions')) {
            Schema::create('transactions', function (Blueprint $table) {
                $table->uuid('id')->primary(); // Using UUID for transaction ID safety
                $table->foreignId('store_id')->constrained();
                $table->foreignId('user_id')->constrained();
                
                // Invoice Number (Sequential per store)
                $table->string('invoice_number'); 
                
                $table->decimal('subtotal', 15, 2);
                $table->decimal('tax', 15, 2)->default(0);
                $table->decimal('discount', 15, 2)->default(0);
                $table->decimal('grand_total', 15, 2);
                
                $table->decimal('cash_received', 15, 2)->nullable();
                $table->decimal('change_amount', 15, 2)->nullable();
                
                $table->string('payment_method'); // cash, qris, etc
                $table->string('status')->default('completed'); // completed, voided, refunded
                
                $table->string('notes')->nullable();
                $table->timestamp('transaction_date');
                $table->timestamps();
                
                $table->unique(['store_id', 'invoice_number']); // Prevent duplicate invoice numbers in same store
                $table->index('transaction_date');
            });
        }

        // 6. Create Transaction Items
        if (!Schema::hasTable('transaction_items')) {
            Schema::create('transaction_items', function (Blueprint $table) {
                $table->id();
                $table->foreignUuid('transaction_id')->constrained('transactions')->cascadeOnDelete();
                $table->foreignId('product_id')->constrained();
                
                $table->string('product_name'); // Snapshot of name
                $table->decimal('price', 15, 2); // Snapshot of price
                $table->decimal('cost_price', 15, 2)->default(0); // Snapshot of cost
                $table->integer('quantity');
                $table->decimal('total', 15, 2);
                
                $table->timestamps();
            });
        }
    }

    public function down(): void
    {
        // We generally don't drop in production updates, but provided for completeness
    }
};
