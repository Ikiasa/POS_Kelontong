<?php

namespace App\Http\Controllers;

use App\Models\Voucher;
use App\Models\Customer;
use App\Services\LoyaltyExchangeService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class VoucherController extends Controller
{
    public function __construct(
        protected LoyaltyExchangeService $exchangeService
    ) {}

    /**
     * Validate a voucher code.
     */
    public function validateCode(Request $request)
    {
        $request->validate(['code' => 'required|string']);

        $voucher = Voucher::where('code', strtoupper($request->code))
            ->where('is_active', true)
            ->where(function ($query) {
                $query->whereNull('expires_at')
                      ->orWhere('expires_at', '>', now());
            })
            ->first();

        if (!$voucher) {
            return response()->json(['valid' => false, 'message' => 'Voucher tidak valid atau sudah kadaluarsa.']);
        }

        return response()->json([
            'valid' => true,
            'voucher' => [
                'id' => $voucher->id,
                'code' => $voucher->code,
                'type' => $voucher->type,
                'value' => (float) $voucher->value
            ]
        ]);
    }

    /**
     * Exchange points for a voucher.
     */
    public function exchangePoints(Request $request)
    {
        $request->validate([
            'customer_id' => 'required|exists:customers,id',
            'points' => 'required|integer|min:1'
        ]);

        $customer = Customer::findOrFail($request->customer_id);

        try {
            $voucher = $this->exchangeService->exchangeForVoucher($customer, $request->points);
            
            return response()->json([
                'success' => true,
                'voucher' => $voucher,
                'message' => 'Penukaran poin berhasil! Kode Voucher: ' . $voucher->code
            ]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 422);
        }
    }
}
