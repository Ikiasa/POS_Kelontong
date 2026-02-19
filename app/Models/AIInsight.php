<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AIInsight extends Model
{
    use HasFactory;

    protected $table = 'ai_insights';
    protected $guarded = [];

    protected $casts = [
        'suggestion_data' => 'array',
        'approved_at' => 'datetime',
        'applied_at' => 'datetime',
    ];

    public function store(): BelongsTo
    {
        return $this->belongsTo(Store::class);
    }
}
