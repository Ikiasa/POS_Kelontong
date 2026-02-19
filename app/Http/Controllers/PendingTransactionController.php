<?php

namespace App\Http\Controllers;

use App\Models\PendingTransaction;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class PendingTransactionController extends Controller
{
    public function store(Request $request)
    {
        $pending = PendingTransaction::create([
            'store_id' => Auth::user()->store_id ?? 1,
            'user_id' => Auth::id(),
            'customer_id' => $request->customer_id,
            'cart_data' => $request->cart,
            'total' => $request->total,
            'status' => 'pending',
        ]);

        return response()->json(['success' => true, 'id' => $pending->id]);
    }

    public function recall($id)
    {
        $pending = PendingTransaction::findOrFail($id);
        $pending->update(['status' => 'recalled']);
        
        return response()->json(['success' => true, 'data' => $pending]);
    }

    public function destroy($id)
    {
        $pending = PendingTransaction::findOrFail($id);
        $pending->delete();
        
        return response()->json(['success' => true]);
    }
}
