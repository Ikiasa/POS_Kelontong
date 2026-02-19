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
        Schema::create('transaction_payments', function (Blueprint $table) {
            $table->id();
            $table->foreignUuid('transaction_id')->constrained('transactions')->cascadeOnDelete();
            $table->string('method'); // cash, qris, gopay, ovo, shopeepay, etc
            $table->decimal('amount', 15, 2);
            $table->string('reference_number')->nullable(); // transaction id from provider
            $table->json('metadata')->nullable(); // extra info
            $table->timestamps();

            $table->index('method');
            $table->index('reference_number');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('transaction_payments');
    }
};
