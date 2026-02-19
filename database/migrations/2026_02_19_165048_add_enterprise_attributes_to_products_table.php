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
        Schema::table('products', function (Blueprint $table) {
            $table->json('attributes')->nullable()->comment('8 logical dimensions: Brand, Color, Size, etc');
            $table->decimal('min_margin', 5, 2)->default(10.00)->comment('Minimum profit margin percentage');
            $table->string('uom_type')->default('base')->comment('Unit of Measure configuration');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('products', function (Blueprint $table) {
            $table->dropColumn(['attributes', 'min_margin', 'uom_type']);
        });
    }
};
