<?php

namespace App\Services;

use App\Models\CashDrawer;
use App\Models\Transaction;
use Illuminate\Support\Facades\DB;
use Exception;

class CashDrawerService
{
    protected $alertService;

    public function __construct(AlertService $alertService)
    {
        $this->alertService = $alertService;
    }

    /**
     * Open a cash drawer for the current user.
     */
    public function openDrawer(int $storeId, float $openingBalance, ?string $notes = null): CashDrawer
    {
        // specific user logic: One open drawer per user per store
        $existing = CashDrawer::where('store_id', $storeId)
            ->where('user_id', auth()->id())
            ->whereNull('closed_at')
            ->first();

        if ($existing) {
            throw new Exception("You already have an open drawer.");
        }

        return CashDrawer::create([
            'store_id' => $storeId,
            'user_id' => auth()->id(),
            'opening_balance' => $openingBalance,
            'opened_at' => now(),
            'notes' => $notes,
        ]);
    }

    /**
     * Calculate expected cash balance.
     */
    public function getExpectedBalance(CashDrawer $drawer): float
    {
        // Opening Balance
        $total = $drawer->opening_balance;

        // Add Cash Sales
        // We need to filter transactions by this user and time range
        // Ideally link transactions to drawer_id, but time range is fallback
        
        $cashSales = Transaction::where('store_id', $drawer->store_id)
            ->where('user_id', $drawer->user_id)
            ->where('payment_method', 'cash')
            ->where('created_at', '>=', $drawer->opened_at)
            ->where(function($q) use ($drawer) {
                if ($drawer->closed_at) {
                    $q->where('created_at', '<=', $drawer->closed_at);
                }
            })
            ->sum('grand_total'); // Or cash_received - change_amount if we track strict cash movement

        // Subtract Refunds (if cash) - logic to be added
        
        // Add Cash Ins / Subtract Cash Outs (Expenses) - logic to be added

        return $total + $cashSales;
    }

    /**
     * Close the drawer.
     */
    public function closeDrawer(int $drawerId, float $closingBalance, ?string $notes = null): CashDrawer
    {
        $drawer = CashDrawer::findOrFail($drawerId);
        
        if ($drawer->closed_at) {
            throw new Exception("Drawer is already closed.");
        }

        $expected = $this->getExpectedBalance($drawer);
        $variance = $closingBalance - $expected;

        $drawer->update([
            'closing_balance' => $closingBalance,
            'expected_balance' => $expected,
            'variance' => $variance,
            'closed_at' => now(),
            'notes' => $notes ? $drawer->notes . "\n" . $notes : $drawer->notes,
        ]);

        // Variance Alert Trigger
        if (abs($variance) >= 50000) { // Rp 50k variance threshold
            $this->alertService->trigger(
                $drawer->store_id,
                'cash_variance',
                "CRITICAL: High cash variance detected for {$drawer->user->name} (Rp " . number_format($variance, 0) . ").",
                'critical',
                ['drawer_id' => $drawer->id, 'variance' => $variance]
            );
        }

        return $drawer;
    }

    /**
     * Get current open drawer.
     */
    public function getCurrentDrawer(int $storeId): ?CashDrawer
    {
        return CashDrawer::where('store_id', $storeId)
            ->where('user_id', auth()->id())
            ->whereNull('closed_at')
            ->latest()
            ->first();
    }
}
