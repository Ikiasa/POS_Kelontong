<div 
    x-show="showPaymentModal" 
    style="display: none;"
    class="fixed inset-0 z-50 overflow-y-auto" 
    aria-labelledby="modal-title" 
    role="dialog" 
    aria-modal="true"
>
    <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        <!-- Backdrop -->
        <div 
            x-show="showPaymentModal"
            x-transition:enter="ease-out duration-300"
            x-transition:enter-start="opacity-0"
            x-transition:enter-end="opacity-100"
            x-transition:leave="ease-in duration-200"
            x-transition:leave-start="opacity-100"
            x-transition:leave-end="opacity-0"
            class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" 
            @click="closePaymentModal()" 
            aria-hidden="true"
        ></div>

        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>

        <!-- Modal Panel -->
        <div 
            x-show="showPaymentModal"
            x-transition:enter="ease-out duration-300"
            x-transition:enter-start="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
            x-transition:enter-end="opacity-100 translate-y-0 sm:scale-100"
            x-transition:leave="ease-in duration-200"
            x-transition:leave-start="opacity-100 translate-y-0 sm:scale-100"
            x-transition:leave-end="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
            class="inline-block align-bottom bg-white rounded-lg px-4 pt-5 pb-4 text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-2xl sm:w-full sm:p-6"
        >
            <div class="absolute top-0 right-0 pt-4 pr-4">
                <button @click="closePaymentModal()" type="button" class="bg-white rounded-md text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                    <span class="sr-only">Close</span>
                    <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                </button>
            </div>

            <div class="sm:flex sm:items-start">
                <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left w-full">
                    <h3 class="text-2xl leading-6 font-bold text-gray-900" id="modal-title">
                        Complete Payment
                    </h3>

                    <!-- Total Amount Display -->
                    <div class="mt-6 bg-gray-50 p-4 rounded-lg flex flex-col gap-2 mb-6 border border-gray-200">
                        <div class="flex justify-between items-center text-sm text-gray-500">
                            <span>Subtotal</span>
                            <span x-text="formatPrice(subtotal)"></span>
                        </div>
                        <div class="flex justify-between items-center text-sm text-gray-500">
                            <span>Tax (PPN 11%)</span>
                            <span x-text="formatPrice(tax)"></span>
                        </div>
                        <div class="flex justify-between items-center text-sm text-gray-500">
                            <span>Service Charge (5%)</span>
                            <span x-text="formatPrice(serviceCharge)"></span>
                        </div>
                        <div x-show="discount > 0" class="flex justify-between items-center text-sm text-green-600">
                            <span>Points Discount</span>
                            <span x-text="'- ' + formatPrice(discount)"></span>
                        </div>
                        <div class="h-px bg-gray-200 my-1"></div>
                        <div class="flex justify-between items-center font-bold">
                            <span class="text-lg text-gray-600">Total to Pay</span>
                            <span class="text-3xl font-bold text-indigo-600" x-text="formatPrice(grandTotal)"></span>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-3 gap-6">
                        <!-- Payment Methods -->
                        <div class="col-span-1 space-y-2">
                             <label class="block text-sm font-medium text-gray-700 mb-2">Payment Method</label>
                            
                             <button 
                                @click="setPaymentMethod('cash')"
                                :class="{'ring-2 ring-indigo-500 bg-indigo-50 text-indigo-700': paymentMethod === 'cash', 'border-gray-200 hover:bg-gray-50': paymentMethod !== 'cash'}"
                                class="w-full flex items-center justify-between p-3 border rounded-lg transition-all"
                            >
                                <div class="flex items-center gap-2">
                                     <svg class="w-5 h-5 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z" />
                                    </svg>
                                    <span class="font-medium">Cash</span>
                                </div>
                            </button>

                            <button 
                                @click="setPaymentMethod('qris')"
                                :class="{'ring-2 ring-indigo-500 bg-indigo-50 text-indigo-700': paymentMethod === 'qris', 'border-gray-200 hover:bg-gray-50': paymentMethod !== 'qris'}"
                                class="w-full flex items-center justify-between p-3 border rounded-lg transition-all"
                            >
                                <div class="flex items-center gap-2">
                                    <svg class="w-5 h-5 text-gray-800" fill="currentColor" viewBox="0 0 24 24">
                                        <path d="M3 3h6v6H3V3zm2 2v2h2V5H5zm8-2h6v6h-6V3zm2 2v2h2V5h-2zM3 15h6v6H3v-6zm2 2v2h2v-2H5zm13-2h3v3h-3v-3zm0 3h-3v3h3v-3zm-3-3h-3v3h3v-3zm3 3h3v3h-3v-3z"/>
                                    </svg>
                                    <span class="font-medium">QRIS</span>
                                </div>
                            </button>

                             <button 
                                @click="setPaymentMethod('split')"
                                :class="{'ring-2 ring-indigo-500 bg-indigo-50 text-indigo-700': paymentMethod === 'split', 'border-gray-200 hover:bg-gray-50': paymentMethod !== 'split'}"
                                class="w-full flex items-center justify-between p-3 border rounded-lg transition-all"
                            >
                                <div class="flex items-center gap-2">
                                    <svg class="w-5 h-5 text-purple-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                    </svg>
                                    <span class="font-medium">Split Payment</span>
                                </div>
                            </button>

                             <button 
                                @click="setPaymentMethod('transfer')"
                                :class="{'ring-2 ring-indigo-500 bg-indigo-50 text-indigo-700': paymentMethod === 'transfer', 'border-gray-200 hover:bg-gray-50': paymentMethod !== 'transfer'}"
                                class="w-full flex items-center justify-between p-3 border rounded-lg transition-all"
                            >
                                <div class="flex items-center gap-2">
                                    <svg class="w-5 h-5 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 14v3m4-8v8m4-9v8M3 21h18M3 10h18M3 7l9-4 9 4M4 10h16v11H4V10z" />
                                    </svg>
                                    <span class="font-medium">Transfer</span>
                                </div>
                            </button>
                        </div>

                        <!-- Right Side Form -->
                        <div class="col-span-1 sm:col-span-2 pl-0 sm:pl-4 border-l border-gray-100">
                            <!-- Cash Payment Flow -->
                            <div x-show="paymentMethod === 'cash'" class="space-y-4">
                                <div>
                                    <label for="cash-input" class="block text-sm font-medium text-gray-700 mb-1">Cash Received</label>
                                    <div class="relative rounded-md shadow-sm">
                                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                            <span class="text-gray-500 sm:text-sm">Rp</span>
                                        </div>
                                        <input 
                                            type="number" 
                                            id="cash-input"
                                            x-model="cashReceived"
                                            class="focus:ring-indigo-500 focus:border-indigo-500 block w-full pl-10 sm:text-xl border-gray-300 rounded-md py-3 font-mono" 
                                            placeholder="0"
                                            @keydown.enter="processPayment()"
                                        >
                                    </div>
                                </div>

                                <div class="flex justify-between items-center py-4 border-t border-b border-gray-100 bg-gray-50 px-4 rounded-lg">
                                    <span class="text-gray-600 font-medium">Change Due</span>
                                    <span 
                                        class="text-2xl font-bold font-mono" 
                                        :class="{'text-green-600': change >= 0, 'text-red-500': change < 0}"
                                        x-text="formatPrice(change)"
                                    ></span>
                                </div>
                                
                                <div class="grid grid-cols-4 gap-2 mt-2">
                                     <button @click="cashReceived = grandTotal" class="text-xs bg-gray-100 hover:bg-gray-200 rounded py-2 text-gray-600">Exact</button>
                                     <button @click="cashReceived = Math.ceil(grandTotal/10000)*10000" class="text-xs bg-gray-100 hover:bg-gray-200 rounded py-2 text-gray-600">Next 10k</button>
                                     <button @click="cashReceived = Math.ceil(grandTotal/50000)*50000" class="text-xs bg-gray-100 hover:bg-gray-200 rounded py-2 text-gray-600">Next 50k</button>
                                     <button @click="cashReceived = Math.ceil(grandTotal/100000)*100000" class="text-xs bg-gray-100 hover:bg-gray-200 rounded py-2 text-gray-600">Next 100k</button>
                                </div>
                            </div>

                            <!-- QRIS Payment Flow -->
                            <div x-show="paymentMethod === 'qris'" class="flex flex-col items-center justify-center h-full py-4 text-center space-y-4">
                                <div class="space-y-4">
                                     <div class="bg-white p-2 rounded-lg inline-block border-2 border-indigo-100 shadow-sm">
                                         <img 
                                            :src="'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=' + encodeURIComponent(qrisPayload)" 
                                            alt="QRIS Code"
                                            class="w-48 h-48"
                                         >
                                    </div>
                                    <div class="flex flex-col gap-1">
                                        <p class="text-sm font-bold text-gray-800">Scan QRIS to Pay</p>
                                        <p class="text-xs text-gray-500">Supports GPN, GoPay, OVO, ShopeePay</p>
                                    </div>
                                    <div class="flex items-center justify-center gap-2">
                                        <div class="w-2 h-2 bg-green-500 rounded-full animate-pulse"></div>
                                        <p class="text-xs text-gray-500 animate-pulse">Waiting for payment confirmation...</p>
                                    </div>
                                </div>
                            </div>

                            <!-- Split Payment Flow -->
                            <div x-show="paymentMethod === 'split'" class="space-y-4">
                                <div class="bg-indigo-50 p-4 rounded-lg border border-indigo-100 mb-4">
                                    <div class="flex justify-between items-center mb-1">
                                        <span class="text-sm text-indigo-700">Remaining to Pay</span>
                                        <span class="text-xl font-bold text-indigo-800" x-text="formatPrice(remainingBalance)"></span>
                                    </div>
                                    <div class="w-full bg-indigo-200 rounded-full h-2">
                                        <div class="bg-indigo-600 h-2 rounded-full transition-all duration-500" :style="'width: ' + ((grandTotal - remainingBalance) / grandTotal * 100) + '%'"></div>
                                    </div>
                                </div>

                                <div class="space-y-2 max-h-48 overflow-y-auto pr-2 pos-scrollbar">
                                    <template x-for="(p, index) in splitPayments" :key="index">
                                        <div class="flex items-center justify-between p-2 bg-white border border-gray-200 rounded-lg shadow-sm">
                                            <div class="flex items-center gap-2">
                                                <span class="capitalize font-medium text-gray-700" x-text="p.method"></span>
                                                <span class="text-indigo-600 font-bold" x-text="formatPrice(p.amount)"></span>
                                            </div>
                                            <button @click="removeSplitPayment(index)" class="text-red-500 hover:bg-red-50 p-1 rounded">
                                                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" /></svg>
                                            </button>
                                        </div>
                                    </template>
                                </div>

                                <div x-show="remainingBalance > 0" class="pt-4 border-t border-gray-100">
                                    <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2">Add Payment Method</label>
                                    <div class="flex gap-2">
                                        <div class="relative flex-1">
                                            <span class="absolute inset-y-0 left-0 pl-3 flex items-center text-gray-400">Rp</span>
                                            <input type="number" x-model="cashReceived" class="w-full pl-10 pr-4 py-2 border rounded-md" placeholder="Amount">
                                        </div>
                                        <select x-model="paymentMethod" class="border rounded-md px-2 py-2 bg-gray-50 text-sm" @change="if(paymentMethod !== 'split') { addSplitPayment(paymentMethod, cashReceived); paymentMethod = 'split'; }">
                                            <option value="split">Select Method</option>
                                            <option value="cash">Cash</option>
                                            <option value="gopay">GoPay</option>
                                            <option value="ovo">OVO</option>
                                            <option value="shopeepay">ShopeePay</option>
                                        </select>
                                    </div>
                                    <button 
                                        @click="addSplitPayment('cash', Math.min(cashReceived || remainingBalance, remainingBalance))"
                                        class="mt-2 w-full py-2 bg-gray-100 text-gray-700 rounded-md text-sm font-medium hover:bg-gray-200"
                                    >
                                        Add Payment
                                    </button>
                                </div>
                            </div>
                            
                            <!-- Generic other methods -->
                            <div x-show="['transfer', 'credit'].includes(paymentMethod)" class="flex flex-col items-center justify-center h-full py-4 text-center">
                                <p class="text-gray-500">Record external payment manually.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="mt-8 sm:mt-4 sm:flex sm:flex-row-reverse gap-3">
                <button 
                    type="button" 
                    @click="processPayment()"
                    :disabled="isProcessingPayment || (paymentMethod === 'cash' && change < 0) || (paymentMethod === 'split' && remainingBalance > 0)"
                    :class="{'opacity-50 cursor-not-allowed': isProcessingPayment || (paymentMethod === 'cash' && change < 0) || (paymentMethod === 'split' && remainingBalance > 0), 'hover:bg-indigo-700': !isProcessingPayment}"
                    class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-indigo-600 text-base font-medium text-white focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:ml-3 sm:w-auto sm:text-sm"
                >
                    <span x-show="!isProcessingPayment">Confirm Payment</span>
                    <span x-show="isProcessingPayment" class="flex items-center">
                        <svg class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" fill="none" viewBox="0 0 24 24">
                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                        </svg>
                        Processing...
                    </span>
                </button>
                <button 
                    type="button" 
                    @click="closePaymentModal()"
                    class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none sm:mt-0 sm:w-auto sm:text-sm"
                >
                    Cancel
                </button>
            </div>
        </div>
    </div>
</div>
