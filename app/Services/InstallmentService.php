<?php

namespace App\Services;

use App\Models\Installment;
use App\Models\Transaction;
use Illuminate\Support\Carbon;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;

class InstallmentService
{
    /**
     * Create installment schedule for a credit sale.
     */
    public function createSchedule(Transaction $transaction, int $months, float $interestRate = 0): void
    {
        $amount = $transaction->grand_total;
        $monthlyAmount = $amount / $months;
        
        // Simple interest logic if needed, but usually 0 for this scope
        
        for ($i = 1; $i <= $months; $i++) {
            Installment::create([
                'transaction_id' => $transaction->id,
                'installment_number' => $i,
                'due_date' => now()->addMonths($i),
                'amount' => $monthlyAmount,
                'status' => 'pending',
            ]);
        }
    }

    /**
     * Record payment for an installment.
     */
    public function recordPayment(int $installmentId, float $amount, ?string $notes = null): Installment
    {
        $installment = Installment::findOrFail($installmentId);
        
        $newPaid = $installment->paid_amount + $amount;
        $status = $newPaid >= $installment->amount ? 'paid' : 'partial';

        $installment->update([
            'paid_amount' => $newPaid,
            'status' => $status,
            'paid_at' => $status === 'paid' ? now() : null,
            'notes' => $notes,
        ]);

        return $installment;
    }

    /**
     * Get overdue installments.
     */
    public function getOverdueInstallments(int $storeId): Collection
    {
        return Installment::whereHas('transaction', function ($q) use ($storeId) {
                $q->where('store_id', $storeId);
            })
            ->where('status', '!=', 'paid')
            ->where('due_date', '<', now())
            ->with(['transaction.user']) // Assuming user is customer here
            ->get();
    }
    
    /**
     * Generate Aging Report.
     */
    public function getAgingReport(int $storeId): array
    {
        $installments = Installment::whereHas('transaction', function ($q) use ($storeId) {
                $q->where('store_id', $storeId);
            })
            ->where('status', '!=', 'paid')
            ->get();

        $aging = [
            '0-30' => 0,
            '31-60' => 0,
            '61-90' => 0,
            '90+' => 0,
        ];

        foreach ($installments as $inst) {
            $daysOverdue = Carbon::parse($inst->due_date)->diffInDays(now(), false);
            
            if ($daysOverdue <= 0) continue; // Not overdue yet

            if ($daysOverdue <= 30) $aging['0-30'] += ($inst->amount - $inst->paid_amount);
            elseif ($daysOverdue <= 60) $aging['31-60'] += ($inst->amount - $inst->paid_amount);
            elseif ($daysOverdue <= 90) $aging['61-90'] += ($inst->amount - $inst->paid_amount);
            else $aging['90+'] += ($inst->amount - $inst->paid_amount);
        }

        return $aging;
    }
}
