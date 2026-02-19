<?php

namespace App\Livewire;

use App\Models\Category;
use App\Models\Product;
use Livewire\Component;
use Livewire\WithPagination;

class ProductTable extends Component
{
    use WithPagination;

    public $search = '';
    public $category = '';
    public $stockFilter = ''; // 'low', 'out', 'active'
    public $sortField = 'name';
    public $sortDirection = 'asc';

    protected $queryString = [
        'search' => ['except' => ''],
        'category' => ['except' => ''],
        'stockFilter' => ['except' => ''],
        'sortField' => ['except' => 'name'],
        'sortDirection' => ['except' => 'asc'],
    ];

    public function updatingSearch()
    {
        $this->resetPage();
    }

    public function updatingCategory()
    {
        $this->resetPage();
    }

    public function sortBy($field)
    {
        if ($this->sortField === $field) {
            $this->sortDirection = $this->sortDirection === 'asc' ? 'desc' : 'asc';
        } else {
            $this->sortField = $field;
            $this->sortDirection = 'asc';
        }
    }

    public function render()
    {
        // Summary Metrics
        $totalProducts = Product::count();
        $lowStockCount = Product::where('stock', '<=', 10)->where('stock', '>', 0)->count();
        // Dead Stock: No sales movements in last 30 days
        $deadStockCount = Product::where('stock', '>', 0)
            ->whereDoesntHave('stockMovements', function ($q) {
                $q->where('reference_type', 'sale')
                  ->where('created_at', '>=', now()->subDays(30));
            })->count();
            
        $totalValue = Product::selectRaw('SUM(stock * cost_price) as total')->value('total') ?? 0;

        $query = Product::with('category');

        // Search
        if ($this->search) {
            $query->where(function ($q) {
                $q->where('name', 'like', '%' . $this->search . '%')
                  ->orWhere('barcode', 'like', '%' . $this->search . '%');
            });
        }

        // Category Filter
        if ($this->category) {
            $query->where('category_id', $this->category);
        }

        // Stock Filter
        if ($this->stockFilter === 'low') {
            $query->where('stock', '<=', 10)->where('stock', '>', 0);
        } elseif ($this->stockFilter === 'out') {
            $query->where('stock', '<=', 0);
        } elseif ($this->stockFilter === 'active') {
            $query->where('stock', '>', 0);
        } elseif ($this->stockFilter === 'dead_stock') {
            $query->where('stock', '>', 0)
                ->whereDoesntHave('stockMovements', function ($q) {
                    $q->where('reference_type', 'sale')
                      ->where('created_at', '>=', now()->subDays(30));
                });
        }

        // Sorting
        $products = $query->orderBy($this->sortField, $this->sortDirection)
                          ->paginate(10);

        return view('livewire.product-table', [
            'products' => $products,
            'categories' => Category::all(),
            'totalProducts' => $totalProducts,
            'lowStockCount' => $lowStockCount,
            'deadStockCount' => $deadStockCount,
            'totalValue' => $totalValue,
        ]);
    }
}
