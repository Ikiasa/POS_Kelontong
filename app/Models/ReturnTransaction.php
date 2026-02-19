<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class ReturnTransaction extends Model
{
    use HasFactory;

    protected $keyType = 'string';
    public $incrementing = false;

    protected $fillable = [
        'id',
        'transaction_id',
        'store_id',
        'user_id',
        'total_refunded',
        'payment_method',
        'reason'
    ];

    protected $casts = [
        'total_refunded' => 'decimal:2',
    ];

    protected static function boot()
    {
        parent::boot();
        static::creating(function ($model) {
            if (!$model->id) {
                $model->id = (string) Str::uuid();
            }
        });
    }

    public function originalTransaction()
    {
        return $this->belongsTo(Transaction::class, 'transaction_id');
    }

    public function items()
    {
        return $this->hasMany(ReturnItem::class);
    }

    public function store()
    {
        return $this->belongsTo(Store::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
