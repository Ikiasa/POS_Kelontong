<?php

use Illuminate\Support\Facades\Route;

// POS (Cashier & Up)
Route::middleware(['auth'])->group(function () {
    Route::get('/pos', [\App\Http\Controllers\PosController::class, 'index'])->name('pos');
    Route::post('/sales', [\App\Http\Controllers\PosController::class, 'store'])->name('pos.store');
    
    // Shift Management
    Route::post('/shifts/open', [\App\Http\Controllers\ShiftController::class, 'open'])->name('shifts.open');
    Route::post('/shifts/close', [\App\Http\Controllers\ShiftController::class, 'close'])->name('shifts.close');
    
    // Pending Transactions
    Route::post('/pending-transactions', [\App\Http\Controllers\PendingTransactionController::class, 'store'])->name('pending.store');
    Route::get('/pending-transactions/{id}/recall', [\App\Http\Controllers\PendingTransactionController::class, 'recall'])->name('pending.recall');
    Route::delete('/pending-transactions/{id}', [\App\Http\Controllers\PendingTransactionController::class, 'destroy'])->name('pending.destroy');
});

Route::get('/', function () {
    return Inertia\Inertia::render('Welcome', [
        'canLogin' => Route::has('login'),
        'canRegister' => Route::has('register'),
    ]);
});

// Dashboard (Manager & Owner & Admin)
Route::middleware(['auth', 'role:manager,owner,admin'])->group(function () {
    Route::get('/dashboard', [\App\Http\Controllers\DashboardController::class, 'index'])->name('dashboard');
    Route::get('/analytics', [\App\Http\Controllers\AnalyticsController::class, 'index'])->name('analytics.index');
    Route::get('/assistant', function () { return Inertia\Inertia::render('Assistant/Index'); })->name('assistant.index');
    Route::get('/reports/profit-loss', function () { return view('reports.profit-loss'); })->name('reports.profit-loss');
    
    // Feature 4: Stock Audit
    Route::get('/inventory/audit', [\App\Http\Controllers\StockAuditController::class, 'index'])->name('inventory.audit.index');
    Route::post('/inventory/audit/reconcile', [\App\Http\Controllers\StockAuditController::class, 'reconcile'])->name('inventory.audit.reconcile');
    
    // Live Dashboard Metrics
    Route::get('/api/dashboard/live', [\App\Http\Controllers\DashboardController::class, 'getLiveMetrics'])->name('dashboard.live');
});

// Admin & Finance (Owner Only)
Route::middleware(['auth', 'role:owner'])->group(function () {
    Route::get('/financial', [\App\Http\Controllers\FinancialController::class, 'index'])->name('financial.index');
    Route::get('/financial/reports', [\App\Http\Controllers\FinancialController::class, 'reports'])->name('financial.reports');
    Route::get('/financial/accounts', [\App\Http\Controllers\FinancialController::class, 'accounts'])->name('financial.accounts');
    Route::get('/financial/ledger', [\App\Http\Controllers\FinancialController::class, 'ledger'])->name('financial.ledger');
    
    // Admin
    Route::get('/admin/users', [\App\Http\Controllers\Admin\UserController::class, 'index'])->name('admin.users.index');
    Route::post('/admin/users', [\App\Http\Controllers\Admin\UserController::class, 'store'])->name('admin.users.store');
    Route::put('/admin/users/{user}', [\App\Http\Controllers\Admin\UserController::class, 'update'])->name('admin.users.update');
    Route::delete('/admin/users/{user}', [\App\Http\Controllers\Admin\UserController::class, 'destroy'])->name('admin.users.destroy');
    
    Route::get('/admin/stores', [\App\Http\Controllers\Admin\StoreController::class, 'index'])->name('admin.stores.index');
    Route::get('/admin/stores/{id}/offline-code', [\App\Http\Controllers\Admin\StoreController::class, 'generateCode'])->name('admin.stores.offline-code');
    Route::get('/admin/suppliers', [\App\Http\Controllers\Admin\SupplierController::class, 'index'])->name('admin.suppliers.index');
    Route::post('/admin/suppliers', [\App\Http\Controllers\Admin\SupplierController::class, 'store'])->name('admin.suppliers.store');
    Route::put('/admin/suppliers/{supplier}', [\App\Http\Controllers\Admin\SupplierController::class, 'update'])->name('admin.suppliers.update');
    Route::delete('/admin/suppliers/{supplier}', [\App\Http\Controllers\Admin\SupplierController::class, 'destroy'])->name('admin.suppliers.destroy');
    Route::get('/audit', [\App\Http\Controllers\AuditController::class, 'index'])->name('audit.index');
    Route::get('/backups', [\App\Http\Controllers\BackupController::class, 'index'])->name('backups.index');
});

