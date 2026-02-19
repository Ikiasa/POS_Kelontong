<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('stock_movements', function (Blueprint $table) {
            // Rename for clarity/architectural standard
            $table->renameColumn('quantity_change', 'quantity');
            $table->renameColumn('balance_after', 'after_stock');
            
            // Add new columns
            $table->integer('before_stock')->default(0)->after('product_id');
            $table->string('type')->nullable()->after('before_stock'); // Enum handled via PHP
        });

        // Backfill before_stock logic for existing data (if any)
        // after_stock = before_stock + quantity
        // before_stock = after_stock - quantity
        DB::statement('UPDATE stock_movements SET before_stock = after_stock - quantity');
    }

    public function down(): void
    {
        Schema::table('stock_movements', function (Blueprint $table) {
            $table->renameColumn('quantity', 'quantity_change');
            $table->renameColumn('after_stock', 'balance_after');
            $table->dropColumn(['before_stock', 'type']);
        });
    }
};
