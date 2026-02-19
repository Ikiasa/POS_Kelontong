<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('loyalty_logs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('customer_id')->constrained()->cascadeOnDelete();
            
            // Link to transaction (UUID) if applicable
            $table->foreignUuid('transaction_id')->nullable()->constrained()->nullOnDelete();
            
            $table->integer('points'); // Positive for earned, negative for redeemed
            $table->string('type'); // 'purchase', 'redemption', 'manual_adjustment', 'expiry'
            $table->string('description')->nullable();
            
            $table->timestamps(); // Created_at is the log time
            
            $table->index('customer_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('loyalty_logs');
    }
};
