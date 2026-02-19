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
        Schema::create('stock_opnames', function (Blueprint $table) {
            $table->id();
            $table->foreignId('store_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->nullable()->constrained();
            
            $table->string('reference_number')->unique();
            $table->date('opname_date');
            $table->string('status')->default('draft'); // draft, completed, cancelled
            $table->text('notes')->nullable();
            
            $table->timestamps();
        });

        Schema::create('stock_opname_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('stock_opname_id')->constrained()->cascadeOnDelete();
            $table->foreignId('product_id')->constrained();
            
            $table->integer('system_stock');
            $table->integer('physical_stock');
            $table->integer('difference'); // physical - system
            
            $table->text('notes')->nullable();
            $table->timestamps();

            // Prevent duplicate entries for same product in one opname
            $table->unique(['stock_opname_id', 'product_id']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('stock_opname_items');
        Schema::dropIfExists('stock_opnames');
    }
};
