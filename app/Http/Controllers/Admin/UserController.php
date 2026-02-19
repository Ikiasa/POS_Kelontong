<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rule;

class UserController extends Controller
{
    public function index(Request $request)
    {
        try {
            $search = $request->input('search');

            $users = User::query()
                ->when($search, function ($query, $search) {
                    $query->where('name', 'like', "%{$search}%")
                          ->orWhere('email', 'like', "%{$search}%");
                })
                ->latest()
                ->paginate(10)
                ->withQueryString();

            return Inertia::render('Admin/Users/Index', [
                'users' => $users,
                'filters' => $request->only(['search'])
            ]);
        } catch (\Throwable $e) {
            \Illuminate\Support\Facades\Log::error("Cloud Admin User Page 500: " . $e->getMessage());
            
            // Fallback for missing columns or schema out of sync in cloud
            return Inertia::render('Admin/Users/Index', [
                'users' => [
                    'data' => [auth()->user()->only(['id', 'name', 'email', 'role'])],
                    'total' => 1,
                    'per_page' => 10,
                    'links' => []
                ],
                'filters' => ['search' => ''],
                'flash' => ['error' => 'Database Sync detected. Please run migrations on Cloud.']
            ]);
        }
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'role' => 'required|in:owner,manager,cashier',
            'password' => 'required|min:6',
        ]);

        User::create([
            'name' => $validated['name'],
            'email' => $validated['email'],
            'role' => $validated['role'],
            'password' => Hash::make($validated['password']),
            'store_id' => auth()->user()->store_id ?? 1,
        ]);

        return back()->with('success', 'User created successfully.');
    }

    public function update(Request $request, User $user)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'email' => ['required', 'email', Rule::unique('users')->ignore($user->id)],
            'role' => 'required|in:owner,manager,cashier',
            'password' => 'nullable|min:6',
        ]);

        $data = [
            'name' => $validated['name'],
            'email' => $validated['email'],
            'role' => $validated['role'],
        ];

        if (!empty($validated['password'])) {
            $data['password'] = Hash::make($validated['password']);
        }

        $user->update($data);

        return back()->with('success', 'User updated successfully.');
    }

    public function destroy(User $user)
    {
        if ($user->id === auth()->id()) {
            return back()->withErrors(['error' => 'You cannot delete yourself.']);
        }

        $user->delete(); // Soft delete

        return back()->with('success', 'User deactivated successfully. Historical data preserved.');
    }
}
