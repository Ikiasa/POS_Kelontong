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
        Schema::create('system_alerts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('store_id')->constrained()->cascadeOnDelete();
            $table->string('type'); // sales_target, cash_variance, low_stock, high_risk, cashflow
            $table->text('message');
            $table->enum('severity', ['info', 'warning', 'critical']);
            $table->json('metadata')->nullable();
            $table->timestamp('read_at')->nullable();
            $table->timestamps();

            $table->index(['store_id', 'type', 'created_at']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('system_alerts');
    }
};
