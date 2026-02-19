<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Start Session - POS System</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 font-sans antialiased">
    <div class="min-h-screen flex items-center justify-center p-4">
        
        <!-- Centered Card -->
        <div class="w-full max-w-md bg-white rounded-xl shadow-lg border border-gray-100 overflow-hidden relative">
            
            <!-- Decorative Top Bar -->
            <div class="h-2 bg-indigo-600 w-full absolute top-0 left-0"></div>

            <div class="p-8">
                <!-- Header -->
                <div class="text-center mb-8">
                    <div class="w-16 h-16 bg-indigo-50 rounded-full flex items-center justify-center mx-auto mb-4 text-indigo-600">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-8 h-8">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 18.75a60.07 60.07 0 0 1 15.797 2.101c.727.198 1.453-.342 1.453-1.096V18.75M3.75 4.5v.75A.75.75 0 0 1 3 6h-.75m0 0v-.375c0-.621.504-1.125 1.125-1.125H20.25M2.25 6v9m18-10.5v.75c0 .414.336.75.75.75h.75m-1.5-1.5h.375c.621 0 1.125.504 1.125 1.125v9.75c0 .621-.504 1.125-1.125 1.125h-.375m1.5-1.5H21a.75.75 0 0 0-.75.75v.75m0 0H3.75m0 0h-.375a1.125 1.125 0 0 1-1.125-1.125V15m1.5 1.5v-.75A.75.75 0 0 0 3 15h-.75M15 10.5a3 3 0 1 1-6 0 3 3 0 0 1 6 0Zm3 0h.008v.008H18V10.5Zm-12 0h.008v.008H6V10.5Z" />
                        </svg>
                    </div>
                    <h1 class="text-2xl font-bold text-gray-900 tracking-tight">Start New Session</h1>
                    <p class="text-gray-500 mt-2 text-sm">Open the cash drawer to begin POS operations</p>
                </div>

                <!-- Form -->
                <form action="{{ route('cash-drawer.open') }}" method="POST" class="space-y-6">
                    @csrf
                    
                    <div class="space-y-2">
                        <label for="opening_balance" class="block text-sm font-medium text-gray-700">Opening Cash Amount</label>
                        <div class="relative rounded-lg shadow-sm">
                            <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4">
                                <span class="text-gray-500 sm:text-lg font-bold">Rp</span>
                            </div>
                            <input 
                                type="number" 
                                name="opening_balance" 
                                id="opening_balance" 
                                class="block w-full rounded-xl border-gray-300 pl-12 py-3 pr-4 text-gray-900 placeholder-gray-300 focus:border-indigo-500 focus:ring-indigo-500 sm:text-lg font-semibold transition-shadow shadow-sm" 
                                placeholder="0" 
                                required
                                autofocus
                                value="0"
                            >
                        </div>
                        @error('opening_balance')
                            <p class="text-red-600 text-sm mt-1">{{ $message }}</p>
                        @enderror
                    </div>

                    <button 
                        type="submit" 
                        class="w-full flex justify-center items-center gap-2 py-3.5 px-4 border border-transparent rounded-xl shadow-sm text-sm font-bold text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-all active:scale-[0.98]"
                    >
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3" />
                        </svg>
                        Start Session
                    </button>
                </form>
            </div>
            
            <!-- Footer Info -->
            <div class="bg-gray-50 px-8 py-4 border-t border-gray-100 flex justify-between items-center text-xs text-gray-500">
                <span>{{ now()->format('l, d M Y') }}</span>
                <span>{{ auth()->user()->name }}</span>
            </div>
        </div>
    </div>
</body>
</html>
