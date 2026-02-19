<?php

namespace App\Exceptions;

use Exception;

class InsufficientStockException extends Exception
{
    public function __construct(string $productName, int $currentStock, int $requestedQuantity)
    {
        parent::__construct("Insufficient stock for '{$productName}'. Available: {$currentStock}, Requested: {$requestedQuantity}");
    }
}
