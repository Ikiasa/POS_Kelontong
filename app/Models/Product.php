<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Product extends Model
{
    use HasFactory;

    protected $guarded = []; // Allow mass assignment for all fields (including image)

    public function batches()
    {
        return $this->hasMany(ProductBatch::class);
    }

    public function supplier()
    {
        return $this->belongsTo(Supplier::class);
    }

    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    public function store()
    {
        return $this->belongsTo(Store::class);
    }

    public function stockMovements()
    {
        return $this->hasMany(StockMovement::class);
    }
    public function priceTiers()
    {
        return $this->hasMany(PriceTier::class);
    }

    public function isWeighted()
    {
        return $this->is_weighted;
    }
}
