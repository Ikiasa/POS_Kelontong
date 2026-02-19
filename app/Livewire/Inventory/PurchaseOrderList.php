<?php

namespace App\Livewire\Inventory;

use App\Models\PurchaseOrder;
use Livewire\Component;
use Livewire\WithPagination;

class PurchaseOrderList extends Component
{
    use WithPagination;

    public $search = '';
    public $statusFilter = '';

    public function updatingSearch() { $this->resetPage(); }
    public function updatingStatusFilter() { $this->resetPage(); }

    public function render()
    {
        $query = PurchaseOrder::with('supplier', 'user')
            ->latest();

        if ($this->search) {
            $query->where('po_number', 'like', '%' . $this->search . '%')
                ->orWhereHas('supplier', function ($q) {
                    $q->where('name', 'like', '%' . $this->search . '%');
                });
        }

        if ($this->statusFilter) {
            $query->where('status', $this->statusFilter);
        }

        return view('livewire.inventory.purchase-order-list', [
            'orders' => $query->paginate(10)
        ])->layout('components.layouts.dashboard');
    }
}
