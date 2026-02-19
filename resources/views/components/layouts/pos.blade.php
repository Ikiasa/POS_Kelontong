<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <title>{{ config('app.name', 'Toko Kelontong') }} - POS</title>

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.bunny.net">
    <link href="https://fonts.bunny.net/css?family=inter:400,500,600,700&display=swap" rel="stylesheet" />

    <!-- Scripts -->
    @vite(['resources/css/app.css', 'resources/js/app.js'])
    
    <!-- PWA -->
    <link rel="manifest" href="/manifest.json">
    <script>
        if ('serviceWorker' in navigator) {
            window.addEventListener('load', () => {
                navigator.serviceWorker.register('/sw.js');
            });
        }
    </script>

    <style>
        [x-cloak] { display: none !important; }
        
        /* Custom Scrollbar */
        .scrollbar-custom::-webkit-scrollbar {
            width: 6px;
            height: 6px;
        }
        .scrollbar-custom::-webkit-scrollbar-track {
            background: #1e293b;
            border-radius: 8px;
        }
        .scrollbar-custom::-webkit-scrollbar-thumb {
            background: #475569;
            border-radius: 8px;
        }
        .scrollbar-custom::-webkit-scrollbar-thumb:hover {
            background: #64748b;
        }
        
        /* Digital Font for Total */
        @font-face {
            font-family: 'Digital';
            src: url('https://fonts.cdnfonts.com/s/14883/DS-DIGI.woff') format('woff');
        }
        .font-digital {
            font-family: 'Digital', 'Inter', monospace;
            letter-spacing: 2px;
        }

        /* Smooth transitions */
        .transition-all {
            transition: all 0.2s ease;
        }

        /* Product card hover effect */
        .product-card {
            transition: transform 0.15s ease, box-shadow 0.15s ease;
        }
        .product-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px -10px rgba(0, 0, 0, 0.5);
        }

        /* Category button active state */
        .category-active {
            background: linear-gradient(135deg, #4f46e5 0%, #6366f1 100%);
            border-color: #4f46e5;
        }

        /* Number input spinner removal */
        input[type=number]::-webkit-inner-spin-button, 
        input[type=number]::-webkit-outer-spin-button { 
            -webkit-appearance: none; 
            margin: 0; 
        }
        input[type=number] {
            -moz-appearance: textfield;
        }
    </style>
</head>
<body class="font-sans antialiased bg-[#0f172a] h-screen overflow-hidden selection:bg-indigo-500/30 selection:text-white text-gray-100">
    
    <div class="h-full flex flex-col" id="app">
        <!-- Enhanced Top Navigation -->
        <header class="bg-[#1e293b]/50 backdrop-blur-md border-b border-slate-700/50 h-16 flex items-center justify-between px-6 shrink-0 z-20">
            <!-- Left Section -->
            <div class="flex items-center gap-4">
                <div class="flex items-center gap-3">
                    <!-- Logo/Brand -->
                    <div class="bg-indigo-600 text-white p-1.5 rounded-lg shadow-lg shadow-indigo-600/20">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M13 10V3L4 14h7v7l9-11h-7z" />
                        </svg>
                    </div>
                    <div>
                        <h1 class="text-lg font-bold text-white tracking-tight leading-none">
                            POS System
                        </h1>
                        <p class="text-[10px] text-slate-400 font-medium">Point of Sale</p>
                    </div>
                </div>
                
                <!-- Store Info Badge -->
                <div class="hidden lg:flex items-center gap-3 ml-4 pl-4 border-l border-slate-700/50">
                    <div class="flex items-center gap-2 text-xs font-medium">
                        <div class="w-1.5 h-1.5 bg-green-500 rounded-full shadow-[0_0_8px_rgba(34,197,94,0.5)]"></div>
                        <span class="text-green-400">Online</span>
                        <span class="text-slate-500 mx-1">|</span>
                        <span class="text-slate-400">Sync: 08.16</span>
                    </div>
                </div>
            </div>

            <!-- Right Section -->
            <div class="flex items-center gap-6">
                <!-- Clock -->
                <div class="hidden sm:block text-right">
                    <div class="text-lg font-bold text-white leading-none" x-data="{ time: new Date().toLocaleTimeString('id-ID', { hour: '2-digit', minute: '2-digit' }).replace('.', ':') }" 
                         x-init="setInterval(() => time = new Date().toLocaleTimeString('id-ID', { hour: '2-digit', minute: '2-digit' }).replace('.', ':'), 1000)" 
                         x-text="time">
                        00:00
                    </div>
                    <div class="text-[10px] text-slate-400 font-medium">{{ now()->format('l, d M') }}</div>
                </div>
                
                <!-- Cashier Info -->
                <div class="flex items-center gap-3 pl-6 border-l border-slate-700/50">
                    <div class="relative group cursor-pointer">
                        <div class="h-9 w-9 bg-slate-700 hover:bg-slate-600 rounded-full flex items-center justify-center text-white font-bold text-sm transition-colors border border-slate-600">
                            {{ substr(auth()->user()->name ?? 'K', 0, 1) }}
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="flex-1 flex overflow-hidden relative">
            {{ $slot }}
        </main>

        <!-- Bottom Status Bar -->
        <footer class="bg-slate-800/80 backdrop-blur-sm border-t border-slate-700 h-8 flex items-center justify-between px-6 text-xs text-slate-400 shrink-0">
            <div class="flex items-center gap-4">
                <span>© 2024 Toko Kelontong</span>
                <span class="w-1 h-1 bg-slate-600 rounded-full"></span>
                <span>Versi 1.0.0</span>
            </div>
            <div class="flex items-center gap-4">
                <span class="flex items-center gap-1">
                    <span class="w-2 h-2 bg-green-500 rounded-full"></span>
                    Database Terhubung
                </span>
                <span class="flex items-center gap-1">
                    <span class="w-2 h-2 bg-indigo-500 rounded-full"></span>
                    Mode: Online
                </span>
            </div>
        </footer>
    </div>
    
    <!-- Floating Issue Button -->
    <button class="fixed bottom-4 left-4 bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-full shadow-lg flex items-center gap-2 z-50 transition-all hover:scale-105">
        <span class="font-bold">N</span>
        <span class="text-sm font-medium">1 Issue</span>
        <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
    </button>

    <!-- Stack for modals/scripts -->
    @stack('modals')
    @stack('scripts')
</body>
</html>