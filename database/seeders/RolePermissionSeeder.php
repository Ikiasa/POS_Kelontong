<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class RolePermissionSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // 1. Define Roles & Permissions (Ideally in a permissions table, but for simplicity using JSON column or config)
        // Here we simulate role assignment to users.
        
        // Ensure Main Store exists
        $storeId = DB::table('stores')->first()->id ?? DB::table('stores')->insertGetId([
            'name' => 'Main Store',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        // 2. Create Default Users for each Role
        
        // Owner (Super Admin)
        User::updateOrCreate(
            ['email' => 'owner@example.com'],
            [
                'name' => 'Owner User',
                'password' => Hash::make('password'),
                'store_id' => $storeId,
                'role' => 'owner', // Grants all permissions
                'email_verified_at' => now(),
            ]
        );

        // Store Admin
        User::updateOrCreate(
            ['email' => 'admin@example.com'],
            [
                'name' => 'Store Admin',
                'password' => Hash::make('password'),
                'store_id' => $storeId,
                'role' => 'admin',
                'email_verified_at' => now(),
            ]
        );

        // Cashier
        User::updateOrCreate(
            ['email' => 'cashier@example.com'],
            [
                'name' => 'Cashier User',
                'password' => Hash::make('password'),
                'store_id' => $storeId,
                'role' => 'cashier',
                'email_verified_at' => now(),
            ]
        );
        
        // Warehouse / Stock Manager
        User::updateOrCreate(
            ['email' => 'warehouse@example.com'],
            [
                'name' => 'Warehouse User',
                'password' => Hash::make('password'),
                'store_id' => $storeId,
                'role' => 'warehouse',
                'email_verified_at' => now(),
            ]
        );
    }
}
