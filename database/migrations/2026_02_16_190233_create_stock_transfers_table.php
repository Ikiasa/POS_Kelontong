<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('stock_transfers', function (Blueprint $table) {
            $table->id();
            $table->string('transfer_number')->unique();
            
            $table->foreignId('source_store_id')->constrained('stores');
            $table->foreignId('dest_store_id')->constrained('stores');
            
            $table->foreignId('created_by')->constrained('users');
            $table->foreignId('received_by')->nullable()->constrained('users');

            $table->string('status')->default('pending'); // pending, in_transit, received, cancelled
            
            $table->timestamp('shipped_at')->nullable();
            $table->timestamp('received_at')->nullable();
            
            $table->text('notes')->nullable();
            $table->timestamps();
            
            $table->index(['source_store_id', 'status']);
            $table->index(['dest_store_id', 'status']);
        });

        Schema::create('stock_transfer_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('stock_transfer_id')->constrained()->cascadeOnDelete();
            $table->foreignId('product_id')->constrained();
            
            $table->integer('request_quantity');
            $table->integer('shipped_quantity')->nullable();
            $table->integer('received_quantity')->nullable();
            
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('stock_transfer_items');
        Schema::dropIfExists('stock_transfers');
    }
};
