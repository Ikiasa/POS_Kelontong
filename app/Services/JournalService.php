<?php

namespace App\Services;

use App\Models\JournalEntry;
use App\Models\JournalItem;
use Illuminate\Support\Facades\DB;
use Exception;

class JournalService
{
    /**
     * Create a balanced Journal Entry.
     */
    public function recordEntry(
        int $storeId,
        string $date,
        string $referenceNumber,
        string $description,
        string $sourceType,
        int $sourceId,
        array $uItems // Form: [['account_code', 'account_name', 'debit', 'credit']]
    ): JournalEntry {
        return DB::transaction(function () use ($storeId, $date, $referenceNumber, $description, $sourceType, $sourceId, $uItems) {
            
            // 1. Validate Balance (Debit == Credit)
            $totalDebit = collect($uItems)->sum('debit');
            $totalCredit = collect($uItems)->sum('credit');

            if (abs($totalDebit - $totalCredit) > 0.01) { // Floating point tolerance
                throw new Exception("Journal Entry Unbalanced: Debit ({$totalDebit}) != Credit ({$totalCredit})");
            }

            // 2. Create Header
            $entry = JournalEntry::create([
                'store_id' => $storeId,
                'transaction_date' => $date,
                'reference_number' => $referenceNumber,
                'description' => $description,
                'reference_type' => $sourceType,
                'reference_id' => $sourceId,
                'user_id' => auth()->id(),
                'is_posted' => true,
                'posted_at' => now(),
            ]);

            // 3. Create Line Items
            foreach ($uItems as $item) {
                JournalItem::create([
                    'journal_entry_id' => $entry->id,
                    'account_code' => $item['account_code'],
                    'account_name' => $item['account_name'],
                    'debit' => $item['debit'],
                    'credit' => $item['credit'],
                ]);
            }

            return $entry;
        });
    }

    /**
     * Generate standard Sale Journal
     * Dr. Cash/Receivable
     *    Cr. Sales Revenue
     * Dr. COGS
     *    Cr. Inventory
     */
    public function recordSaleJournal(
        int $storeId,
        string $invoiceNumber,
        float $subtotal,
        float $totalCost,
        float $taxAmount = 0,
        float $serviceCharge = 0,
        array $payments = [] // [['method' => 'cash', 'amount' => 1000]]
    ): void {
        $items = [];
        $totalRevenue = $subtotal + $taxAmount + $serviceCharge;

        // 1. Debit Legs (Assets) - From Payments
        foreach ($payments as $payment) {
            $debitAccount = match($payment['method']) {
                'cash' => '1100-Cash',
                'qris' => '1120-E-Wallet/QRIS',
                'gopay' => '1121-GoPay Wallet',
                'ovo' => '1122-OVO Wallet',
                'shopeepay' => '1123-ShopeePay Wallet',
                'transfer' => '1110-Bank Transfer',
                default => '1100-Cash'
            };

            $items[] = [
                'account_code' => explode('-', $debitAccount)[0],
                'account_name' => explode('-', $debitAccount)[1],
                'debit' => $payment['amount'],
                'credit' => 0
            ];
        }

        // 2. Credit Legs (Revenue & Liabilities)
        // Sales Revenue
        $items[] = [
            'account_code' => '4000',
            'account_name' => 'Sales Revenue',
            'debit' => 0,
            'credit' => $subtotal
        ];

        // Tax Payable (Liability)
        if ($taxAmount > 0) {
            $items[] = [
                'account_code' => '2100',
                'account_name' => 'Tax Payable (PPN)',
                'debit' => 0,
                'credit' => $taxAmount
            ];
        }

        // Service Revenue
        if ($serviceCharge > 0) {
            $items[] = [
                'account_code' => '4100',
                'account_name' => 'Service Income',
                'debit' => 0,
                'credit' => $serviceCharge
            ];
        }

        // 3. COGS & Inventory (Expense & Asset)
        $items[] = [
            'account_code' => '5000',
            'account_name' => 'Cost of Goods Sold',
            'debit' => $totalCost, 
            'credit' => 0
        ];
        $items[] = [
            'account_code' => '1300',
            'account_name' => 'Inventory',
            'debit' => 0,
            'credit' => $totalCost
        ];

        $this->recordEntry(
            $storeId,
            now()->toDateString(),
            "JE-" . $invoiceNumber,
            "Sale Invoice #{$invoiceNumber}",
            'App\Models\Transaction',
            0,
            $items
        );
    }

    /**
     * Generate standard Return Journal
     * Dr. Sales Returns (or Revenue)
     *    Cr. Cash/Wallet
     * Dr. Inventory
     *    Cr. COGS
     */
    public function recordReturnJournal(
        int $storeId,
        string $invoiceNumber,
        float $refundAmount,
        string $paymentMethod
    ): void {
        $items = [];

        // 1. Debit Revenue reversal
        $items[] = [
            'account_code' => '4000', // Sales Revenue
            'account_name' => 'Sales Returns/Revenue',
            'debit' => $refundAmount,
            'credit' => 0
        ];

        // 2. Credit Asset (Refund)
        $creditAccount = match($paymentMethod) {
            'cash' => '1100-Cash',
            'qr' => '1120-E-Wallet/QRIS',
            default => '1100-Cash'
        };

        $items[] = [
            'account_code' => explode('-', $creditAccount)[0],
            'account_name' => explode('-', $creditAccount)[1],
            'debit' => 0,
            'credit' => $refundAmount
        ];

        // Note: We are omitting COGS/Inventory reversal here to keep it simple,
        // unless you want real-time COGS adjustment.
        // For accurate finance, we'd need the cost of the specific items being returned.

        $this->recordEntry(
            $storeId,
            now()->toDateString(),
            "RTN-" . $invoiceNumber,
            "Return for Invoice #{$invoiceNumber}",
            'App\Models\ReturnTransaction',
            0,
            $items
        );
    }
}
