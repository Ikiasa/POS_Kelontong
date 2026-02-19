<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProductBatch extends Model
{
    use HasFactory;

    protected $fillable = [
        'store_id',
        'product_id',
        'batch_number',
        'expiry_date',
        'initial_quantity',
        'current_quantity',
        'cost_price',
        'received_at'
    ];

    protected $casts = [
        'expiry_date' => 'date',
        'received_at' => 'datetime',
        'cost_price' => 'decimal:2',
    ];

    public function product()
    {
        return $this->belongsTo(Product::class);
    }

    public function store()
    {
        return $this->belongsTo(Store::class);
    }

    public function scopeAvailable($query)
    {
        return $query->where('current_quantity', '>', 0);
    }

    public function getStatusAttribute(): string
    {
        if (!$this->expiry_date) return 'safe';
        if ($this->expiry_date->isPast()) return 'expired';
        if ($this->expiry_date->diffInDays(now()) <= 30) return 'warning';
        return 'safe';
    }

    public function getStatusLabelAttribute(): string
    {
        return match($this->status) {
            'expired' => 'Expired',
            'warning' => 'Near Expiry',
            'safe' => 'Good',
        };
    }

    public function getStatusColorAttribute(): string
    {
        return match($this->status) {
            'expired' => 'bg-red-100 text-red-800 border-red-200',
            'warning' => 'bg-yellow-100 text-yellow-800 border-yellow-200',
            'safe' => 'bg-gray-100 text-gray-800 border-gray-200',
        };
    }
}
