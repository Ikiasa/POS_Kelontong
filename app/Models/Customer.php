<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Customer extends Model
{
    protected $guarded = [];

    public function loyaltyLogs(): HasMany
    {
        return $this->hasMany(LoyaltyLog::class);
    }
}
