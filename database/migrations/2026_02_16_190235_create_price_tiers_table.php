<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('price_tiers', function (Blueprint $table) {
            $table->id();
            $table->foreignId('product_id')->constrained()->cascadeOnDelete();
            
            // Nullable store_id means this tier applies globally unless overridden
            $table->foreignId('store_id')->nullable()->constrained()->cascadeOnDelete();
            
            $table->string('tier_name'); // 'retail', 'wholesale', 'vip', 'member'
            $table->decimal('price', 15, 2);
            $table->integer('min_quantity')->default(1); // For volume pricing (wholesale)
            
            $table->timestamps();
            
            // Unique constraint: One price per tier per product per store logic
            // But since store_id is nullable, unique handling is complex in SQL standard
            // We can just index it for lookups
            $table->index(['product_id', 'store_id', 'tier_name']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('price_tiers');
    }
};
