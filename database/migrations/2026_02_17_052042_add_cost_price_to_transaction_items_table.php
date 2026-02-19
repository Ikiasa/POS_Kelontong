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
        // Minimal migration: Just ensure cost_price column exists
        if (!Schema::hasColumn('transaction_items', 'cost_price')) {
             Schema::table('transaction_items', function (Blueprint $table) {
                $table->decimal('cost_price', 15, 2)->nullable()->after('price');
            });
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // No down needed for safety
    }
};
