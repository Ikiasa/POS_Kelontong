<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('transactions', function (Blueprint $table) {
            $table->index(['store_id', 'created_at']);
        });

        Schema::table('transaction_items', function (Blueprint $table) {
            $table->index(['product_id', 'created_at']);
        });

        Schema::table('product_batches', function (Blueprint $table) {
            $table->index(['store_id', 'expiry_date']);
            $table->index(['product_id', 'expiry_date']);
        });

        Schema::table('stock_movements', function (Blueprint $table) {
            $table->index(['store_id', 'created_at']);
            $table->index(['product_id', 'created_at']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('transactions', function (Blueprint $table) {
            $table->dropIndex(['transactions_store_id_created_at_index']);
        });

        Schema::table('transaction_items', function (Blueprint $table) {
            $table->dropIndex(['transaction_items_product_id_created_at_index']);
        });

        Schema::table('product_batches', function (Blueprint $table) {
            $table->dropIndex(['product_batches_store_id_expiry_date_index']);
            $table->dropIndex(['product_batches_product_id_expiry_date_index']);
        });

        Schema::table('stock_movements', function (Blueprint $table) {
            $table->dropIndex(['stock_movements_store_id_created_at_index']);
            $table->dropIndex(['stock_movements_product_id_created_at_index']);
        });
    }
};
