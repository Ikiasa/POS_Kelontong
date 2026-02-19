<x-layouts.pos>
    <div 
        class="h-full flex flex-col p-4 gap-4" 
        x-data="pos({
            products: @json($products),
            categories: @json($categories),
            customers: @json($customers),
            promotions: @json($promotions)
        })"
        x-init="init()"
        x-cloak
    >
        <div class="flex-1 flex overflow-hidden gap-4">
            <!-- Left Side - Products Grid (70%) -->
            <div class="w-8/12 flex flex-col gap-4">
                <!-- Search and Categories -->
                <div class="flex flex-col gap-4 shrink-0">
                    <!-- Search Bar -->
                    <div class="relative">
                        <svg class="absolute left-4 top-1/2 -translate-y-1/2 h-5 w-5 text-slate-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                        </svg>
                        <input type="text" 
                               x-model="searchQuery"
                               placeholder="Cari produk... (F1)" 
                               class="w-full bg-slate-800 border border-slate-700 rounded-xl py-3.5 pl-12 pr-4 text-white placeholder-slate-500 focus:outline-none focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 transition-all shadow-sm">
                    </div>
                    
                    <!-- Categories -->
                    <div class="flex items-center gap-2 overflow-x-auto scrollbar-custom pb-2 select-none">
                        <button 
                            @click="selectedCategory = 'all'"
                            :class="{'bg-indigo-600 text-white shadow-lg shadow-indigo-600/20': selectedCategory === 'all', 'bg-slate-800 text-slate-400 hover:bg-slate-700 hover:text-white': selectedCategory !== 'all'}"
                            class="px-6 py-2.5 rounded-lg text-sm font-bold whitespace-nowrap transition-all flex items-center gap-2 border border-transparent"
                        >
                            <span>📦</span>
                            Semua
                        </button>
                        <template x-for="cat in categories" :key="cat.id">
                            <button 
                                @click="selectedCategory = cat.id"
                                :class="{'bg-indigo-600 text-white shadow-lg shadow-indigo-600/20': selectedCategory === cat.id, 'bg-slate-800 text-slate-400 hover:bg-slate-700 hover:text-white': selectedCategory !== cat.id}"
                                class="px-6 py-2.5 rounded-lg text-sm font-bold whitespace-nowrap transition-all border border-transparent"
                                x-text="cat.name"
                            ></button>
                        </template>
                    </div>
                </div>

                <!-- Products Grid -->
                <div class="flex-1 bg-slate-800/80 backdrop-blur-sm rounded-2xl border border-slate-700 p-4 shadow-xl overflow-hidden relative">
                    <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-4 h-full overflow-y-auto scrollbar-custom pr-2 content-start pb-20">
                        <template x-for="product in filteredProducts" :key="product.id">
                            <div 
                                @click="addToCart(product)"
                                class="product-card bg-slate-800 rounded-2xl border border-slate-700 overflow-hidden hover:border-indigo-500 cursor-pointer group flex flex-col shadow-sm hover:shadow-indigo-500/20"
                            >
                                <div class="aspect-[4/3] bg-slate-900/50 relative flex items-center justify-center p-4">
                                    <template x-if="product.image">
                                        <img :src="product.image" class="max-w-full max-h-full object-contain drop-shadow-md transition-transform duration-300 group-hover:scale-110" :alt="product.name">
                                    </template>
                                    <template x-if="!product.image">
                                        <div class="w-12 h-12 rounded-full bg-slate-800 flex items-center justify-center text-2xl border border-slate-700">
                                            📦
                                        </div>
                                    </template>
                                    
                                    <!-- Stock Badge -->
                                    <div class="absolute top-2 right-2" x-show="product.stock <= 10">
                                        <div class="px-2 py-1 bg-red-500/20 border border-red-500/30 text-red-400 text-[10px] font-bold rounded-lg backdrop-blur-sm">
                                            <span x-text="'Sisa ' + product.stock"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="p-3 bg-slate-800 flex-1 flex flex-col justify-between border-t border-slate-700/50">
                                    <h3 class="font-medium text-sm text-slate-200 group-hover:text-white transition-colors line-clamp-2 leading-tight min-h-[2.5em]" x-text="product.name"></h3>
                                    <div class="mt-2">
                                        <p class="text-indigo-400 font-bold text-lg" x-text="formatPrice(product.price).replace('Rp', '')"></p>
                                        <p class="text-[10px] text-slate-500 font-mono" x-text="'Stok: ' + product.stock"></p>
                                    </div>
                                </div>
                            </div>
                        </template>

                        <!-- Empty State -->
                        <div x-show="filteredProducts.length === 0" class="col-span-full h-80 flex flex-col items-center justify-center text-slate-500">
                            <div class="w-24 h-24 bg-slate-800/50 rounded-full flex items-center justify-center mb-4 border border-slate-700/50">
                                <svg class="w-10 h-10 text-slate-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                                </svg>
                            </div>
                            <p class="text-lg font-medium text-slate-400">Produk tidak ditemukan</p>
                            <p class="text-sm text-slate-600 mt-1">Coba kata kunci lain atau pilih kategori berbeda</p>
                        </div>
                    </div>
                    
                    <!-- Gradient Overlay at bottom to indicate scroll -->
                    <div class="absolute bottom-0 left-0 right-0 h-8 bg-gradient-to-t from-slate-800 to-transparent pointer-events-none rounded-b-2xl"></div>
                </div>
            </div>

            <!-- Right Side - Cart (30%) -->
            <div class="w-4/12 flex flex-col gap-4">
                <!-- Cart Summary -->
                <div class="bg-gradient-to-br from-indigo-900 to-slate-900 rounded-2xl p-4 shadow-xl shrink-0 border border-slate-700">
                    <div class="space-y-1 mb-3 pb-3 border-b border-white/10 text-xs">
                        <div class="flex justify-between text-slate-400">
                            <span>Subtotal</span>
                            <span class="text-slate-300 font-mono" x-text="formatPrice(subtotal)"></span>
                        </div>
                        <div class="flex justify-between text-slate-400">
                            <span>Tax (11%)</span>
                            <span class="text-slate-300 font-mono" x-text="formatPrice(tax)"></span>
                        </div>
                        <div class="flex justify-between text-slate-400" x-show="serviceCharge > 0">
                            <span>Service</span>
                            <span class="text-slate-300 font-mono" x-text="formatPrice(serviceCharge)"></span>
                        </div>
                        <div class="flex justify-between text-slate-400" x-show="discount > 0">
                            <span>Discount</span>
                            <span class="text-green-400 font-mono" x-text="'- ' + formatPrice(discount)"></span>
                        </div>
                    </div>
                    
                    <div class="flex justify-between items-end">
                        <div class="flex flex-col">
                            <span class="text-indigo-200 text-xs uppercase tracking-wider font-semibold">Total Tagihan</span>
                            <span class="text-white text-xs opacity-75" x-text="cartItemCount + ' Items'"></span>
                        </div>
                        <span class="text-3xl font-digital text-white font-bold tracking-wider leading-none" x-text="formatPrice(grandTotal)"></span>
                    </div>
                </div>

                <!-- Cart Items -->
                <div class="flex-1 bg-slate-800/80 backdrop-blur-sm rounded-2xl border border-slate-700 p-4 shadow-xl overflow-hidden flex flex-col">
                    <div class="flex justify-between items-center mb-4 shrink-0">
                        <h2 class="font-semibold text-white flex items-center gap-2">
                            <svg class="w-5 h-5 text-indigo-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"></path>
                            </svg>
                            Keranjang Belanja
                        </h2>
                        <button 
                            @click="clearCart()"
                            class="text-xs text-slate-400 hover:text-red-400 transition-colors flex items-center gap-1"
                            x-show="cart.length > 0"
                        >
                            Kosongkan
                        </button>
                    </div>

                    <!-- Cart Items List -->
                    <div class="flex-1 overflow-y-auto scrollbar-custom space-y-2 pr-2">
                        <template x-for="(item, index) in cart" :key="index">
                            <div class="bg-slate-700/30 rounded-xl p-3 border border-slate-600 group hover:border-slate-500 transition-colors">
                                <div class="flex gap-3 items-start">
                                    <!-- Thumbnail -->
                                    <div class="w-12 h-12 rounded-lg bg-slate-800 shrink-0 border border-slate-600 overflow-hidden flex items-center justify-center">
                                        <template x-if="item.image">
                                            <img :src="item.image" class="w-full h-full object-cover">
                                        </template>
                                        <template x-if="!item.image">
                                            <span class="text-xs">📦</span>
                                        </template>
                                    </div>

                                    <div class="flex-1 min-w-0">
                                        <h3 class="font-medium text-white text-sm truncate leading-tight" x-text="item.name"></h3>
                                        <p class="text-xs text-slate-400 mt-1" x-text="formatPrice(item.price)"></p>
                                    </div>
                                    
                                    <div class="text-right shrink-0 flex flex-col items-end gap-1">
                                        <p class="font-bold text-white" x-text="formatPrice(item.price * item.quantity)"></p>
                                        
                                        <div class="flex items-center gap-1 bg-slate-800 rounded-lg p-0.5 border border-slate-600">
                                            <button @click="decreaseQty(index)" class="text-slate-400 hover:text-white hover:bg-slate-600 w-7 h-7 rounded-md flex items-center justify-center transition-colors font-bold active:bg-slate-500">-</button>
                                            <span class="text-white w-6 text-center text-sm font-bold" x-text="item.quantity"></span>
                                            <button @click="increaseQty(index)" class="text-slate-400 hover:text-white hover:bg-slate-600 w-7 h-7 rounded-md flex items-center justify-center transition-colors font-bold active:bg-slate-500">+</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </template>

                        <!-- Empty State -->
                        <div x-show="cart.length === 0" class="h-full flex flex-col items-center justify-center text-slate-500 space-y-2 py-8 opacity-50">
                            <span class="text-4xl">🛒</span>
                            <p class="text-sm">Keranjang kosong</p>
                        </div>
                    </div>

                    <!-- Cart Footer Actions -->
                    <div class="mt-4 space-y-3 pt-4 border-t border-slate-700 shrink-0">
                        <!-- Discount Input -->
                        <div class="flex gap-2">
                            <div class="relative w-24">
                                <input type="number" 
                                       x-model="discount"
                                       placeholder="Disc %" 
                                       class="w-full bg-slate-900 border border-slate-600 rounded-xl px-3 py-2 text-white placeholder-slate-400 text-sm focus:outline-none focus:border-indigo-500 text-center">
                            </div>
                            <div class="relative flex-1">
                                <span class="absolute left-3 top-2 text-slate-400 text-sm">Rp</span>
                                <input type="number" 
                                       disabled
                                       :value="grandTotal"
                                       class="w-full bg-slate-800 border border-slate-600 rounded-xl px-3 py-2 pl-8 text-white text-sm font-bold disabled:opacity-70">
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="space-y-3">
                            <div class="grid grid-cols-2 gap-3">
                                <button 
                                    class="bg-slate-800 hover:bg-slate-700 text-slate-300 hover:text-white font-medium py-3 rounded-xl transition-all border border-slate-600 flex items-center justify-center gap-2 group"
                                >
                                    <svg class="w-4 h-4 text-slate-500 group-hover:text-white transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 9v6m4-6v6m7-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                    </svg>
                                    Tahan
                                </button>
                                <button 
                                    @click="clearCart()"
                                    class="bg-slate-800 hover:bg-red-900/50 hover:border-red-500/50 text-slate-300 hover:text-red-400 font-medium py-3 rounded-xl transition-all border border-slate-600 flex items-center justify-center gap-2 group"
                                >
                                    <svg class="w-4 h-4 text-slate-500 group-hover:text-red-400 transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                                    </svg>
                                    Batal
                                </button>
                            </div>
                            
                            <button 
                                @click="openPaymentModal()"
                                :disabled="cart.length === 0"
                                :class="{'opacity-50 cursor-not-allowed': cart.length === 0, 'hover:scale-[1.01] hover:shadow-indigo-500/50': cart.length > 0}"
                                class="w-full bg-indigo-600 hover:bg-indigo-500 text-white font-bold py-4 rounded-xl transition-all shadow-lg shadow-indigo-500/20 flex items-center justify-center gap-3 text-lg"
                            >
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"></path>
                                </svg>
                                BAYAR (F8)
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Payment Modal -->
        @include('pos.partials.payment-modal')
    </div>

    @push('scripts')
        @vite('resources/js/pos.js')
    @endpush
</x-layouts.pos>
