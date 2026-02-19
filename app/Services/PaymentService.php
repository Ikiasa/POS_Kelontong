<?php

namespace App\Services;

use App\Models\Transaction;
use App\Models\TransactionPayment;
use App\Models\StoreWallet;
use Illuminate\Support\Facades\DB;
use Exception;

class PaymentService
{
    /**
     * Generate a simulated QRIS string for the transaction.
     */
    public function generateQRIS(Transaction $transaction): string
    {
        // QRIS payload usually contains Merchant Name, Location, and Amount (Dynamic QRIS)
        // For simulation, we return a standard-looking QRIS string
        $amount = number_format($transaction->grand_total, 0, '', '');
        return "00020101021226300016ID.CO.QRIS.WWW011893600523000000010215$amount" . "5802ID5911KelontongKu6005Depok62070703A016304" . strtoupper(substr(md5($transaction->id), 0, 4));
    }

    /**
     * Process multiple payments for a single transaction.
     */
    public function processPayments(Transaction $transaction, array $paymentItems): void
    {
        foreach ($paymentItems as $item) {
            $payment = TransactionPayment::create([
                'transaction_id' => $transaction->id,
                'method' => $item['method'],
                'amount' => $item['amount'],
                'reference_number' => $item['reference_number'] ?? null,
                'metadata' => $item['metadata'] ?? [],
            ]);

            // If it's a digital payment, automatically reconcile to wallet
            if ($this->isDigitalMethod($item['method'])) {
                $this->updateWalletBalance($transaction->store_id, $item['method'], $item['amount']);
            }
        }

        // Add summary to transaction header
        $transaction->update([
            'payment_details' => $paymentItems
        ]);
    }

    /**
     * Update or create a store wallet balance.
     */
    protected function updateWalletBalance(int $storeId, string $method, float $amount): void
    {
        $wallet = StoreWallet::firstOrCreate(
            ['store_id' => $storeId, 'provider' => $this->normalizeProvider($method)],
            ['balance' => 0]
        );

        $wallet->increment('balance', $amount);
    }

    /**
     * Check if payment method is digital (e-wallet/QRIS).
     */
    protected function isDigitalMethod(string $method): bool
    {
        return in_array($method, ['qris', 'gopay', 'ovo', 'shopeepay', 'dana', 'linkaja']);
    }

    /**
     * Normalize payment method to provider name.
     */
    protected function normalizeProvider(string $method): string
    {
        // Add mapping if needed, e.g. 'qris' might go to a specific settlement account
        return $method;
    }
}
