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
        Schema::create('profit_risk_scores', function (Blueprint $table) {
            $table->id();
            $table->foreignId('store_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->nullable()->constrained()->nullOnDelete(); // The employee being rated
            $table->integer('risk_score'); // 0-100 (Higher is riskier)
            $table->json('indicators'); // Breakdown of leakage indicators
            $table->json('metadata')->nullable(); // Contextual data
            $table->date('calculated_at');
            $table->timestamps();

            $table->index(['store_id', 'calculated_at']);
            $table->index(['user_id', 'calculated_at']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('profit_risk_scores');
    }
};
