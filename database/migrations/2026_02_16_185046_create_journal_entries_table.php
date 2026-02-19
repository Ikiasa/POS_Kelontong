<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('journal_entries', function (Blueprint $table) {
            $table->id();
            $table->foreignId('store_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->nullable()->constrained();
            
            $table->string('reference_number')->unique(); // e.g. JE-2023-0001
            $table->date('transaction_date');
            $table->string('description');
            
            // Linked to source (Sale, Purchase)
            $table->nullableMorphs('reference'); 
            
            $table->boolean('is_posted')->default(false);
            $table->timestamp('posted_at')->nullable();
            
            $table->timestamps();
            $table->softDeletes();
        });

        Schema::create('journal_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('journal_entry_id')->constrained()->cascadeOnDelete();
            
            $table->string('account_code'); // Chart of Accounts Code
            $table->string('account_name');
            
            $table->decimal('debit', 15, 2)->default(0);
            $table->decimal('credit', 15, 2)->default(0);
            
            $table->timestamps();
            
            // Indexes
            $table->index('account_code');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('journal_items');
        Schema::dropIfExists('journal_entries');
    }
};
