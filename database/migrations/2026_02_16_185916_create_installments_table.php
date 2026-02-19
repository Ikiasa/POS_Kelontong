<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('installments', function (Blueprint $table) {
            $table->id();
            
            // Link to transaction (UUID)
            // Note: transaction_id is UUID in transactions table
            $table->foreignUuid('transaction_id')->constrained()->cascadeOnDelete();
            
            $table->integer('installment_number'); // 1, 2, 3...
            $table->date('due_date');
            
            $table->decimal('amount', 15, 2); // Amount due
            $table->decimal('paid_amount', 15, 2)->default(0); // Amount paid so far
            
            $table->string('status')->default('pending'); // pending, paid, partial, overdue
            $table->timestamp('paid_at')->nullable();
            
            $table->string('notes')->nullable();
            $table->timestamps();
            
            $table->index('due_date');
            $table->index('status');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('installments');
    }
};
