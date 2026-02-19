<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('inventory_valuations', function (Blueprint $table) {
            $table->id();
            $table->foreignId('store_id')->constrained()->cascadeOnDelete();
            
            $table->decimal('total_value', 15, 2); // Sum of (batch_qty * batch_cost)
            $table->integer('total_items');
            
            $table->date('valuation_date');
            $table->timestamps();
            
            $table->index(['store_id', 'valuation_date']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('inventory_valuations');
    }
};
