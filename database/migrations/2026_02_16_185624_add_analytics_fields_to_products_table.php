<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('products', function (Blueprint $table) {
            $table->integer('lead_time_days')->default(7)->after('stock'); // Days to restock
            $table->integer('safety_stock')->default(10)->after('lead_time_days'); // Buffer stock
            $table->timestamp('last_sold_at')->nullable()->after('updated_at'); // Fast lookup for dead stock
        });
    }

    public function down(): void
    {
        Schema::table('products', function (Blueprint $table) {
            $table->dropColumn(['lead_time_days', 'safety_stock', 'last_sold_at']);
        });
    }
};
