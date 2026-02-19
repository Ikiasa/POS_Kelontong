<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;

class ConnectivityService
{
    // Minimal check, can be expanded to check specific hardware APIs
    public function checkInternet(): bool
    {
        try {
            // Fast timeout check to google DNS or similar
            $response = Http::timeout(2)->Head('https://8.8.8.8'); // Or a reliable endpoint
            return true;
        } catch (\Exception $e) {
            return false;
        }
    }

    public function checkPrinter(string $printerIp): bool
    {
        // Simple socket check
        $fp = @fsockopen($printerIp, 9100, $errno, $errstr, 1);
        if ($fp) {
            fclose($fp);
            return true;
        }
        return false;
    }
}
