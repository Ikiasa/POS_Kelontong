<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('cash_drawers', function (Blueprint $table) {
            $table->id();
            $table->foreignId('store_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->constrained(); // Cashier
            
            $table->decimal('opening_balance', 15, 2);
            $table->decimal('closing_balance', 15, 2)->nullable(); // Actual cash counted
            $table->decimal('expected_balance', 15, 2)->nullable(); // Calculated from system
            $table->decimal('variance', 15, 2)->nullable(); // Difference
            
            $table->text('notes')->nullable(); // For explaining variance
            
            $table->timestamp('opened_at');
            $table->timestamp('closed_at')->nullable();
            
            $table->timestamps();
            
            // Ensure one open drawer per user/store at a time? 
            // Or just index for filtering
            $table->index(['store_id', 'user_id', 'closed_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('cash_drawers');
    }
};
