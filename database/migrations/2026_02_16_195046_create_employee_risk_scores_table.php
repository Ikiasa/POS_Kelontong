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
        Schema::create('employee_risk_scores', function (Blueprint $table) {
            $table->id();
            $table->foreignId('store_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->decimal('risk_score', 5, 2);
            $table->string('risk_level'); // low, medium, high, critical
            $table->json('indicators'); // {voids: 5, variance: 150000, etc}
            $table->json('metadata')->nullable();
            $table->timestamp('calculated_at');
            $table->timestamps();

            $table->index(['store_id', 'user_id', 'calculated_at']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('employee_risk_scores');
    }
};
