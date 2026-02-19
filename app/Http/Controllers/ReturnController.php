<?php

namespace App\Http\Controllers;

use App\Services\ReturnService;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Exception;

class ReturnController extends Controller
{
    public function __construct(
        protected ReturnService $returnService
    ) {}

    /**
     * Show the return processing page.
     */
    public function create(Request $request)
    {
        // Typically we would search for a transaction first
        $transactionId = $request->input('transaction_id');
        $transaction = null;

        if ($transactionId) {
            $transaction = \App\Models\Transaction::with(['items.product', 'customer'])
                ->where('id', $transactionId)
                ->where('store_id', auth()->user()->store_id)
                ->first();
        }

        return Inertia::render('Returns/Create', [
            'transaction' => $transaction,
        ]);
    }

    /**
     * Process the return request.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'transaction_id' => 'required|uuid|exists:transactions,id',
            'items' => 'required|array|min:1',
            'items.*.product_id' => 'required|exists:products,id',
            'items.*.quantity' => 'required|integer|min:1',
            'refund_method' => 'required|string|in:cash,qr,store_credit',
            'reason' => 'nullable|string'
        ]);

        try {
            $returnTx = $this->returnService->processReturn(
                $validated,
                auth()->user()->store_id,
                auth()->id()
            );

            return redirect()->back()->with('success', "Return processed successfully. Refund Total: " . number_format($returnTx->total_refunded, 2));
        } catch (Exception $e) {
            return redirect()->back()->withErrors(['error' => $e->getMessage()]);
        }
    }
}
