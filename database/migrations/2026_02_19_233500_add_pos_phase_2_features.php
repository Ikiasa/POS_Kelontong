<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // 1. Shift Management
        Schema::create('shifts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained();
            $table->foreignId('store_id')->constrained();
            $table->timestamp('opened_at');
            $table->timestamp('closed_at')->nullable();
            $table->decimal('opening_balance', 15, 2);
            $table->decimal('closing_balance', 15, 2)->nullable(); // Expected
            $table->decimal('cash_recorded', 15, 2)->nullable(); // Actual counted
            $table->string('status')->default('open'); // open, closed
            $table->string('offline_validation_code')->nullable();
            $table->timestamps();
        });

        // 2. Pending Transactions (Recall/Park Sale)
        Schema::create('pending_transactions', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignId('store_id')->constrained();
            $table->foreignId('user_id')->constrained();
            $table->foreignId('customer_id')->nullable()->constrained();
            $table->json('cart_data'); // Stores items, qty, prices
            $table->decimal('total', 15, 2);
            $table->string('status')->default('pending'); // pending, recalled, cancelled
            $table->timestamps();
        });

        // 3. Update Transactions to link with shifts
        Schema::table('transactions', function (Blueprint $table) {
            $table->foreignId('shift_id')->nullable()->constrained();
        });

        // 4. Enhanced Promotions (Buy X Get Y support)
        Schema::table('promotions', function (Blueprint $table) {
            $table->string('rule_type')->default('percentage'); // percentage, fixed, buy_x_get_y, volume
            $table->integer('buy_qty')->default(0);
            $table->integer('get_qty')->default(0);
            $table->decimal('min_volume')->default(0);
        });
    }

    public function down(): void
    {
        Schema::table('promotions', function (Blueprint $table) {
            $table->dropColumn(['rule_type', 'buy_qty', 'get_qty', 'min_volume']);
        });
        Schema::table('transactions', function (Blueprint $table) {
            $table->dropForeign(['shift_id']);
            $table->dropColumn('shift_id');
        });
        Schema::dropIfExists('pending_transactions');
        Schema::dropIfExists('shifts');
    }
};
