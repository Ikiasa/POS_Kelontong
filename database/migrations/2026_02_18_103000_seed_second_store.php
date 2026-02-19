<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        // Check if we have less than 2 stores
        if (DB::table('stores')->count() < 2) {
            DB::table('stores')->insert([
                'name' => 'Gudang Pusat (Warehouse)',
                'address' => 'Jl. Pergudangan No. 1',
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }

    public function down(): void
    {
        // nothing
    }
};
