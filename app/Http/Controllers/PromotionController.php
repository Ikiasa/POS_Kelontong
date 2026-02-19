<?php

namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\Product;
use App\Models\Promotion;
use Illuminate\Http\Request;

class PromotionController extends Controller
{
    public function index()
    {
        $promotions = Promotion::with(['product', 'category'])->latest()->paginate(10);
        return view('promotions.index', compact('promotions'));
    }

    public function create()
    {
        $products = Product::select('id', 'name')->get();
        $categories = Category::select('id', 'name')->get();
        return view('promotions.create', compact('products', 'categories'));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'type' => 'required|in:percentage,fixed_amount',
            'value' => 'required|numeric|min:0',
            'start_date' => 'required|date',
            'end_date' => 'required|date|after:start_date',
            'product_id' => 'nullable|exists:products,id',
            'category_id' => 'nullable|exists:categories,id',
        ]);

        $validated['store_id'] = auth()->user()->store_id ?? 1;
        
        // Scope logic: ensure only one scope is selected
        if($request->product_id && $request->category_id) {
            return back()->withErrors(['scope' => 'Select either a Product or a Category, not both.']);
        }

        Promotion::create($validated);

        return redirect()->route('promotions.index')->with('success', 'Promotion created successfully.');
    }

    public function edit(Promotion $promotion)
    {
        $products = Product::select('id', 'name')->get();
        $categories = Category::select('id', 'name')->get();
        return view('promotions.edit', compact('promotion', 'products', 'categories'));
    }

    public function update(Request $request, Promotion $promotion)
    {
         $validated = $request->validate([
            'name' => 'required|string|max:255',
            'type' => 'required|in:percentage,fixed_amount',
            'value' => 'required|numeric|min:0',
            'start_date' => 'required|date',
            'end_date' => 'required|date|after:start_date',
            'product_id' => 'nullable|exists:products,id',
            'category_id' => 'nullable|exists:categories,id',
            'is_active' => 'boolean'
        ]);
        
        $promotion->update($validated);

        return redirect()->route('promotions.index')->with('success', 'Promotion updated.');
    }

    public function destroy(Promotion $promotion)
    {
        $promotion->delete();
        return redirect()->route('promotions.index')->with('success', 'Promotion deleted.');
    }
}
