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
        Schema::table('purchase_orders', function (Blueprint $table) {
            $table->string('payment_status')->default('pending')->after('status');
            $table->foreignId('supplier_payment_id')->nullable()->after('payment_status')->constrained('supplier_payments')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::table('purchase_orders', function (Blueprint $table) {
            $table->dropForeign(['supplier_payment_id']);
            $table->dropColumn(['payment_status', 'supplier_payment_id']);
        });
    }
};
