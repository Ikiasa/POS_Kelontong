<?php

namespace App\Services;

use App\Models\User;

class PrivilegeService
{
    /**
     * Check if a user has privilege to perform a sensitive POS action.
     */
    public function canPerformAction(User $user, string $action): bool
    {
        // Owner/Admin has full access
        if ($user->role === 'owner' || $user->role === 'admin') {
            return true;
        }

        // Granular permissions for Cashiers (Manager role might allow more)
        $privileges = [
            'cashier' => [
                'process_sale',
                'search_product',
                'print_receipt'
            ],
            'manager' => [
                'process_sale',
                'search_product',
                'print_receipt',
                'manual_discount',
                'price_override',
                'void_transaction',
                'open_cash_drawer'
            ]
        ];

        return in_array($action, $privileges[$user->role] ?? []);
    }
}
