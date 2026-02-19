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
        Schema::create('ai_insights', function (Blueprint $table) {
            $table->id();
            $table->foreignId('store_id')->constrained()->cascadeOnDelete();
            $table->string('type'); // price_increase, discount, bundle, trend_decline
            $table->string('title');
            $table->text('description');
            $table->text('explanation');
            $table->json('suggestion_data'); // Data required to apply the insight
            $table->decimal('estimated_impact', 15, 2)->nullable();
            $table->string('status')->default('pending'); // pending, approved, applied, dismissed
            $table->timestamp('approved_at')->nullable();
            $table->timestamp('applied_at')->nullable();
            $table->timestamps();

            $table->index(['store_id', 'status', 'type']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('a_i_insights');
    }
};
