<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Close Session - POS System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
</head>
<body class="bg-gray-50 font-sans antialiased">
    <div 
        x-data="{
            closingCash: 0,
            expectedCash: {{ $current->expected_balance }},
            showWarningModal: false,
            showSummaryModal: false,
            summary: null,
            isSubmitting: false,
            
            get difference() {
                return this.closingCash - this.expectedCash;
            },
            get differenceColor() {
                if (this.difference === 0) return 'text-green-600';
                if (this.difference < 0) return 'text-red-600';
                return 'text-yellow-600';
            },
            get differenceText() {
                if (this.difference === 0) return 'Exact Match ✓';
                if (this.difference < 0) return 'Short by Rp ' + Math.abs(this.difference).toLocaleString('id-ID');
                return 'Over by Rp ' + this.difference.toLocaleString('id-ID');
            },
            
            handleSubmit(e) {
                e.preventDefault();
                
                // Check if difference is not zero
                if (this.difference !== 0) {
                    this.showWarningModal = true;
                    return;
                }
                
                // If exact match, submit directly
                this.submitForm();
            },
            
            async submitForm() {
                this.isSubmitting = true;
                this.showWarningModal = false;
                
                const formData = new FormData();
                formData.append('_token', '{{ csrf_token() }}');
                formData.append('_method', 'PUT');
                formData.append('closing_balance', this.closingCash);
                
                try {
                    const response = await fetch('{{ route('cash-drawer.close', $current->id) }}', {
                        method: 'POST',
                        body: formData,
                        headers: {
                            'X-Requested-With': 'XMLHttpRequest'
                        }
                    });
                    
                    const data = await response.json();
                    
                    if (response.ok) {
                        // Show summary modal
                        this.summary = data.summary;
                        this.showSummaryModal = true;
                    } else {
                        alert('Error closing session: ' + (data.message || 'Unknown error'));
                        this.isSubmitting = false;
                    }
                } catch (error) {
                    alert('Error closing session: ' + error.message);
                    this.isSubmitting = false;
                }
            },
            
            confirmAndExit() {
                window.location.href = '/cash-drawer';
            }
        }"
        class="min-h-screen flex items-center justify-center p-4"
    >
        
        <!-- Main Card -->
        <div class="w-full max-w-md bg-white rounded-xl shadow-lg border border-gray-100 overflow-hidden relative">
            
            <!-- Decorative Top Bar -->
            <div class="h-2 bg-red-600 w-full absolute top-0 left-0"></div>

            <div class="p-8">
                <!-- Header -->
                <div class="text-center mb-8">
                    <div class="w-16 h-16 bg-red-50 rounded-full flex items-center justify-center mx-auto mb-4 text-red-600">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-8 h-8">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 1 0-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 0 0 2.25-2.25v-6.75a2.25 2.25 0 0 0-2.25-2.25H6.75a2.25 2.25 0 0 0-2.25 2.25v6.75a2.25 2.25 0 0 0 2.25 2.25Z" />
                        </svg>
                    </div>
                    <h1 class="text-2xl font-bold text-gray-900 tracking-tight">Close Session</h1>
                    <p class="text-gray-500 mt-2 text-sm">Count your cash and close the drawer</p>
                </div>

                <!-- Section 1: Summary (Readonly) -->
                <div class="bg-gray-50 rounded-xl p-4 space-y-3 mb-6">
                    <div class="flex justify-between items-center">
                        <span class="text-sm text-gray-600">Opening Cash</span>
                        <span class="text-sm font-bold text-gray-900">Rp {{ number_format($current->opening_balance, 0, ',', '.') }}</span>
                    </div>
                    <div class="flex justify-between items-center">
                        <span class="text-sm text-gray-600">Total Cash Sales</span>
                        <span class="text-sm font-bold text-gray-900">Rp {{ number_format($current->expected_balance - $current->opening_balance, 0, ',', '.') }}</span>
                    </div>
                    <div class="flex justify-between items-center pt-3 border-t border-gray-200">
                        <span class="text-sm font-semibold text-gray-700">Expected Cash</span>
                        <span class="text-lg font-bold text-indigo-600">Rp {{ number_format($current->expected_balance, 0, ',', '.') }}</span>
                    </div>
                </div>

                <!-- Form -->
                <form @submit="handleSubmit" class="space-y-6">
                    
                    <!-- Section 2: Closing Cash Input -->
                    <div class="space-y-2">
                        <label for="closing_balance" class="block text-sm font-medium text-gray-700">Closing Cash Amount</label>
                        <div class="relative rounded-lg shadow-sm">
                            <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-4">
                                <span class="text-gray-500 sm:text-lg font-bold">Rp</span>
                            </div>
                            <input 
                                type="number" 
                                x-model.number="closingCash"
                                class="block w-full rounded-xl border-gray-300 pl-12 py-3 pr-4 text-gray-900 placeholder-gray-300 focus:border-indigo-500 focus:ring-indigo-500 sm:text-lg font-semibold transition-shadow shadow-sm" 
                                placeholder="0" 
                                required
                                autofocus
                                :disabled="isSubmitting"
                            >
                        </div>
                        
                        <!-- Real-time Difference Display -->
                        <div 
                            x-show="closingCash > 0"
                            x-transition
                            class="mt-3 p-3 rounded-lg bg-gray-50 border"
                            :class="{
                                'border-green-200 bg-green-50': difference === 0,
                                'border-red-200 bg-red-50': difference < 0,
                                'border-yellow-200 bg-yellow-50': difference > 0
                            }"
                        >
                            <div class="flex items-center justify-between">
                                <span class="text-sm font-medium text-gray-700">Difference:</span>
                                <span 
                                    class="text-sm font-bold"
                                    :class="differenceColor"
                                    x-text="differenceText"
                                ></span>
                            </div>
                        </div>
                    </div>

                    <button 
                        type="submit" 
                        class="w-full flex justify-center items-center gap-2 py-3.5 px-4 border border-transparent rounded-xl shadow-sm text-sm font-bold text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500 transition-all active:scale-[0.98] disabled:opacity-50 disabled:cursor-not-allowed"
                        :disabled="isSubmitting"
                    >
                        <svg x-show="!isSubmitting" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M16.5 10.5V6.75a4.5 4.5 0 1 0-9 0v3.75m-.75 11.25h10.5a2.25 2.25 0 0 0 2.25-2.25v-6.75a2.25 2.25 0 0 0-2.25-2.25H6.75a2.25 2.25 0 0 0-2.25 2.25v6.75a2.25 2.25 0 0 0 2.25 2.25Z" />
                        </svg>
                        <span x-show="isSubmitting">Closing...</span>
                        <span x-show="!isSubmitting">Close Session</span>
                    </button>
                </form>
            </div>
            
            <!-- Footer Info -->
            <div class="bg-gray-50 px-8 py-4 border-t border-gray-100 flex justify-between items-center text-xs text-gray-500">
                <span>Session: #{{ $current->id }}</span>
                <span>{{ auth()->user()->name }}</span>
            </div>
        </div>

        <!-- Warning Modal (Cash Difference) -->
        <div 
            x-show="showWarningModal" 
            x-transition
            class="fixed inset-0 z-50 overflow-y-auto"
            style="display: none;"
        >
            <div class="flex items-center justify-center min-h-screen px-4">
                <div class="fixed inset-0 bg-black/50 backdrop-blur-sm" @click="showWarningModal = false"></div>
                
                <div class="relative bg-white rounded-xl shadow-xl max-w-md w-full p-6 border"
                     :class="{
                         'border-yellow-200': difference > 0,
                         'border-red-200': difference < 0
                     }">
                    
                    <!-- Icon -->
                    <div class="flex justify-center mb-4">
                        <div class="w-16 h-16 rounded-full flex items-center justify-center"
                             :class="{
                                 'bg-yellow-50 text-yellow-600': difference > 0,
                                 'bg-red-50 text-red-600': difference < 0
                             }">
                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-8 h-8">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126ZM12 15.75h.007v.008H12v-.008Z" />
                            </svg>
                        </div>
                    </div>
                    
                    <h3 class="text-xl font-bold text-center text-gray-900 mb-2">Cash Difference Detected</h3>
                    <p class="text-center text-gray-600 mb-1" x-show="difference > 0">
                        You have <strong class="text-yellow-600">excess cash</strong>.
                    </p>
                    <p class="text-center text-gray-600 mb-1" x-show="difference < 0">
                        You have a <strong class="text-red-600">cash shortage</strong>.
                    </p>
                    <p class="text-center text-lg font-bold mb-6" :class="differenceColor" x-text="differenceText"></p>
                    
                    <div class="space-y-3">
                        <button 
                            @click="showWarningModal = false"
                            class="w-full py-3 px-4 rounded-xl font-bold text-gray-700 bg-gray-100 hover:bg-gray-200 transition-colors"
                        >
                            Cancel & Recount
                        </button>
                        <button 
                            @click="submitForm"
                            class="w-full py-3 px-4 rounded-xl font-bold text-white transition-colors"
                            :class="{
                                'bg-yellow-600 hover:bg-yellow-700': difference > 0,
                                'bg-red-600 hover:bg-red-700': difference < 0
                            }"
                        >
                            Close Anyway
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Shift Summary Modal -->
        <div 
            x-show="showSummaryModal" 
            x-transition
            class="fixed inset-0 z-50 overflow-y-auto"
            style="display: none;"
        >
            <div class="flex items-center justify-center min-h-screen px-4">
                <div class="fixed inset-0 bg-black/50 backdrop-blur-sm"></div>
                
                <div class="relative bg-white rounded-xl shadow-xl max-w-md w-full overflow-hidden border border-gray-200">
                    
                    <div class="h-2 bg-green-600 w-full"></div>
                    
                    <div class="p-6">
                        <!-- Icon -->
                        <div class="flex justify-center mb-4">
                            <div class="w-16 h-16 bg-green-50 rounded-full flex items-center justify-center text-green-600">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-8 h-8">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75 11.25 15 15 9.75M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z" />
                                </svg>
                            </div>
                        </div>
                        
                        <h3 class="text-2xl font-bold text-center text-gray-900 mb-6">Shift Summary</h3>
                        
                        <div class="space-y-3 text-sm">
                            <div class="flex justify-between">
                                <span class="text-gray-600">Opening Cash</span>
                                <span class="font-bold text-gray-900" x-text="'Rp ' + (summary?.opening_cash || 0).toLocaleString('id-ID')"></span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-600">Total Sales</span>
                                <span class="font-bold text-gray-900" x-text="'Rp ' + (summary?.total_sales || 0).toLocaleString('id-ID')"></span>
                            </div>
                            <div class="flex justify-between pl-4">
                                <span class="text-gray-500 text-xs">└ Cash Sales</span>
                                <span class="font-semibold text-gray-700 text-xs" x-text="'Rp ' + (summary?.cash_sales || 0).toLocaleString('id-ID')"></span>
                            </div>
                            <div class="flex justify-between pl-4">
                                <span class="text-gray-500 text-xs">└ Non-Cash Sales</span>
                                <span class="font-semibold text-gray-700 text-xs" x-text="'Rp ' + (summary?.non_cash_sales || 0).toLocaleString('id-ID')"></span>
                            </div>
                            
                            <div class="border-t border-gray-200 pt-3"></div>
                            
                            <div class="flex justify-between">
                                <span class="text-gray-600">Expected Cash</span>
                                <span class="font-bold text-indigo-600" x-text="'Rp ' + (summary?.expected_cash || 0).toLocaleString('id-ID')"></span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-600">Closing Cash</span>
                                <span class="font-bold text-gray-900" x-text="'Rp ' + (summary?.closing_cash || 0).toLocaleString('id-ID')"></span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-600 font-semibold">Difference</span>
                                <span 
                                    class="font-bold"
                                    :class="{
                                        'text-green-600': summary?.difference === 0,
                                        'text-red-600': summary?.difference < 0,
                                        'text-yellow-600': summary?.difference > 0
                                    }"
                                    x-text="'Rp ' + Math.abs(summary?.difference || 0).toLocaleString('id-ID')"
                                ></span>
                            </div>
                            
                            <div class="border-t border-gray-200 pt-3"></div>
                            
                            <div class="flex justify-between">
                                <span class="text-gray-600">Total Transactions</span>
                                <span class="font-bold text-gray-900" x-text="summary?.total_transactions || 0"></span>
                            </div>
                        </div>
                        
                        <div class="mt-6 space-y-2">
                            <button 
                                @click="confirmAndExit"
                                class="w-full py-3 px-4 rounded-xl font-bold text-white bg-indigo-600 hover:bg-indigo-700 transition-colors"
                            >
                                Confirm & Exit
                            </button>
                            <button 
                                @click="window.print()"
                                class="w-full py-3 px-4 rounded-xl font-bold text-gray-700 bg-gray-100 hover:bg-gray-200 transition-colors"
                            >
                                Print Summary
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
