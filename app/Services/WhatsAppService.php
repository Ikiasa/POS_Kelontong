<?php

namespace App\Services;

use App\Jobs\SendWhatsAppMessage;
use App\Models\WhatsAppLog;

class WhatsAppService
{
    /**
     * Queue a WhatsApp message.
     */
    public function send(string $phone, string $message, string $type = 'notification', ?int $customerId = null): void
    {
        // 1. Create Log Entry (Status: queued)
        $log = WhatsAppLog::create([
            'customer_id' => $customerId,
            'phone' => $phone,
            'message' => $message,
            'type' => $type,
            'status' => 'queued',
        ]);

        // 2. Dispatch Job
        SendWhatsAppMessage::dispatch($log);
    }

    public function sendReceipt(string $phone, string $transactionNumber, float $amount, string $pdfUrl): void
    {
        $message = "Thank you for your purchase at POS Kelontong!\n\n";
        $message .= "Trx: $transactionNumber\n";
        $message .= "Total: Rp " . number_format($amount, 0) . "\n\n";
        $message .= "Download Receipt: $pdfUrl";

        $this->send($phone, $message, 'receipt');
    }

    public function sendPaymentReminder(string $phone, string $transactionNumber, float $balance): void
    {
        $message = "Friendly reminder for transaction #$transactionNumber.\n";
        $message .= "Outstanding balance: Rp " . number_format($balance, 0) . ".\n";
        $message .= "Please complete your payment soon. Thank you!";

        $this->send($phone, $message, 'reminder');
    }

    public function sendPromoBroadcast(array $phones, string $promoText): void
    {
        foreach ($phones as $phone) {
            $this->send($phone, $promoText, 'broadcast');
        }
    }
}
