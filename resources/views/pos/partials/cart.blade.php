<div class="col-span-4 bg-white flex flex-col h-full shadow-xl z-20">
    <!-- Cart Header -->
    <div class="px-6 py-4 border-b border-gray-100 flex items-center justify-between bg-white">
        <div class="flex items-center gap-2">
            <h2 class="font-bold text-lg text-gray-800">Current Order</h2>
            <span class="bg-indigo-100 text-indigo-700 text-xs font-bold px-2 py-0.5 rounded-full" x-show="cart.length > 0" x-text="cart.length"></span>
        </div>
        <button 
            @click="clearCart()" 
            x-show="cart.length > 0"
            class="text-xs text-red-500 hover:text-red-700 hover:bg-red-50 px-2 py-1 rounded transition-colors flex items-center gap-1"
        >
            <svg class="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
            </svg>
            Clear [F3]
        </button>
    </div>

    <!-- Cart Items List -->
    <div class="flex-1 overflow-y-auto p-4 space-y-3 bg-white pos-scrollbar">
        <template x-for="(item, index) in cart" :key="index">
            <div class="flex items-start gap-4 p-3 bg-white rounded-lg border border-gray-100 shadow-sm hover:border-indigo-100 transition-colors group">
                <!-- Image or Icon -->
                <div class="w-12 h-12 rounded-md bg-gray-100 shrink-0 overflow-hidden flex items-center justify-center">
                    <template x-if="item.image">
                        <img :src="item.image" class="w-full h-full object-cover">
                    </template>
                    <template x-if="!item.image">
                         <span class="text-xs font-bold text-gray-400" x-text="item.name.substring(0,2).toUpperCase()"></span>
                    </template>
                </div>
                
                <div class="flex-1 min-w-0">
                    <div class="flex justify-between items-start mb-1">
                        <h4 class="font-medium text-gray-800 text-sm truncate pr-2" x-text="item.name"></h4>
                        <span class="font-bold text-gray-900 text-sm" x-text="formatPrice(item.price * item.quantity)"></span>
                    </div>
                    
                    <div class="flex items-center justify-between">
                        <p class="text-xs text-gray-400" x-text="formatPrice(item.price) + ' / unit'"></p>
                        
                        <!-- Quantity Controls -->
                        <div class="flex items-center gap-3 bg-gray-50 rounded px-2 py-1 border border-gray-200">
                            <button 
                                @click="decreaseQty(index)"
                                class="text-gray-500 hover:text-red-600 focus:outline-none"
                            >
                                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 12H4" />
                                </svg>
                            </button>
                            <input 
                                type="number" 
                                x-model="item.quantity" 
                                @change="updateQuantity(index, $event.target.value)"
                                class="w-8 text-center bg-transparent border-none p-0 text-sm font-bold text-gray-800 focus:ring-0 [-moz-appearance:_textfield] [&::-webkit-inner-spin-button]:m-0 [&::-webkit-inner-spin-button]:appearance-none"
                            >
                            <button 
                                @click="increaseQty(index)"
                                class="text-gray-500 hover:text-indigo-600 focus:outline-none"
                            >
                                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                                </svg>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </template>
        
        <!-- Empty Cart State -->
        <div x-show="cart.length === 0" class="h-full flex flex-col items-center justify-center text-gray-300 py-10">
            <svg class="w-16 h-16 mb-4 text-gray-200" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
            </svg>
            <p class="text-sm font-medium text-gray-400">Your cart is empty</p>
            <p class="text-xs text-gray-300">Scan product or search to begin</p>
        </div>
    </div>

    <!-- Summary Section -->
    <div class="bg-slate-800 p-3 border-t border-slate-700">
        <div class="space-y-1 mb-3 text-sm text-slate-300">
            <div class="flex justify-between items-center text-xs">
                <span>Sub Total</span>
                <span class="font-bold text-white" x-text="formatPrice(subtotal)"></span>
            </div>
            <div class="flex justify-between items-center text-xs">
                <span>PPN (11%)</span>
                <span class="font-bold text-white" x-text="formatPrice(tax)"></span>
            </div>
            <div class="flex justify-between items-center text-xs">
                <span>Diskon</span>
                 <span class="font-bold text-green-400" x-show="discount > 0" x-text="'-' + formatPrice(discount)"></span>
                 <span class="font-bold text-slate-500" x-show="discount == 0">Rp 0</span>
            </div>
            <div class="flex justify-between items-center text-lg mt-1 pt-1 border-t border-slate-600 text-green-400 font-bold">
                <span>Total</span>
                <span x-text="formatPrice(grandTotal)"></span>
            </div>
        </div>

        <!-- Action Buttons -->
        <div class="grid grid-cols-2 gap-0 h-12">
             <button 
                @click="clearCart()"
                class="bg-red-600 hover:bg-red-700 text-white font-bold text-lg flex items-center justify-center gap-2 transition-colors rounded-l-md border-r border-red-800 shadow-lg"
             >
                <span>BATAL [F2]</span>
            </button>
            
            <button 
                @click="if(cart.length > 0) openPaymentModal()"
                :disabled="cart.length === 0"
                :class="{'opacity-50 cursor-not-allowed bg-slate-600': cart.length === 0, 'bg-green-600 hover:bg-green-700': cart.length > 0}"
                class="text-white font-bold text-lg flex items-center justify-center gap-2 transition-colors rounded-r-md shadow-lg"
            >
                <span>BAYAR [F8]</span>
            </button>
