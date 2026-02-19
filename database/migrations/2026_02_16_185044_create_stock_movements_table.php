<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('stock_movements', function (Blueprint $table) {
            $table->id();
            $table->foreignId('store_id')->constrained()->cascadeOnDelete();
            $table->foreignId('product_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->nullable()->constrained();
            
            // Reference: sale_id, purchase_id, transfer_id etc
            $table->string('reference_type'); // e.g. 'sale', 'purchase', 'adjustment', 'return'
            $table->unsignedBigInteger('reference_id');
            
            $table->integer('quantity_change'); // + for incoming, - for outgoing
            $table->integer('balance_after'); // Snapshot of balance after this move
            
            $table->string('notes')->nullable();
            $table->timestamps();
            
            // Indexes for fast lookup
            $table->index(['store_id', 'product_id']);
            $table->index(['reference_type', 'reference_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('stock_movements');
    }
};
