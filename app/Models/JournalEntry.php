<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class JournalEntry extends Model
{
    use HasFactory;

    protected $guarded = [];

    protected $casts = [
        'transaction_date' => 'date',
        'is_posted' => 'boolean',
    ];

    public function items()
    {
        return $this->hasMany(JournalItem::class);
    }

    public function reference()
    {
        return $this->morphTo();
    }
}
