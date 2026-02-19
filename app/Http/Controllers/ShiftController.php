<?php

namespace App\Http\Controllers;

use App\Models\Shift;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ShiftController extends Controller
{
    public function open(Request $request)
    {
        $request->validate([
            'opening_balance' => 'required|numeric|min:0',
            'validation_code' => 'nullable|string',
            'is_offline' => 'boolean'
        ]);

        $storeId = Auth::user()->store_id ?? 1;

        if ($request->is_offline) {
            $validationService = app(\App\Services\OfflineValidationService::class);
            if (!$validationService->verifyCode($storeId, $request->validation_code)) {
                return response()->json(['success' => false, 'message' => 'Kode Validasi Kantor Pusat tidak cocok.'], 422);
            }
        }

        $shift = Shift::create([
            'user_id' => Auth::id(),
            'store_id' => $storeId,
            'opened_at' => now(),
            'opening_balance' => $request->opening_balance,
            'status' => 'open',
            'metadata' => [
                'offline_open' => $request->is_offline ?? false
            ]
        ]);

        return response()->json(['success' => true, 'shift' => $shift]);
    }

    public function close(Request $request)
    {
        $request->validate([
            'cash_recorded' => 'required|numeric|min:0',
        ]);

        $shift = Shift::where('user_id', Auth::id())
            ->where('status', 'open')
            ->firstOrFail();

        // Calculate expected balance (Simulated: Opening + Sales)
        $salesTotal = $shift->transactions()->sum('grand_total');
        $expectedBalance = $shift->opening_balance + $salesTotal;

        $shift->update([
            'closed_at' => now(),
            'closing_balance' => $expectedBalance,
            'cash_recorded' => $request->cash_recorded,
            'status' => 'closed',
        ]);

        return response()->json(['success' => true]);
    }
}
