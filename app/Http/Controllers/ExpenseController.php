<?php

namespace App\Http\Controllers;

use App\Models\Account;
use App\Models\JournalEntry;
use App\Models\JournalItem;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class ExpenseController extends Controller
{
    public function index()
    {
        $expenses = JournalEntry::with('items')
            ->whereHas('items', function ($q) {
                // Filter for entries that touch expense accounts
                $q->where('account_code', 'like', '6%'); // Typical Expense Code Prefix, adjust as needed or use Account type
            })
            ->latest('transaction_date')
            ->paginate(20);

        // Get Expense Accounts for dropdown
        $expenseAccounts = Account::where('type', 'expense')->where('is_active', true)->get();

        return Inertia::render('Expenses/Index', [
            'expenses' => $expenses,
            'accounts' => $expenseAccounts,
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'account_code' => 'required|exists:accounts,code',
            'amount' => 'required|numeric|min:1',
            'description' => 'required|string|max:255',
            'date' => 'required|date',
        ]);

        try {
            DB::beginTransaction();

            $storeId = auth()->user()->store_id ?? 1;
            $account = Account::where('code', $request->account_code)->first();

            // Create Journal Entry
            $entry = JournalEntry::create([
                'store_id' => $storeId,
                'user_id' => auth()->id(),
                'transaction_date' => $request->date,
                'description' => $request->description,
                'reference_number' => 'EXP-' . time(),
                'is_posted' => true,
                'posted_at' => now(),
            ]);

            // Debit Expense Account
            JournalItem::create([
                'journal_entry_id' => $entry->id,
                'account_code' => $account->code,
                'account_name' => $account->name,
                'debit' => $request->amount,
                'credit' => 0,
            ]);

            // Credit Cash (or Bank - for now hardcoded to Cash Drawer/Petty Cash)
            // Assuming '1000' is Cash/Kas or similar. Need to ensure this account exists.
            // For MVP, let's use a known Cash Account Code or configured one.
            $cashAccountCode = '11001'; // Example: Kas Toko
            $cashAccount = Account::where('code', $cashAccountCode)->first() ?? Account::first(); // Fallback

            JournalItem::create([
                'journal_entry_id' => $entry->id,
                'account_code' => $cashAccount->code,
                'account_name' => $cashAccount->name,
                'debit' => 0,
                'credit' => $request->amount,
            ]);

            DB::commit();

            return redirect()->back()->with('success', 'Pengeluaran berhasil dicatat.');

        } catch (\Exception $e) {
            DB::rollBack();
            return redirect()->back()->with('error', 'Gagal mencatat pengeluaran: ' . $e->getMessage());
        }
    }
}
