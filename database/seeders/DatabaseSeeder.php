<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // User::factory(10)->create();

        // Owner
        User::updateOrCreate(['email' => 'owner@pos.com'], [
            'name' => 'Owner Admin',
            'password' => bcrypt('password'),
            'role' => 'owner'
        ]);

        // Custom User (Ikiasa)
        User::updateOrCreate(['email' => 'ikiasaku@gmail.com'], [
            'name' => 'Ikiasa Owner',
            'password' => bcrypt('H3799@6w'),
            'role' => 'owner'
        ]);

        // Manager
        User::updateOrCreate(['email' => 'manager@pos.com'], [
            'name' => 'Store Manager',
            'password' => bcrypt('password'),
            'role' => 'manager'
        ]);

        // Cashier
        User::updateOrCreate(['email' => 'cashier@pos.com'], [
            'name' => 'Cashier Staff',
            'password' => bcrypt('password'),
            'role' => 'cashier'
        ]);
    }
}
