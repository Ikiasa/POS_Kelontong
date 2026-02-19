<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('budgets', function (Blueprint $table) {
            $table->id();
            $table->foreignId('store_id')->constrained()->cascadeOnDelete();
            
            // Category (e.g., 'utilities', 'salaries', 'inventory')
            // Using string for now or foreign key if categories table exists
            // We created categories table in previous migration (Phase 2), let's use foreign key if applicable
            // But categories table might be for products. Expense categories might be different.
            // Let's use `expense_category` string or check if `charts_of_accounts` exists. 
            // For now, let's assume simple string category or ID if we add an expense_categories table.
            // In Phase 2 we used chart of accounts codes in JournalItems.
            // Let's use `category_name` or `account_code`.
            $table->string('category_name'); 
            
            $table->decimal('amount_limit', 15, 2);
            $table->date('start_date');
            $table->date('end_date');
            
            $table->text('notes')->nullable();
            $table->timestamps();
            
            $table->index(['store_id', 'start_date', 'end_date']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('budgets');
    }
};
