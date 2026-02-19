<?php

namespace App\Http\Controllers;

use App\Models\Category;
use App\Models\Customer;
use App\Models\Product;
use App\Models\Promotion;
use App\Services\PricingService;
use App\Services\SaleService;
use App\Services\PaymentService;
use Illuminate\Http\Request;
use Inertia\Inertia;

class PosController extends Controller
{
    public function __construct(
        protected PricingService $pricingService,
        protected SaleService $saleService,
        protected PaymentService $paymentService
    ) {}

    public function index()
    {
        $storeId = auth()->user()->store_id ?? 1;

        $customers = Customer::where('store_id', $storeId)->orWhereNull('store_id')->get();
        $categories = Category::all();
        
        $promotions = Promotion::where('is_active', true)
            ->where('start_date', '<=', now())
            ->where('end_date', '>=', now())
            ->where('store_id', $storeId)
            ->get();

        // Eager load priceTiers and category to prevent N+1 queries
    $products = Product::where('store_id', $storeId)
        ->with(['category', 'priceTiers']) // Eager load relationships
        ->get()
        ->map(function ($product) use ($storeId) {
            // Calculate prices in-memory using eager loaded relation
            $retailPrice = $product->priceTiers->first(fn($t) => 
                ($t->store_id === $storeId || $t->store_id === null) && $t->tier_name === 'retail'
            )?->price ?? $product->price;

            $wholesalePrice = $product->priceTiers->first(fn($t) => 
                ($t->store_id === $storeId || $t->store_id === null) && $t->tier_name === 'wholesale'
            )?->price ?? $product->price;

            $memberPrice = $product->priceTiers->first(fn($t) => 
                ($t->store_id === $storeId || $t->store_id === null) && $t->tier_name === 'member'
            )?->price ?? $product->price;

            $prices = [
                'base' => $product->price,
                'retail' => $retailPrice,
                'wholesale' => $wholesalePrice,
                'member' => $memberPrice,
            ];
            
            return [
                'id' => $product->id,
                'name' => $product->name,
                'price' => $prices['retail'],
                'stock' => $product->stock,
                'category_id' => $product->category_id,
                'barcode' => $product->barcode,
                'image' => $product->image,
                'prices' => $prices,
            ];
        });

    return \Inertia\Inertia::render('POS/Index', [
        'products' => $products,
        'categories' => $categories,
        'customers' => $customers,
        'promotions' => $promotions
    ]);
}

    public function store(Request $request)
    {
        $storeId = auth()->user()->store_id ?? 1;
        $userId = auth()->id();

        try {
            $transaction = $this->saleService->createSale($request->all(), $storeId, $userId);
            
            return response()->json([
                'success' => true,
                'invoice_number' => $transaction->invoice_number,
                'transaction_id' => $transaction->id
            ]);
        } catch (\Throwable $e) {
            \Log::error("POS Transaction Failed: " . $e->getMessage(), [
                'user_id' => $userId,
                'store_id' => $storeId,
                'trace' => $e->getTraceAsString(),
                'request_data' => $request->except(['image', 'base64']) // Exclude heavy data
            ]);

            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 422);
        }
    }

    public function generateQRIS(Request $request)
    {
        // For dynamic QRIS before transaction is saved (preview)
        // This is a simulation
        $amount = $request->input('amount');
        return response()->json([
            'payload' => "00020101021226300016ID.CO.QRIS.WWW011893600523000000010215" . str_pad($amount, 12, '0', STR_PAD_LEFT) . "5802ID5911KelontongKu6005Depok62070703A016304" . strtoupper(Str::random(4))
        ]);
    }
}
