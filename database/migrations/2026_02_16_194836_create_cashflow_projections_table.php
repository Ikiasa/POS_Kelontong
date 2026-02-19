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
        Schema::create('cashflow_projections', function (Blueprint $table) {
            $table->id();
            $table->foreignId('store_id')->constrained()->cascadeOnDelete();
            $table->date('projection_date'); // The day being projected
            $table->decimal('projected_incoming', 15, 2);
            $table->decimal('projected_outgoing', 15, 2);
            $table->decimal('net_balance', 15, 2);
            $table->json('source_data'); // Breakdown of what makes up the projection
            $table->timestamps();

            $table->index(['store_id', 'projection_date']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('cashflow_projections');
    }
};
