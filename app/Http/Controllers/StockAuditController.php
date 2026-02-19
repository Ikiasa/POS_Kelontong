<?php

namespace App\Http\Controllers;

use App\Models\Product;
use App\Models\StockMovement;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class StockAuditController extends Controller
{
    public function index()
    {
        return \Inertia\Inertia::render('Inventory/StockAudit', [
            'products' => Product::all(['id', 'name', 'barcode', 'stock'])
        ]);
    }

    public function reconcile(Request $request)
    {
        $request->validate([
            'product_id' => 'required|exists:products,id',
            'physical_qty' => 'required|integer|min:0',
            'notes' => 'nullable|string'
        ]);

        return DB::transaction(function () use ($request) {
            $product = Product::findOrFail($request->product_id);
            $oldStock = $product->stock;
            $newStock = $request->physical_qty;
            $diff = $newStock - $oldStock;

            if ($diff === 0) {
                return response()->json(['success' => true, 'message' => 'Stock is already correct']);
            }

            $product->update(['stock' => $newStock]);

            StockMovement::create([
                'product_id' => $product->id,
                'type' => $diff > 0 ? 'adjustment_in' : 'adjustment_out',
                'quantity' => abs($diff),
                'reference' => 'Stock Audit Reconcile',
                'notes' => $request->notes ?? "Physical count: $newStock. Prev: $oldStock."
            ]);

            return response()->json([
                'success' => true, 
                'message' => 'Stock reconciled successfully',
                'new_stock' => $newStock
            ]);
        });
    }
}
