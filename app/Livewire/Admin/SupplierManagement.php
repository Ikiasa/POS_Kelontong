<?php

namespace App\Livewire\Admin;

use App\Models\Supplier;
use Livewire\Component;
use Livewire\WithPagination;

class SupplierManagement extends Component
{
    use WithPagination;

    public $search = '';
    public $showModal = false;
    public $isEditing = false;
    public $supplierId;
    public $name, $contact_person, $phone, $email, $address, $default_lead_time_days = 3, $minimum_order_value = 0;

    protected $rules = [
        'name' => 'required|string|max:255',
        'contact_person' => 'nullable|string|max:255',
        'phone' => 'nullable|string|max:20',
        'email' => 'nullable|email|max:255',
        'address' => 'nullable|string',
        'default_lead_time_days' => 'required|integer|min:0',
        'minimum_order_value' => 'required|numeric|min:0',
    ];

    public function updatingSearch() { $this->resetPage(); }

    public function create()
    {
        $this->reset(['name', 'contact_person', 'phone', 'email', 'address', 'default_lead_time_days', 'minimum_order_value', 'supplierId']);
        $this->default_lead_time_days = 3;
        $this->minimum_order_value = 0;
        $this->isEditing = false;
        $this->showModal = true;
    }

    public function edit(Supplier $supplier)
    {
        $this->supplierId = $supplier->id;
        $this->name = $supplier->name;
        $this->contact_person = $supplier->contact_person;
        $this->phone = $supplier->phone;
        $this->email = $supplier->email;
        $this->address = $supplier->address;
        $this->default_lead_time_days = $supplier->default_lead_time_days;
        $this->minimum_order_value = $supplier->minimum_order_value;
        $this->isEditing = true;
        $this->showModal = true;
    }

    public function save()
    {
        $validated = $this->validate();

        if ($this->isEditing) {
            $supplier = Supplier::find($this->supplierId);
            $supplier->update($validated);
            session()->flash('success', 'Supplier updated successfully.');
        } else {
            Supplier::create($validated);
            session()->flash('success', 'Supplier created successfully.');
        }

        $this->showModal = false;
    }

    public function delete($id)
    {
        $supplier = Supplier::find($id);
        // Prevent deletion if linked to products or POs
        if ($supplier->products()->exists() || $supplier->purchaseOrders()->exists()) {
             session()->flash('error', 'Cannot delete supplier with linked products or purchase orders.');
             return;
        }

        $supplier->delete();
        session()->flash('success', 'Supplier deleted.');
    }

    public function render()
    {
        $suppliers = Supplier::where('name', 'like', '%' . $this->search . '%')
            ->orWhere('contact_person', 'like', '%' . $this->search . '%')
            ->orderBy('name')
            ->paginate(10);

        return view('livewire.admin.supplier-management', [
            'suppliers' => $suppliers
        ])->layout('components.layouts.dashboard');
    }
}
