<?php

namespace App\Enums;

enum StockMovementType: string
{
    case SALE = 'sale';
    case PURCHASE = 'purchase';
    case ADJUSTMENT = 'adjustment';
    case RETURN = 'return';
    case TRANSFER = 'transfer';
}
