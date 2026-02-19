<?php

namespace App\Http\Controllers;

use App\Models\Product;
use App\Models\ProductBatch;
use App\Services\BatchService;
use Illuminate\Http\Request;

class BatchController extends Controller
{
    public function __construct(protected BatchService $batchService) {}

    public function index(Request $request)
    {
        $storeId = auth()->user()->store_id ?? 1;
        
        $products = Product::where('store_id', $storeId)->with(['batches' => function($q) {
            $q->where('current_quantity', '>', 0)->orderBy('expiry_date');
        }])->get();

        // Return Inertia response with products data for the "Add Batch" form
        return \Inertia\Inertia::render('Inventory/Batches/Index', [
            'products' => $products
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'product_id' => 'required|exists:products,id',
            'quantity' => 'required|integer|min:1',
            'cost_price' => 'required|numeric|min:0',
            'expiry_date' => 'nullable|date',
        ]);

        $storeId = auth()->user()->store_id ?? 1;

        $this->batchService->addBatch(
            $storeId,
            $request->product_id,
            $request->quantity,
            $request->cost_price,
            $request->expiry_date
        );

        // Also update main product stock count for quick access
        $product = Product::find($request->product_id);
        $product->increment('stock', $request->quantity);
        // Note: Weighted average cost could be updated here too if desired.

        return back()->with('success', 'Batch received successfully.');
    }

    /**
     * Display batches for a specific product.
     * Route: /products/{id}/batches
     */
    public function byProduct(Product $product)
    {
        $batches = $product->batches()
            ->orderByRaw('expiry_date IS NULL, expiry_date ASC')
            ->orderBy('received_at', 'desc')
            ->get();
            
        return \Inertia\Inertia::render('Inventory/ProductBatches', compact('product', 'batches'));
    }

    public function expiring(Request $request)
    {
        $days = $request->get('days', 30);
        $search = $request->get('search');
        $storeId = auth()->user()->store_id ?? 1;

        // Metrics (Base query for store)
        $totalBatches = ProductBatch::where('store_id', $storeId)->where('current_quantity', '>', 0)->count();
        $expiredCount = ProductBatch::where('store_id', $storeId)->where('current_quantity', '>', 0)->where('expiry_date', '<', now())->count();
        $nearExpiryCount = ProductBatch::where('store_id', $storeId)
            ->where('current_quantity', '>', 0)
            ->where('expiry_date', '>=', now())
            ->where('expiry_date', '<=', now()->addDays($days))
            ->count();

        // Main Query
        $query = ProductBatch::where('store_id', $storeId)
            ->where('current_quantity', '>', 0)
            ->where('expiry_date', '<=', now()->addDays($days))
            ->with('product');

        if ($search) {
            $query->where(function($q) use ($search) {
                $q->where('batch_number', 'like', "%{$search}%")
                  ->orWhereHas('product', function($pq) use ($search) {
                      $pq->where('name', 'like', "%{$search}%");
                  });
            });
        }

        $batches = $query->orderBy('expiry_date')->paginate(20)->withQueryString();

        return \Inertia\Inertia::render('Reports/Expiry', compact('batches', 'days', 'search', 'totalBatches', 'expiredCount', 'nearExpiryCount'));
    }
}
