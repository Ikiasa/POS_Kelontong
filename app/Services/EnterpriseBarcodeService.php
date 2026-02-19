<?php

namespace App\Services;

class EnterpriseBarcodeService
{
    /**
     * Generate a 12-digit barcode with a checksum (UPC-A style)
     */
    public function generate(string $prefix = '888'): string
    {
        // Generate 11 random digits (including prefix)
        $digits = $prefix . str_pad(rand(0, 99999999), 8, '0', STR_PAD_LEFT);
        
        // Calculate Checksum for the 12th digit
        $checksum = $this->calculateChecksum($digits);
        
        return $digits . $checksum;
    }

    /**
     * Calculate UPC-A Checksum
     */
    public function calculateChecksum(string $digits): int
    {
        $sumOdd = 0;
        $sumEven = 0;
        
        for ($i = 0; $i < strlen($digits); $i++) {
            $num = (int)$digits[$i];
            if (($i + 1) % 2 !== 0) {
                $sumOdd += $num;
            } else {
                $sumEven += $num;
            }
        }
        
        $total = ($sumOdd * 3) + $sumEven;
        $remainder = $total % 10;
        
        return $remainder === 0 ? 0 : 10 - $remainder;
    }

    /**
     * Validate barcode with its checksum
     */
    public function validate(string $barcode): bool
    {
        if (strlen($barcode) !== 12) return false;
        
        $digits = substr($barcode, 0, 11);
        $check = (int)$barcode[11];
        
        return $this->calculateChecksum($digits) === $check;
    }
}
