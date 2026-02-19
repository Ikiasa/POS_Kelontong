<?php

namespace App\Http\Controllers;

use App\Models\PendingTransaction;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class PendingTransactionController extends Controller
{
    public function store(Request $request)
    {
        try {
            \Illuminate\Support\Facades\Log::info("Attempting to park transaction", [
                'user_id' => Auth::id(),
                'cart_size' => count($request->cart ?? []),
                'total' => $request->total
            ]);

            $pending = PendingTransaction::create([
                'store_id' => Auth::user()->store_id ?? 1,
                'user_id' => Auth::id(),
                'customer_id' => $request->customer_id,
                'cart_data' => $request->cart,
                'total' => $request->total,
                'status' => 'pending',
            ]);

            \Illuminate\Support\Facades\Log::info("Transaction parked successfully", ['id' => $pending->id]);

            return response()->json(['success' => true, 'id' => $pending->id]);
        } catch (\Throwable $e) {
            \Illuminate\Support\Facades\Log::error("Park Sale Failed: " . $e->getMessage(), [
                'request' => $request->all(),
                'trace' => $e->getTraceAsString()
            ]);
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function recall($id)
    {
        try {
            \Illuminate\Support\Facades\Log::info("Attempting to recall transaction: " . $id);
            $pending = PendingTransaction::findOrFail($id);
            
            \Illuminate\Support\Facades\Log::info("Found pending transaction", [
                'id' => $pending->id,
                'status' => $pending->status,
                'cart_items_count' => is_array($pending->cart_data) ? count($pending->cart_data) : 0
            ]);

            $pending->update(['status' => 'recalled']);
            
            return response()->json(['success' => true, 'data' => $pending]);
        } catch (\Throwable $e) {
            \Illuminate\Support\Facades\Log::error("Recall Failed for ID " . $id . ": " . $e->getMessage(), [
                'trace' => $e->getTraceAsString()
            ]);
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function destroy($id)
    {
        $pending = PendingTransaction::findOrFail($id);
        $pending->delete();
        
        return response()->json(['success' => true]);
    }
}
