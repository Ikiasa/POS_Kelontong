<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ReturnItem extends Model
{
    use HasFactory;

    protected $fillable = [
        'return_transaction_id',
        'product_id',
        'quantity',
        'refund_price'
    ];

    protected $casts = [
        'refund_price' => 'decimal:2',
    ];

    public function returnTransaction()
    {
        return $this->belongsTo(ReturnTransaction::class);
    }

    public function product()
    {
        return $this->belongsTo(Product::class);
    }
}
