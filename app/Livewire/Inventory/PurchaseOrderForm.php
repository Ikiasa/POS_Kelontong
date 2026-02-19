<?php

namespace App\Livewire\Inventory;

use App\Models\Product;
use App\Models\PurchaseOrder;
use App\Models\PurchaseOrderItem;
use App\Models\Supplier;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Livewire\Component;

class PurchaseOrderForm extends Component
{
    public ?PurchaseOrder $po = null;
    public $isEditing = false;

    // Form Fields
    public $supplier_id;
    public $po_number;
    public $status = 'draft';
    public $ordered_at;
    public $expected_at;
    public $notes;
    
    // Items
    public $items = []; // [{product_id, quantity, unit_cost, total_cost}]

    // Search Products
    public $productSearch = '';
    public $searchResults = [];

    protected $rules = [
        'supplier_id' => 'required|exists:suppliers,id',
        'po_number' => 'required|string|unique:purchase_orders,po_number',
        'status' => 'required|in:draft,ordered,received,cancelled',
        'items' => 'required|array|min:1',
        'items.*.product_id' => 'required|exists:products,id',
        'items.*.quantity' => 'required|integer|min:1',
        'items.*.unit_cost' => 'required|numeric|min:0',
    ];

    public function mount($id = null)
    {
        if ($id) {
            $this->po = PurchaseOrder::with('items.product')->findOrFail($id);
            $this->isEditing = true;
            $this->supplier_id = $this->po->supplier_id;
            $this->po_number = $this->po->po_number;
            $this->status = $this->po->status;
            $this->ordered_at = $this->po->ordered_at?->format('Y-m-d');
            $this->expected_at = $this->po->expected_at?->format('Y-m-d');
            $this->notes = $this->po->notes;

            foreach ($this->po->items as $item) {
                $this->items[] = [
                    'product_id' => $item->product_id,
                    'product_name' => $item->product->name,
                    'quantity' => $item->quantity,
                    'unit_cost' => $item->unit_cost,
                    'total_cost' => $item->total_cost,
                ];
            }
        } else {
            $this->po_number = 'PO-' . date('Ymd') . '-' . rand(1000, 9999);
            $this->ordered_at = now()->format('Y-m-d');
            $this->items[] = [
                'product_id' => '', 'product_name' => '', 'quantity' => 1, 'unit_cost' => 0, 'total_cost' => 0
            ];
        }
    }

    public function updatedProductSearch($value)
    {
        if (strlen($value) < 2) {
            $this->searchResults = [];
            return;
        }
        $this->searchResults = Product::where('name', 'like', '%' . $value . '%')
            ->orWhere('barcode', 'like', '%' . $value . '%')
            ->limit(10)->get();
    }

    public function selectProduct($index, $productId, $name, $cost)
    {
        $this->items[$index]['product_id'] = $productId;
        $this->items[$index]['product_name'] = $name;
        $this->items[$index]['unit_cost'] = $cost; // Default to current cost
        $this->calculateRowTotal($index);
        $this->productSearch = '';
        $this->searchResults = [];
    }

    public function calculateRowTotal($index)
    {
        $qty = (int) ($this->items[$index]['quantity'] ?? 0);
        $cost = (float) ($this->items[$index]['unit_cost'] ?? 0);
        $this->items[$index]['total_cost'] = $qty * $cost;
    }

    public function addItem()
    {
        $this->items[] = [
            'product_id' => '', 'product_name' => '', 'quantity' => 1, 'unit_cost' => 0, 'total_cost' => 0
        ];
    }

    public function removeItem($index)
    {
        unset($this->items[$index]);
        $this->items = array_values($this->items);
    }

    public function save()
    {
        $rules = $this->rules;
        if ($this->isEditing) {
            $rules['po_number'] = 'required|string|unique:purchase_orders,po_number,' . $this->po->id;
        }
        $this->validate($rules);

        DB::transaction(function () {
            $totalAmount =  collect($this->items)->sum('total_cost');

            $data = [
                'store_id' => 1, // Default store
                'supplier_id' => $this->supplier_id,
                'po_number' => $this->po_number,
                'status' => $this->status,
                'ordered_at' => $this->ordered_at,
                'expected_at' => $this->expected_at,
                'received_at' => $this->status == 'received' ? now() : null,
                'notes' => $this->notes,
                'total_amount' => $totalAmount,
                'user_id' => auth()->id(),
            ];

            if ($this->isEditing) {
                $this->po->update($data);
                $this->po->items()->delete(); // Re-create items
                $po = $this->po;
            } else {
                $po = PurchaseOrder::create($data);
            }

            foreach ($this->items as $item) {
                PurchaseOrderItem::create([
                    'purchase_order_id' => $po->id,
                    'product_id' => $item['product_id'],
                    'quantity' => $item['quantity'],
                    'unit_cost' => $item['unit_cost'],
                    'total_cost' => $item['total_cost'],
                ]);

                // Update Stock if Received
                if ($this->status === 'received') {
                    $product = Product::find($item['product_id']);
                    $product->increment('stock', $item['quantity']);
                    // Optional: Update cost price to new cost or average
                    // $product->update(['cost_price' => $item['unit_cost']]);
                }
            }
        });

        session()->flash('success', 'Purchase Order saved successfully.');
        return redirect()->route('purchase-orders.index');
    }

    public function render()
    {
        return view('livewire.inventory.purchase-order-form', [
            'suppliers' => Supplier::all()
        ])->layout('components.layouts.dashboard');
    }
}
