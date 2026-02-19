<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('customers', function (Blueprint $table) {
            $table->id();
            // Optional: store_id if customers are store-specific. 
            // Often customers are global across chain, but let's add nullable store_id for "home store"
            $table->foreignId('store_id')->nullable()->constrained()->nullOnDelete();
            
            $table->string('name');
            $table->string('phone')->unique(); // Primary identifier for loyalty
            $table->string('email')->nullable();
            
            $table->integer('points_balance')->default(0);
            $table->string('tier')->default('silver'); // silver, gold, platinum
            
            $table->timestamp('last_visit_at')->nullable();
            $table->timestamps();
            
            $table->index('phone');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('customers');
    }
};
