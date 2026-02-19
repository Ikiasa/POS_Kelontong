<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Add batch_id to stock_movements if it doesn't exist
        if (!Schema::hasColumn('stock_movements', 'batch_id')) {
            Schema::table('stock_movements', function (Blueprint $table) {
                $table->foreignId('batch_id')->nullable()->after('product_id')->constrained('product_batches')->nullOnDelete();
            });
        }

        // Add batch_id to transaction_items if it doesn't exist
        if (!Schema::hasColumn('transaction_items', 'batch_id')) {
            Schema::table('transaction_items', function (Blueprint $table) {
                $table->foreignId('batch_id')->nullable()->after('product_id')->constrained('product_batches')->nullOnDelete();
            });
        }
    }

    public function down(): void
    {
        if (Schema::hasColumn('transaction_items', 'batch_id')) {
            Schema::table('transaction_items', function (Blueprint $table) {
                $table->dropForeign(['batch_id']);
                $table->dropColumn('batch_id');
            });
        }

        if (Schema::hasColumn('stock_movements', 'batch_id')) {
            Schema::table('stock_movements', function (Blueprint $table) {
                $table->dropForeign(['batch_id']);
                $table->dropColumn('batch_id');
            });
        }
    }
};
