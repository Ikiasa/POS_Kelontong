<?php

namespace App\Http\Controllers;

use App\Models\Product;
use App\Models\StockOpname;
use App\Models\StockOpnameItem;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class StockOpnameController extends Controller
{
    public function index()
    {
        $opnames = StockOpname::latest()->paginate(10);
        return view('stock-opname.index', compact('opnames'));
    }

    public function create()
    {
        $products = Product::orderBy('name')->get();
        return view('stock-opname.create', compact('products'));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'opname_date' => 'required|date',
            'notes' => 'nullable|string',
            'items' => 'required|array|min:1',
            'items.*.product_id' => 'required|exists:products,id',
            'items.*.physical_stock' => 'required|integer|min:0',
        ]);

        $opname = StockOpname::create([
            'store_id' => auth()->user()->store_id ?? 1,
            'user_id' => auth()->id(),
            'reference_number' => 'OPN-' . strtoupper(Str::random(8)),
            'opname_date' => $validated['opname_date'],
            'notes' => $validated['notes'],
            'status' => 'draft',
        ]);

        foreach ($validated['items'] as $item) {
            $product = Product::find($item['product_id']);
            
            StockOpnameItem::create([
                'stock_opname_id' => $opname->id,
                'product_id' => $product->id,
                'system_stock' => $product->stock,
                'physical_stock' => $item['physical_stock'],
                'difference' => $item['physical_stock'] - $product->stock,
            ]);
        }

        return redirect()->route('stock-opname.show', $opname)->with('success', 'Stock Opname draft created.');
    }

    public function show(StockOpname $stockOpname)
    {
        $stockOpname->load('items.product');
        return view('stock-opname.show', compact('stockOpname'));
    }

    public function adjust(StockOpname $stockOpname)
    {
        if ($stockOpname->status !== 'draft') {
            return back()->with('error', 'This opname is already processed.');
        }

        foreach ($stockOpname->items as $item) {
            $product = $item->product;
            $product->stock = $item->physical_stock;
            $product->save();
        }

        $stockOpname->update(['status' => 'completed']);

        return redirect()->route('stock-opname.index')->with('success', 'Inventory Adjusted successfully!');
    }
}
