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
        Schema::create('store_wallets', function (Blueprint $table) {
            $table->id();
            $table->foreignId('store_id')->constrained()->cascadeOnDelete();
            $table->string('provider'); // gopay, ovo, shopeepay, etc
            $table->decimal('balance', 15, 2)->default(0);
            $table->timestamp('last_reconciled_at')->nullable();
            $table->timestamps();

            $table->unique(['store_id', 'provider']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('store_wallets');
    }
};
