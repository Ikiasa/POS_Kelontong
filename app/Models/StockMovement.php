<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class StockMovement extends Model
{
    use HasFactory;

    protected $fillable = [
        'store_id',
        'product_id',
        'batch_id', // [NEW]
        'user_id',
        'type',
        'reference_type',
        'reference_id',
        'quantity',
        'before_stock',
        'after_stock',
        'notes',
        'created_at'
    ];

    protected $casts = [
        'type' => \App\Enums\StockMovementType::class,
        'quantity' => 'integer',
        'before_stock' => 'integer',
        'after_stock' => 'integer',
    ];

    public function batch()
    {
        return $this->belongsTo(ProductBatch::class);
    }
}
