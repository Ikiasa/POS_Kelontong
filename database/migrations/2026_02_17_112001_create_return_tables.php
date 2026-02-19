<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('return_transactions', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignUuid('transaction_id')->constrained('transactions')->onDelete('cascade');
            $table->foreignId('store_id')->constrained('stores');
            $table->foreignId('user_id')->constrained('users');
            $table->decimal('total_refunded', 15, 2);
            $table->string('payment_method'); // cash, bank_transfer, store_credit
            $table->text('reason')->nullable();
            $table->timestamps();
        });

        Schema::create('return_items', function (Blueprint $table) {
            $table->id();
            $table->foreignUuid('return_transaction_id')->constrained('return_transactions')->onDelete('cascade');
            $table->foreignId('product_id')->constrained('products');
            $table->integer('quantity');
            $table->decimal('refund_price', 15, 2);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('return_items');
        Schema::dropIfExists('return_transactions');
    }
};
