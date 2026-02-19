<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class StockTransfer extends Model
{
    protected $guarded = [];

    public function items(): HasMany
    {
        return $this->hasMany(StockTransferItem::class);
    }

    public function sourceStore(): BelongsTo
    {
        return $this->belongsTo(Store::class, 'source_store_id');
    }

    public function destStore(): BelongsTo
    {
        return $this->belongsTo(Store::class, 'dest_store_id');
    }
}
