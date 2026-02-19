<?php

namespace App\Services;

class FreshFoodBarcodeService
{
    /**
     * Parse a weight-embedded barcode (Standard: 22PPPPPWWWWW C)
     * Prefix 22 is commonly used for in-store weighted items.
     */
    public function parse(string $barcode): ?array
    {
        if (strlen($barcode) !== 13) return null;
        if (!str_starts_with($barcode, '22')) return null;

        $productCode = substr($barcode, 2, 5);
        $weightValue = (int)substr($barcode, 7, 5); // Usually in grams or price

        // Many scales use 5 digits for value (e.g., 01500 = 1.5kg or 15000 Rp)
        // For this implementation, we assume it's Weight in Grams
        $weightKg = $weightValue / 1000;

        return [
            'product_code' => $productCode,
            'weight' => $weightKg,
            'is_weighted' => true
        ];
    }
}
