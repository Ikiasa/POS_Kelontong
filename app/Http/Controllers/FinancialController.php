<?php

namespace App\Http\Controllers;

use App\Services\BudgetService;
use App\Services\InstallmentService;
use Illuminate\Http\Request;
use Exception;

class FinancialController extends Controller
{
    public function __construct(
        protected InstallmentService $installmentService,
        protected BudgetService $budgetService
    ) {}

    public function index()
    {
        try {
            $storeId = 1; // Auth check needed
            
            $overdueInstallments = $this->installmentService->getOverdueInstallments($storeId);
            $agingReport = $this->installmentService->getAgingReport($storeId);
            $budgetStatus = $this->budgetService->getBudgetStatus($storeId);

            return \Inertia\Inertia::render('Financial/Index', [
                'overdueInstallments' => $overdueInstallments,
                'agingReport' => $agingReport,
                'budgetStatus' => $budgetStatus
            ]);
        } catch (\Throwable $e) {
            \Illuminate\Support\Facades\Log::error("Financial Index 500: " . $e->getMessage());
            return \Inertia\Inertia::render('Financial/Index', [
                'overdueInstallments' => [],
                'agingReport' => [],
                'budgetStatus' => [],
                'flash' => ['error' => 'Financial table sync in progress.']
            ]);
        }
    }

    public function reports(Request $request)
    {
        $startDate = $request->input('start_date', now()->startOfMonth()->format('Y-m-d'));
        $endDate = $request->input('end_date', now()->endOfMonth()->format('Y-m-d'));
        $activeTab = $request->input('tab', 'pl');

        $data = [];
        if ($activeTab === 'pl') {
            $data = $this->calculateProfitLoss($startDate, $endDate);
        } else {
            $data = $this->calculateBalanceSheet($endDate);
        }

        return \Inertia\Inertia::render('Financial/Reports', [
            'data' => $data,
            'filters' => [
                'start_date' => $startDate,
                'end_date' => $endDate,
                'tab' => $activeTab
            ]
        ]);
    }

    public function accounts()
    {
        try {
            $accounts = \App\Models\Account::orderBy('code')->get();
            return \Inertia\Inertia::render('Financial/Accounts', [
                'accounts' => $accounts
            ]);
        } catch (\Throwable $e) {
            return \Inertia\Inertia::render('Financial/Accounts', [
                'accounts' => [],
                'flash' => ['error' => 'Account schema sync required.']
            ]);
        }
    }

    public function ledger(Request $request)
    {
        $accountCode = $request->input('account_code');
        $startDate = $request->input('start_date', now()->startOfMonth()->format('Y-m-d'));
        $endDate = $request->input('end_date', now()->endOfMonth()->format('Y-m-d'));

        $query = \App\Models\JournalItem::with('entry')
            ->whereHas('entry', function ($q) use ($startDate, $endDate) {
                $q->whereBetween('transaction_date', [$startDate, $endDate]);
            });

        if ($accountCode) {
            $query->where('account_code', $accountCode);
        }

        $items = $query->latest()->paginate(20)->withQueryString();
        $accounts = \App\Models\Account::orderBy('code')->get();

        return \Inertia\Inertia::render('Financial/Ledger', [
            'items' => $items,
            'accounts' => $accounts,
            'filters' => [
                'account_code' => $accountCode,
                'start_date' => $startDate,
                'end_date' => $endDate
            ]
        ]);
    }

    private function calculateProfitLoss($start, $end)
    {
        $revenues = $this->getAccountBalances('revenue', $start, $end);
        $expenses = $this->getAccountBalances('expense', $start, $end);

        return [
            'revenues' => $revenues,
            'totalRevenue' => $revenues->sum('balance'),
            'expenses' => $expenses,
            'totalExpense' => $expenses->sum('balance'),
            'netProfit' => $revenues->sum('balance') - $expenses->sum('balance')
        ];
    }

    private function calculateBalanceSheet($end)
    {
        return [
            'assets' => $this->getAccountBalances('asset', null, $end),
            'liabilities' => $this->getAccountBalances('liability', null, $end),
            'equity' => $this->getAccountBalances('equity', null, $end),
        ];
    }

    private function getAccountBalances($type, $start, $end)
    {
        $accounts = \App\Models\Account::where('type', $type)->orderBy('code')->get();

        return $accounts->map(function ($account) use ($type, $start, $end) {
            $query = \App\Models\JournalItem::where('account_code', $account->code)
                ->whereHas('entry', function ($q) use ($start, $end) {
                    if ($start) {
                        $q->whereBetween('transaction_date', [$start, $end]);
                    } else {
                        $q->where('transaction_date', '<=', $end);
                    }
                });

            $debit = $query->sum('debit');
            $credit = $query->sum('credit');

            $balance = in_array($type, ['asset', 'expense']) ? ($debit - $credit) : ($credit - $debit);
            $account->balance = (float)$balance;
            return $account;
        })->filter(fn($a) => $a->balance != 0);
    }
}
