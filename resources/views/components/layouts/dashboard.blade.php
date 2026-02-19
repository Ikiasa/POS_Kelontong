<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <title>{{ config('app.name', 'Laravel') }} - Dashboard</title>

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.bunny.net">
    <link href="https://fonts.bunny.net/css?family=figtree:400,500,600,700&display=swap" rel="stylesheet" />

    <!-- Scripts -->
    @vite(['resources/css/app.css'])
    
    <!-- Alpine.js (Loaded via Livewire or App) -->
    <!-- <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script> -->
    
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="font-sans antialiased bg-gray-100 text-gray-900">
    <div class="min-h-screen flex" x-data="{ sidebarOpen: false }">
        
        <!-- Sidebar -->
        <aside class="bg-gray-900 w-64 min-h-screen flex-shrink-0 hidden md:flex flex-col text-white transition-all duration-300">
            <div class="h-16 flex items-center justify-center border-b border-gray-800 bg-gray-900/50">
                <h1 class="text-xl font-bold tracking-wider">POS ADMIN</h1>
            </div>
            
            <nav class="flex-1 px-2 py-4 space-y-1">
                <a href="{{ route('dashboard') }}" class="group flex items-center px-3 py-2 text-sm font-medium rounded-md {{ request()->routeIs('dashboard') ? 'bg-gray-800 text-white' : 'text-gray-300 hover:bg-gray-800 hover:text-white' }}">
                    <svg class="mr-3 h-6 w-6 text-indigo-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z" />
                    </svg>
                    Dashboard
                </a>
                
                <a href="/pos" target="_blank" class="group flex items-center px-3 py-2 text-sm font-medium rounded-md text-gray-300 hover:bg-gray-800 hover:text-white transition-colors">
                    <svg class="mr-3 h-6 w-6 text-gray-400 group-hover:text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 7h6m0 10v-3m-3 3h.01M9 17h.01M9 14h.01M12 14h.01M15 11h.01M12 11h.01M9 11h.01M7 21h10a2 2 0 002-2V5a2 2 0 00-2-2H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                    </svg>
                    Open POS
                </a>

                <div class="pt-4 pb-2">
                    <p class="px-3 text-xs font-semibold text-gray-400 uppercase tracking-wider">Operations</p>
                </div>
                
                <a href="{{ route('products.index') }}" class="group flex items-center px-3 py-2 text-sm font-medium rounded-md {{ request()->routeIs('products.*') ? 'bg-gray-800 text-white' : 'text-gray-300 hover:bg-gray-800 hover:text-white' }}">
                    <span class="mr-3 text-lg">🏷️</span> Products
                </a>
                <a href="{{ route('reports.expiry') }}" class="group flex items-center px-3 py-2 text-sm font-medium rounded-md {{ request()->routeIs('reports.expiry') ? 'bg-gray-800 text-white' : 'text-gray-300 hover:bg-gray-800 hover:text-white' }}">
                    <span class="mr-3 text-lg">⚠️</span> Expiry Report
                </a>
                <a href="{{ route('batches.index') }}" class="group flex items-center px-3 py-2 text-sm font-medium rounded-md {{ request()->routeIs('batches.index') ? 'bg-gray-800 text-white' : 'text-gray-300 hover:bg-gray-800 hover:text-white' }}">
                    <span class="mr-3 text-lg">📦</span> Inventory & Batches
                </a>
                <a href="{{ route('stock-transfers.index') }}" class="group flex items-center px-3 py-2 text-sm font-medium rounded-md {{ request()->routeIs('stock-transfers.*') ? 'bg-gray-800 text-white' : 'text-gray-300 hover:bg-gray-800 hover:text-white' }}">
                    <span class="mr-3 text-lg">🚚</span> Stock Transfers
                </a>
                
                <div class="pt-4 pb-2">
                    <p class="px-3 text-xs font-semibold text-gray-400 uppercase tracking-wider">Procurement</p>
                </div>
                <a href="{{ route('admin.suppliers.index') }}" class="group flex items-center px-3 py-2 text-sm font-medium rounded-md {{ request()->routeIs('admin.suppliers.*') ? 'bg-gray-800 text-white' : 'text-gray-300 hover:bg-gray-800 hover:text-white' }}">
                    <span class="mr-3 text-lg">🏭</span> Suppliers
                </a>
                <a href="{{ route('purchase-orders.index') }}" class="group flex items-center px-3 py-2 text-sm font-medium rounded-md {{ request()->routeIs('purchase-orders.*') ? 'bg-gray-800 text-white' : 'text-gray-300 hover:bg-gray-800 hover:text-white' }}">
                    <span class="mr-3 text-lg">🛒</span> Purchase Orders
                </a>
                <a href="{{ route('customers.index') }}" class="group flex items-center px-3 py-2 text-sm font-medium rounded-md {{ request()->routeIs('customers.*') ? 'bg-gray-800 text-white' : 'text-gray-300 hover:bg-gray-800 hover:text-white' }}">
                    <span class="mr-3 text-lg">👥</span> Customers & Loyalty
                </a>
                <a href="{{ route('cash-drawer.index') }}" class="group flex items-center px-3 py-2 text-sm font-medium rounded-md {{ request()->routeIs('cash-drawer.*') ? 'bg-gray-800 text-white' : 'text-gray-300 hover:bg-gray-800 hover:text-white' }}">
                    <span class="mr-3 text-lg">💰</span> Cash Drawer
                </a>

                <div class="pt-4 pb-2">
                    <p class="px-3 text-xs font-semibold text-gray-400 uppercase tracking-wider">Manager Insights</p>
                </div>

                <a href="{{ route('financial.index') }}" class="group flex items-center px-3 py-2 text-sm font-medium rounded-md {{ request()->routeIs('financial.index') ? 'bg-gray-800 text-white' : 'text-gray-300 hover:bg-gray-800 hover:text-white' }}">
                    <span class="mr-3 text-lg">📊</span> Financials
                </a>
                <a href="{{ route('financial.accounts') }}" class="group flex items-center px-3 py-2 text-sm font-medium rounded-md {{ request()->routeIs('financial.accounts') ? 'bg-gray-800 text-white' : 'text-gray-300 hover:bg-gray-800 hover:text-white' }}">
                    <span class="mr-3 text-lg">📒</span> Chart of Accounts
                </a>
                <a href="{{ route('financial.ledger') }}" class="group flex items-center px-3 py-2 text-sm font-medium rounded-md {{ request()->routeIs('financial.ledger') ? 'bg-gray-800 text-white' : 'text-gray-300 hover:bg-gray-800 hover:text-white' }}">
                    <span class="mr-3 text-lg">📓</span> General Ledger
                </a>
                <a href="{{ route('financial.reports') }}" class="group flex items-center px-3 py-2 text-sm font-medium rounded-md {{ request()->routeIs('financial.reports') ? 'bg-gray-800 text-white' : 'text-gray-300 hover:bg-gray-800 hover:text-white' }}">
                    <span class="mr-3 text-lg">📑</span> P&L / Balance Sheet
                </a>
                <a href="{{ route('analytics.index') }}" class="group flex items-center px-3 py-2 text-sm font-medium rounded-md {{ request()->routeIs('analytics.*') ? 'bg-gray-800 text-white' : 'text-gray-300 hover:bg-gray-800 hover:text-white' }}">
                    <span class="mr-3 text-lg">📈</span> Analytics
                </a>
                <a href="{{ route('forecast.index') }}" class="group flex items-center px-3 py-2 text-sm font-medium rounded-md {{ request()->routeIs('forecast.*') ? 'bg-gray-800 text-white' : 'text-gray-300 hover:bg-gray-800 hover:text-white' }}">
                    <span class="mr-3 text-lg">🔮</span> AI Forecast
                </a>
                @if(auth()->user()->isOwner())
                <div class="pt-4 pb-2">
                    <p class="px-3 text-xs font-semibold text-gray-400 uppercase tracking-wider">Admin Zone</p>
                </div>

                <a href="{{ route('admin.users.index') }}" class="group flex items-center px-3 py-2 text-sm font-medium rounded-md {{ request()->routeIs('admin.users.*') ? 'bg-gray-800 text-white' : 'text-gray-300 hover:bg-gray-800 hover:text-white' }}">
                    <span class="mr-3 text-lg">🔑</span> User Management
                </a>
                <a href="{{ route('audit.index') }}" class="group flex items-center px-3 py-2 text-sm font-medium rounded-md {{ request()->routeIs('audit.*') ? 'bg-gray-800 text-white' : 'text-gray-300 hover:bg-gray-800 hover:text-white' }}">
                    <span class="mr-3 text-lg">🛡️</span> Security & Audit
                </a>
                <a href="{{ route('backups.index') }}" class="group flex items-center px-3 py-2 text-sm font-medium rounded-md {{ request()->routeIs('backups.*') ? 'bg-gray-800 text-white' : 'text-gray-300 hover:bg-gray-800 hover:text-white' }}">
                    <span class="mr-3 text-lg">💾</span> Backups & Health
                </a>
                @endif
            </nav>
            
            <div class="p-4 border-t border-gray-800">
                <div class="flex items-center">
                    <div class="h-8 w-8 rounded-full bg-indigo-500 flex items-center justify-center font-bold text-white">
                        {{ substr(auth()->user()->name ?? 'O', 0, 1) }}
                    </div>
                    <div class="ml-3">
                        <p class="text-sm font-medium text-white">{{ auth()->user()->name ?? 'Owner' }}</p>
                        <p class="text-xs text-gray-400">View Profile</p>
                    </div>
                </div>
            </div>
        </aside>

        <!-- Mobile Sidebar (Off-canvas) -->
        <!-- ... (Omitting full mobile impl for brevity, assuming desktop first per req) ... -->

        <!-- Main Content -->
        <main class="flex-1 flex flex-col min-w-0 overflow-hidden">
            <!-- Top Header -->
            <header class="bg-white border-b border-gray-200 h-16 flex items-center justify-between px-6 shadow-sm z-10">
                <div class="flex items-center gap-4">
                    <button class="md:hidden text-gray-500 hover:text-gray-700">
                        <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                        </svg>
                    </button>
                    <!-- Store Switcher -->
                    @php
                        $stores = [
                            ['id' => 1, 'name' => 'Main Store'],
                            ['id' => 2, 'name' => 'Branch B'],
                            ['id' => 3, 'name' => 'Outlet C'],
                        ];
                    @endphp
                    <x-store-switcher :stores="$stores" />
                </div>
                
                <div class="flex items-center gap-4">
                    <!-- Connectivity Status -->
                    <div class="flex items-center gap-2 px-3 py-1 bg-gray-50 rounded-full text-xs font-bold" x-data="{ online: navigator.onLine }" @online.window="online = true" @offline.window="online = false">
                        <span class="w-2 h-2 rounded-full" :class="online ? 'bg-green-500 shadow-[0_0_8px_rgba(34,197,94,0.6)]' : 'bg-red-500'"></span>
                        <span :class="online ? 'text-green-700' : 'text-red-700'" x-text="online ? 'ONLINE' : 'OFFLINE'">ONLINE</span>
                    </div>

                    <!-- Date Range Picker Mockup -->
                    <div class="hidden sm:flex items-center bg-gray-50 border border-gray-200 rounded-md px-3 py-1.5 text-sm text-gray-600">
                        <svg class="h-4 w-4 mr-2 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                        </svg>
                        <span>Today: {{ date('M d, Y') }}</span>
                    </div>
                </div>
            </header>

            <!-- Content Body -->
            <div class="flex-1 overflow-y-auto bg-gray-50 p-6 md:p-8">
                {{ $slot }}
            </div>
        </main>
    </div>
    
    @stack('scripts')
</body>
</html>
