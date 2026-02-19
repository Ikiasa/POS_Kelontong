<x-layouts.dashboard>
    <div x-data="{ 
        printReport() {
            window.print();
        },
        toggleRow(id) {
            let el = document.getElementById(id);
            if (el) el.classList.toggle('hidden');
        }
    }">
        <!-- Report Header / Actions -->
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6 print:hidden">
            <div>
                <h2 class="text-2xl font-bold text-gray-800">Profit & Loss Statement</h2>
                <p class="text-gray-500 text-sm">Financial performance report</p>
            </div>
            
            <div class="flex flex-wrap items-center gap-3">
                <!-- Date Filter -->
                <div class="flex items-center bg-white border border-gray-300 rounded-md px-3 py-2 shadow-sm">
                    <span class="text-gray-500 text-sm mr-2">Period:</span>
                    <select class="text-sm border-none focus:ring-0 p-0 text-gray-700 font-medium cursor-pointer">
                        <option>This Month</option>
                        <option>Last Month</option>
                        <option>This Quarter</option>
                        <option>This Year</option>
                        <option>Custom</option>
                    </select>
                </div>
                
                <!-- Export/Print -->
                <button 
                    @click="printReport()"
                    class="bg-indigo-600 text-white px-4 py-2 rounded-md text-sm font-medium hover:bg-indigo-700 flex items-center shadow-sm"
                >
                    <svg class="w-4 h-4 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2-4h6a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                    </svg>
                    Print / PDF
                </button>
            </div>
        </div>

        <!-- Report Content -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden print:shadow-none print:border-none">
            <!-- Printable Header -->
            <div class="hidden print:block text-center mb-8 pt-4">
                <h1 class="text-3xl font-bold text-gray-900">PROFIT & LOSS STATEMENT</h1>
                <p class="text-gray-600 mt-1">{{ config('app.name') }} - {{ auth()->user()->current_store_name ?? 'Main Store' }}</p>
                <p class="text-gray-500 text-sm mt-1">Period: October 1, 2023 - October 31, 2023</p>
            </div>

            <div class="overflow-x-auto">
                <table class="w-full text-sm text-left">
                    <thead class="bg-gray-50 text-gray-500 font-medium border-b border-gray-200">
                        <tr>
                            <th class="px-6 py-3 w-1/2">Account</th>
                            <th class="px-6 py-3 text-right">Debit</th>
                            <th class="px-6 py-3 text-right">Credit</th>
                            <th class="px-6 py-3 text-right font-bold text-gray-700">Total</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <!-- INCOME SECTION -->
                        <tr class="bg-gray-50/50">
                            <td colspan="4" class="px-6 py-3 font-bold text-gray-700 uppercase tracking-wider text-xs">Income</td>
                        </tr>
                        
                        <tr class="hover:bg-gray-50 cursor-pointer" @click="toggleRow('sales-breakdown')">
                            <td class="px-6 py-3 flex items-center">
                                <svg class="w-4 h-4 text-gray-400 mr-2 transform transition-transform" viewBox="0 0 20 20" fill="currentColor">
                                    <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
                                </svg>
                                Sales Revenue
                            </td>
                            <td class="px-6 py-3 text-right text-gray-400">-</td>
                            <td class="px-6 py-3 text-right font-medium text-gray-900">145,000,000</td>
                            <td class="px-6 py-3 text-right font-bold text-gray-900">145,000,000</td>
                        </tr>
                        <!-- Collapsible Rows -->
                        <tr id="sales-breakdown" class="hidden bg-gray-50/30">
                            <td class="px-6 py-2 pl-12 text-gray-600">Product Sales</td>
                            <td class="px-6 py-2 text-right text-gray-400">-</td>
                            <td class="px-6 py-2 text-right text-gray-600">140,000,000</td>
                            <td class="px-6 py-2 text-right text-gray-600"></td>
                        </tr>
                        <tr id="sales-breakdown-2" class="hidden bg-gray-50/30">
                            <td class="px-6 py-2 pl-12 text-gray-600">Service Revenue</td>
                            <td class="px-6 py-2 text-right text-gray-400">-</td>
                            <td class="px-6 py-2 text-right text-gray-600">5,000,000</td>
                            <td class="px-6 py-2 text-right text-gray-600"></td>
                        </tr>

                        <!-- Returns -->
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-3 pl-10">Sales Returns & Allowances</td>
                            <td class="px-6 py-3 text-right font-medium text-red-600">(2,500,000)</td>
                            <td class="px-6 py-3 text-right text-gray-400">-</td>
                            <td class="px-6 py-3 text-right font-bold text-gray-900">(2,500,000)</td>
                        </tr>
                        
                        <!-- GROSS PROFIT -->
                        <tr class="bg-indigo-50 border-t-2 border-indigo-100">
                            <td class="px-6 py-3 font-bold text-indigo-900">GROSS PROFIT</td>
                            <td class="px-6 py-3"></td>
                            <td class="px-6 py-3"></td>
                            <td class="px-6 py-3 text-right font-bold text-indigo-700 text-lg">142,500,000</td>
                        </tr>
                        
                        <!-- EXPENSES SECTION -->
                        <tr class="bg-gray-50/50">
                            <td colspan="4" class="px-6 py-3 font-bold text-gray-700 uppercase tracking-wider text-xs">Operating Expenses</td>
                        </tr>
                        
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-3 pl-10">Cost of Goods Sold (COGS)</td>
                            <td class="px-6 py-3 text-right text-gray-900">85,000,000</td>
                            <td class="px-6 py-3 text-right text-gray-400">-</td>
                            <td class="px-6 py-3 text-right font-medium text-gray-900">(85,000,000)</td>
                        </tr>
                        
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-3 pl-10">Wages & Salaries</td>
                            <td class="px-6 py-3 text-right text-gray-900">12,000,000</td>
                            <td class="px-6 py-3 text-right text-gray-400">-</td>
                            <td class="px-6 py-3 text-right font-medium text-gray-900">(12,000,000)</td>
                        </tr>

                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-3 pl-10">Rent Expense</td>
                            <td class="px-6 py-3 text-right text-gray-900">5,000,000</td>
                            <td class="px-6 py-3 text-right text-gray-400">-</td>
                            <td class="px-6 py-3 text-right font-medium text-gray-900">(5,000,000)</td>
                        </tr>
                        
                        <tr class="hover:bg-gray-50">
                            <td class="px-6 py-3 pl-10">Utilities</td>
                            <td class="px-6 py-3 text-right text-gray-900">1,200,000</td>
                            <td class="px-6 py-3 text-right text-gray-400">-</td>
                            <td class="px-6 py-3 text-right font-medium text-gray-900">(1,200,000)</td>
                        </tr>

                        <!-- NET PROFIT -->
                        <tr class="bg-green-50 border-t-2 border-green-200">
                            <td class="px-6 py-4 font-bold text-green-900 text-lg">NET PROFIT (EBITDA)</td>
                            <td class="px-6 py-4"></td>
                            <td class="px-6 py-4"></td>
                            <td class="px-6 py-4 text-right font-bold text-green-700 text-xl border-b-4 border-double border-green-300">
                                39,300,000
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            
            <!-- Footer Notes -->
            <div class="p-6 text-xs text-gray-500 border-t border-gray-100 hidden print:block">
                <p>Generated on {{ date('d M Y H:i') }} by {{ auth()->user()->name ?? 'System' }}</p>
                <p>This report is confidential and intended for internal use only.</p>
            </div>
        </div>
    </div>
</x-layouts.dashboard>
