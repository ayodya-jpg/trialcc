<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        User::firstOrCreate(
            ['email' => 'admin@flixplay.com'],
            [
                'name' => 'Admin FlixPlay',
                'username' => 'admin',
                'password' => Hash::make('admin123'),
                'is_admin' => true,
            ]
        );

        User::firstOrCreate(
            ['email' => 'user@flixplay.com'],
            [
                'name' => 'User Test',
                'username' => 'user',
                'password' => Hash::make('user123'),
                'is_admin' => false,
            ]
        );

        User::factory(10)->create();
    }
}
