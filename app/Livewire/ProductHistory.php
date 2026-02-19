<?php

namespace App\Livewire;

use App\Models\Product;
use App\Models\StockMovement;
use Livewire\Component;
use Livewire\WithPagination;

class ProductHistory extends Component
{
    use WithPagination;

    public $product;
    public $showModal = false;
    public $showAdjustmentForm = false;
    
    // Adjustment Form Properties
    public $adjType = 'add'; // add, subtract
    public $adjQty = 0;
    public $adjNote = '';

    protected $listeners = ['showProductHistory' => 'loadProduct'];

    public function loadProduct($productId)
    {
        $this->product = Product::find($productId);
        $this->showModal = true;
        $this->showAdjustmentForm = false;
        $this->reset(['adjType', 'adjQty', 'adjNote']);
        $this->resetPage();
    }

    public function toggleAdjustmentForm()
    {
        $this->showAdjustmentForm = ! $this->showAdjustmentForm;
        $this->reset(['adjType', 'adjQty', 'adjNote']);
    }

    public function saveAdjustment()
    {
        $this->validate([
            'adjQty' => 'required|integer|min:1',
            'adjNote' => 'required|string|max:255',
        ]);

        if ($this->adjType === 'subtract' && $this->product->stock < $this->adjQty) {
            $this->addError('adjQty', 'Stok tidak mencukupi untuk pengurangan ini.');
            return;
        }

        $quantityChange = $this->adjType === 'add' ? $this->adjQty : -$this->adjQty;
        $newBalance = $this->product->stock + $quantityChange;

        // Update Product Stock
        $this->product->update(['stock' => $newBalance]);

        // Create Stock Movement Record
        StockMovement::create([
            'store_id' => 1, // Default store for now
            'product_id' => $this->product->id,
            'user_id' => auth()->id(),
            'reference_type' => 'adjustment',
            'reference_id' => time(), // Simple unique ref for manual adjustment
            'quantity_change' => $quantityChange,
            'balance_after' => $newBalance,
            'notes' => $this->adjNote,
        ]);

        $this->showAdjustmentForm = false;
        $this->reset(['adjType', 'adjQty', 'adjNote']);
        
        // Refresh product to show new stock on UI
        $this->product->refresh();
        
        session()->flash('success', 'Stok berhasil diperbarui.');
    }

    public function closeModal()
    {
        $this->showModal = false;
        $this->product = null;
        $this->showAdjustmentForm = false;
    }

    public function render()
    {
        $movements = collect();

        if ($this->product) {
            $movements = StockMovement::where('product_id', $this->product->id)
                ->with('user')
                ->latest()
                ->paginate(10);
        }

        return view('livewire.product-history', [
            'movements' => $movements,
        ]);
    }
}
