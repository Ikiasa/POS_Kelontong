<?php

namespace App\Http\Controllers;

use App\Services\CashDrawerService;
use Illuminate\Http\Request;
use Exception;

class CashDrawerController extends Controller
{
    public function __construct(protected CashDrawerService $service) {}

    public function index(Request $request)
    {
        $storeId = auth()->user()->store_id ?? 1;
        
        $current = $this->service->getCurrentDrawer($storeId);
        
        if (!$current) {
            return view('cash-drawer.start');
        }

        $current->expected_balance = $this->service->getExpectedBalance($current);
        
        return view('cash-drawer.close', [
            'current' => $current
        ]);

        $history = \App\Models\CashDrawer::where('store_id', $storeId)
            ->where('user_id', auth()->id())
            ->whereNotNull('closed_at')
            ->with('user')
            ->latest()
            ->paginate(10);

        return \Inertia\Inertia::render('CashDrawer/Index', [
            'current' => $current,
            'history' => $history,
            'storeName' => auth()->user()->store->name ?? 'Main Store'
        ]);
    }

    public function store(Request $request) // Open Drawer
    {
        $request->validate(['opening_balance' => 'required|numeric|min:0']);
        $storeId = auth()->user()->store_id ?? 1;

        try {
            $this->service->openDrawer($storeId, $request->opening_balance, $request->notes);
            return redirect()->route('pos')->with('success', 'Drawer opened successfully.');
        } catch (Exception $e) {
            return back()->withErrors(['error' => $e->getMessage()]);
        }
    }

    public function update(Request $request, $id) // Close Drawer
    {
        $request->validate(['closing_balance' => 'required|numeric|min:0']);

        try {
            $drawer = $this->service->closeDrawer($id, $request->closing_balance, $request->notes);
            
            // If AJAX request, return JSON summary
            if ($request->wantsJson() || $request->ajax()) {
                // Get transactions for this drawer session
                $transactions = \App\Models\Transaction::where('cash_drawer_id', $id)->get();
                $totalTransactions = $transactions->count();
                $cashSales = $transactions->where('payment_method', 'cash')->sum('total_amount');
                $nonCashSales = $transactions->whereIn('payment_method', ['card', 'qris', 'bank_transfer'])->sum('total_amount');
                $totalSales = $transactions->sum('total_amount');
                
                return response()->json([
                    'success' => true,
                    'summary' => [
                        'opening_cash' => $drawer->opening_balance,
                        'total_sales' => $totalSales,
                        'cash_sales' => $cashSales,
                        'non_cash_sales' => $nonCashSales,
                        'expected_cash' => $drawer->opening_balance + $cashSales,
                        'closing_cash' => $drawer->closing_balance,
                        'difference' => $drawer->variance,
                        'total_transactions' => $totalTransactions,
                    ]
                ]);
            }
            
            return redirect()->route('dashboard')->with('success', 
                "Drawer closed. Variance: " . number_format($drawer->variance, 2)
            );
        } catch (Exception $e) {
            if ($request->wantsJson() || $request->ajax()) {
                return response()->json([
                    'success' => false,
                    'message' => $e->getMessage()
                ], 400);
            }
            return back()->withErrors(['error' => $e->getMessage()]);
        }
    }
}
