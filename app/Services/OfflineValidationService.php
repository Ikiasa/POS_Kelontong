<?php

namespace App\Services;

use Illuminate\Support\Facades\Config;

class OfflineValidationService
{
    protected string $secret;

    public function __construct()
    {
        // Use a unique system secret for code generation
        $this->secret = config('app.key', 'KELONTONG-SECRET-2026');
    }

    /**
     * Generate a validation code for a specific store and date.
     * Format: 6-digit alphanumeric code.
     */
    public function generateCode(int $storeId, string $date = null): string
    {
        $date = $date ?? date('Y-m-d');
        $hash = hash_hmac('sha256', "OFFLINE-{$storeId}-{$date}", $this->secret);
        
        // Take 6 characters and uppercase
        return strtoupper(substr($hash, 0, 6));
    }

    /**
     * Verify if a provided code is valid for the store today.
     */
    public function verifyCode(int $storeId, string $code): bool
    {
        $expected = $this->generateCode($storeId);
        return hash_equals($expected, strtoupper($code));
    }
}
