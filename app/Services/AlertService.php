<?php

namespace App\Services;

use App\Models\SystemAlert;
use Illuminate\Support\Facades\Log;

class AlertService
{
    public function trigger(int $storeId, string $type, string $message, string $severity, array $metadata = [])
    {
        $alert = SystemAlert::create([
            'store_id' => $storeId,
            'type' => $type,
            'message' => $message,
            'severity' => $severity,
            'metadata' => $metadata
        ]);

        // Placeholder for real-time notification (e.g., Pusher, WhatsApp, Email)
        $this->notifyOwner($alert);

        return $alert;
    }

    protected function notifyOwner(SystemAlert $alert)
    {
        // For simulation/hardened POC, we log to a specific 'alerts' channel
        Log::channel('daily')->info("SYSTEM ALERT [{$alert->severity}]: {$alert->message}", [
            'store_id' => $alert->store_id,
            'metadata' => $alert->metadata
        ]);

        // Logic for WhatsApp/Email integration would be added here
    }

    public function getUnreadAlerts(int $storeId)
    {
        return SystemAlert::where('store_id', $storeId)
            ->whereNull('read_at')
            ->latest()
            ->get();
    }
}
