<?php

namespace App\Services;

class TaxService
{
    /**
     * Calculate PPN (Value Added Tax)
     * Standard 11% in Indonesia
     */
    public function calculatePPN(float $subtotal, float $rate = 0.11): float
    {
        return round($subtotal * $rate, 2);
    }

    /**
     * Calculate PPh Final UMKM (0.5% of gross revenue)
     */
    public function calculatePPhFinal(float $grossRevenue, float $rate = 0.005): float
    {
        return round($grossRevenue * $rate, 2);
    }

    /**
     * Calculate Service Charge
     */
    public function calculateServiceCharge(float $subtotal, float $rate = 0.05): float
    {
        return round($subtotal * $rate, 2);
    }
}
