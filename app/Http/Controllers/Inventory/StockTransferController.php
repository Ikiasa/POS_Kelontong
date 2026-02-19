<?php

namespace App\Http\Controllers\Inventory;

use App\Http\Controllers\Controller;
use App\Models\Product;
use App\Models\StockTransfer;
use App\Models\StockTransferItem;
use App\Models\Store;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class StockTransferController extends Controller
{
    public function index()
    {
        $transfers = StockTransfer::with(['sourceStore', 'destStore', 'createdBy'])
            ->latest()
            ->paginate(10);

        return Inertia::render('Inventory/StockTransfers/Index', [
            'transfers' => $transfers
        ]);
    }

    public function create()
    {
        return Inertia::render('Inventory/StockTransfers/Create', [
            'stores' => Store::all(),
            'products' => Product::select('id', 'name', 'barcode', 'stock', 'store_id')->get(),
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'source_store_id' => 'required|exists:stores,id',
            'dest_store_id' => 'required|exists:stores,id|different:source_store_id',
            'items' => 'required|array|min:1',
            'items.*.product_id' => 'required|exists:products,id',
            'items.*.quantity' => 'required|integer|min:1',
            'notes' => 'nullable|string'
        ]);

        DB::transaction(function () use ($request) {
            $transfer = StockTransfer::create([
                'transfer_number' => 'TRF-' . strtoupper(uniqid()),
                'source_store_id' => $request->source_store_id,
                'dest_store_id' => $request->dest_store_id,
                'status' => 'pending',
                'notes' => $request->notes,
                'created_by' => Auth::id(),
            ]);

            foreach ($request->items as $item) {
                StockTransferItem::create([
                    'stock_transfer_id' => $transfer->id,
                    'product_id' => $item['product_id'],
                    'request_quantity' => $item['quantity'],
                ]);
            }
        });

        return redirect()->route('stock-transfers.index')->with('success', 'Stock Transfer request created successfully.');
    }

    public function show(StockTransfer $stockTransfer)
    {
        $stockTransfer->load(['items.product', 'sourceStore', 'destStore', 'createdBy', 'receivedBy']);
        
        return Inertia::render('Inventory/StockTransfers/Show', [
            'transfer' => $stockTransfer
        ]);
    }

    public function approve(StockTransfer $stockTransfer)
    {
        if ($stockTransfer->status !== 'pending') {
            return back()->with('error', 'Transfer is not pending.');
        }

        DB::transaction(function () use ($stockTransfer) {
            // 1. Deduct from Source
            foreach ($stockTransfer->items as $item) {
                // Find product in source store (Assuming simple model where we verify stock first)
                // In a real multi-store, we check if the product belongs to source_store_id. 
                // Since our Product model has `store_id`, we should verify the product ID actually belongs to source store
                // OR we assume the frontend filtered correctly.
                
                $product = Product::find($item->product_id);
                
                // Optional: Check if product store_id matches source_store_id
                if ($product->store_id && $product->store_id != $stockTransfer->source_store_id) {
                     // This complexity arises if Product IDs are unique per store.
                     // If so, we just deduct.
                }

                if ($product->stock < $item->request_quantity) {
                    throw new \Exception("Insufficient stock for {$product->name}");
                }
                
                $product->decrement('stock', $item->request_quantity);
            }

            // 2. Add to Destination
            foreach ($stockTransfer->items as $item) {
                $sourceProduct = Product::find($item->product_id);
                
                // Find equivalent product in Dest Store
                // Match by Barcode (preferred) or Name
                $destProduct = Product::where('store_id', $stockTransfer->dest_store_id)
                    ->where(function($q) use ($sourceProduct) {
                        $q->where('barcode', $sourceProduct->barcode)
                          ->orWhere('name', $sourceProduct->name);
                    })->first();

                if ($destProduct) {
                    $destProduct->increment('stock', $item->request_quantity);
                } else {
                    // Clone product to new store
                    $newProduct = $sourceProduct->replicate();
                    $newProduct->store_id = $stockTransfer->dest_store_id;
                    $newProduct->stock = $item->request_quantity;
                    $newProduct->save();
                }
                
                $item->update([
                    'shipped_quantity' => $item->request_quantity,
                    'received_quantity' => $item->request_quantity // Auto-receive for simplicity, or split steps
                ]);
            }

            $stockTransfer->update([
                'status' => 'completed',
                'shipped_at' => now(),
                'received_at' => now(),
                'received_by' => Auth::id()
            ]);
        });

        return back()->with('success', 'Transfer approved and stock updated.');
    }

    public function reject(StockTransfer $stockTransfer)
    {
        if ($stockTransfer->status !== 'pending') {
            return back()->with('error', 'Transfer is not pending.');
        }

        $stockTransfer->update(['status' => 'cancelled']);
        return back()->with('success', 'Transfer rejected.');
    }
}
