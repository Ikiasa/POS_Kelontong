<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class BusinessHealthScore extends Model
{
    use HasFactory;

    protected $guarded = [];

    protected $casts = [
        'breakdown' => 'array',
        'calculated_at' => 'date',
    ];

    public function store(): BelongsTo
    {
        return $this->belongsTo(Store::class);
    }
}
