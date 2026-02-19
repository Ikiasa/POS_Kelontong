<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('transactions', function (Blueprint $table) {
            $table->foreignId('customer_id')->nullable()->constrained()->nullOnDelete();
            $table->integer('points_earned')->default(0);
            $table->integer('points_redeemed')->default(0);
        });
    }

    public function down(): void
    {
        Schema::table('transactions', function (Blueprint $table) {
            $table->dropForeign(['customer_id']);
            $table->dropColumn(['customer_id', 'points_earned', 'points_redeemed']);
        });
    }
};
