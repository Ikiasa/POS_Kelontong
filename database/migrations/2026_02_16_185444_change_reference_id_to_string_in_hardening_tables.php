<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('stock_movements', function (Blueprint $table) {
            $table->string('reference_id')->change();
        });

        // journal_entries uses morphs() which creates String by default in newer Laravel,
        // but let's double check if we defined it manually.
        // In create_journal_entries: $table->nullableMorphs('reference');
        // This creates reference_type (string) and reference_id (unsignedBigInteger).
        // We need to change reference_id to string/uuid.
        
        Schema::table('journal_entries', function (Blueprint $table) {
            // Drop index first if exists generally, but here let's try direct change
            // Many DBs require dropping constraints/indexes for type change.
            // For SQLite/MySQL, explicit change is needed.
            // Since this is fresh dev, we might get away with it, but safer to be explicit.
            $table->string('reference_id')->change();
        });
    }

    public function down(): void
    {
        Schema::table('stock_movements', function (Blueprint $table) {
            $table->unsignedBigInteger('reference_id')->change();
        });
        
        Schema::table('journal_entries', function (Blueprint $table) {
            $table->unsignedBigInteger('reference_id')->change();
        });
    }
};
