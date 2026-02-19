<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('product_batches', function (Blueprint $table) {
            $table->id();
            $table->foreignId('store_id')->constrained()->cascadeOnDelete();
            $table->foreignId('product_id')->constrained()->cascadeOnDelete();
            
            $table->string('batch_number')->index(); // e.g., BATCH-202310-001
            $table->date('expiry_date')->nullable();
            
            $table->decimal('cost_price', 15, 2); // Actual cost for this batch
            $table->integer('initial_quantity');
            $table->integer('current_quantity');
            
            $table->timestamp('received_at');
            $table->timestamps();
            
            // Index for FIFO: store, product, expiry/received ASC
            $table->index(['store_id', 'product_id', 'expiry_date', 'received_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('product_batches');
    }
};