// Operational Routes (Manager & Owner, Cashier limited)
Route::middleware(['auth'])->group(function () {
    Route::resource('products', \App\Http\Controllers\ProductController::class);
    Route::resource('customers', \App\Http\Controllers\CustomerController::class);
    Route::get('/cash-drawer', [\App\Http\Controllers\CashDrawerController::class, 'index'])->name('cash-drawer.index');
    Route::post('/cash-drawer', [\App\Http\Controllers\CashDrawerController::class, 'store'])->name('cash-drawer.open');
    Route::put('/cash-drawer/{id}', [\App\Http\Controllers\CashDrawerController::class, 'update'])->name('cash-drawer.close');
    // Purchase Orders (Vue Migration)
    Route::get('/purchase-orders', [\App\Http\Controllers\Inventory\PurchaseOrderController::class, 'index'])->name('purchase-orders.index');
    Route::get('/purchase-orders/create', [\App\Http\Controllers\Inventory\PurchaseOrderController::class, 'create'])->name('purchase-orders.create');
    Route::post('/purchase-orders', [\App\Http\Controllers\Inventory\PurchaseOrderController::class, 'store'])->name('purchase-orders.store');
    Route::get('/purchase-orders/{purchase_order}/edit', [\App\Http\Controllers\Inventory\PurchaseOrderController::class, 'edit'])->name('purchase-orders.edit');
    Route::put('/purchase-orders/{purchase_order}', [\App\Http\Controllers\Inventory\PurchaseOrderController::class, 'update'])->name('purchase-orders.update');
    Route::get('/api/purchase-orders/search-products', [\App\Http\Controllers\Inventory\PurchaseOrderController::class, 'searchProducts'])->name('purchase-orders.search-products');

    // Stubs for missing routes (Legacy)
    // Inventory & Reports (Vue Migration)
    // Inventory & Batch Management (Blade)
    Route::get('/products/{product}/batches', [\App\Http\Controllers\BatchController::class, 'byProduct'])->name('products.batches.index');
    Route::post('/batches', [\App\Http\Controllers\BatchController::class, 'store'])->name('batches.store');
    Route::get('/reports/expiry', [\App\Http\Controllers\BatchController::class, 'expiring'])->name('reports.expiry');
    
    // Redirect legacy route
    Route::redirect('/batches/expiring', '/reports/expiry');

Route::middleware(['auth'])->group(function () {
    Route::get('/analytics', [App\Http\Controllers\ReportsController::class, 'index'])->name('analytics.index');
    Route::get('/analytics/data', [App\Http\Controllers\ReportsController::class, 'data'])->name('analytics.data');
});

    // Batches (Updated to use Controller)
    Route::get('/batches', [\App\Http\Controllers\BatchController::class, 'index'])->name('batches.index');
    
    // Stock Transfers & Inventory Management
    Route::resource('stock-transfers', \App\Http\Controllers\Inventory\StockTransferController::class);
    Route::put('/stock-transfers/{stock_transfer}/approve', [\App\Http\Controllers\Inventory\StockTransferController::class, 'approve'])->name('stock-transfers.approve');
    Route::put('/stock-transfers/{stock_transfer}/reject', [\App\Http\Controllers\Inventory\StockTransferController::class, 'reject'])->name('stock-transfers.reject');
    
    Route::get('/forecast', [\App\Http\Controllers\ForecastController::class, 'index'])->name('forecast.index');

    // Expense Tracking
    Route::get('/expenses', [\App\Http\Controllers\ExpenseController::class, 'index'])->name('expenses.index');
    Route::post('/expenses', [\App\Http\Controllers\ExpenseController::class, 'store'])->name('expenses.store');

    // ... other operational routes can be refined further
});

// Vue Migration Test (Public) - Removed vue-pos, kept vue-dashboard for ref
Route::get('/vue-layout', function () {
    return Inertia\Inertia::render('Dashboard', [
        'stats' => ['sales' => 1000]
    ]);
})->name('vue.dashboard');

// OLD vue-pos REMOVED

// Auth Routes (Temporary for Migration)
Route::middleware('guest')->group(function () {
    Route::get('login', function () {
        return Inertia\Inertia::render('Auth/Login');
    })->name('login');

    Route::post('login', function (\Illuminate\Http\Request $request) {
        $credentials = $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required'],
        ]);

        if (Illuminate\Support\Facades\Auth::attempt($credentials)) {
            $request->session()->regenerate();
            return redirect()->intended('dashboard');
        }

        return back()->withErrors([
            'email' => 'The provided credentials do not match our records.',
        ])->onlyInput('email');
    });
    // Returns
    Route::get('/returns/create', [\App\Http\Controllers\ReturnController::class, 'create'])->name('returns.create');
    Route::post('/returns', [\App\Http\Controllers\ReturnController::class, 'store'])->name('returns.store');

    // Vouchers & Loyalty
    Route::post('/api/vouchers/validate', [\App\Http\Controllers\VoucherController::class, 'validateCode'])->name('vouchers.validate');
    Route::post('/api/vouchers/exchange', [\App\Http\Controllers\VoucherController::class, 'exchangePoints'])->name('vouchers.exchange');
});

Route::post('logout', function (\Illuminate\Http\Request $request) {
    Illuminate\Support\Facades\Auth::logout();
    $request->session()->invalidate();
    $request->session()->regenerateToken();
    return redirect('/');
})->name('logout')->middleware('auth');
