<?php

namespace App\Http\Controllers;

use App\Models\StockTransfer;
use App\Models\Store;
use App\Services\StockTransferService;
use Illuminate\Http\Request;
use Exception;

class StockTransferController extends Controller
{
    public function __construct(protected StockTransferService $service) {}

    public function index()
    {
        $transfers = StockTransfer::with(['sourceStore', 'destStore'])->latest()->get();
        $stores = Store::all();
        
        return view('stock_transfers.index', compact('transfers', 'stores'));
    }

    public function store(Request $request)
    {
        $request->validate([
            'source_store_id' => 'required|exists:stores,id',
            'dest_store_id' => 'required|exists:stores,id|different:source_store_id',
            'items' => 'required|array',
            'items.*.product_id' => 'required|exists:products,id',
            'items.*.quantity' => 'required|integer|min:1',
        ]);

        try {
            $this->service->createTransfer(
                $request->source_store_id,
                $request->dest_store_id,
                $request->items,
                $request->notes
            );
            return back()->with('success', 'Transfer request created.');
        } catch (Exception $e) {
            return back()->with('error', $e->getMessage());
        }
    }

    public function ship($id)
    {
        try {
            $this->service->shipTransfer($id);
            return back()->with('success', 'Transfer shipped.');
        } catch (Exception $e) {
            return back()->with('error', $e->getMessage());
        }
    }

    public function receive(Request $request, $id)
    {
        // For simplicity assuming full receipt or implicit logic for now
        // In real app, we'd accept an array of received quantities
        // Here assuming we receive strictly what was shipped for the demo button
        
        try {
            // Fetch transfer to get shipped quantities as defaults
            $transfer = StockTransfer::with('items')->findOrFail($id);
            $quantities = [];
            foreach ($transfer->items as $item) {
                $quantities[$item->id] = $item->shipped_quantity;
            }

            $this->service->receiveTransfer($id, $quantities);
            return back()->with('success', 'Transfer received.');
        } catch (Exception $e) {
            return back()->with('error', $e->getMessage());
        }
    }
}
