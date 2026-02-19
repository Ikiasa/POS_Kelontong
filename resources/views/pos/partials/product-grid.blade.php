<div class="col-span-8 flex flex-col h-full bg-slate-800 border-r border-slate-700">
    <!-- Top Tabs (Categories) -->
    <div class="flex space-x-1 overflow-x-auto bg-slate-800 p-1 pos-scrollbar select-none shrink-0 border-b border-slate-600">
        <button 
            @click="selectedCategory = 'all'" 
            class="px-5 py-2 text-sm font-bold uppercase tracking-wide border-r border-slate-600 transition-all shadow-sm"
            :class="{'bg-cyan-500 text-white': selectedCategory === 'all', 'bg-slate-700 text-slate-300 hover:bg-slate-600': selectedCategory !== 'all'}"
        >
            <i class="fas fa-home mr-1"></i> HOME
        </button>
        <template x-for="cat in categories" :key="cat.id">
            <button 
                @click="selectedCategory = cat.id" 
                class="px-5 py-2 text-sm font-bold uppercase tracking-wide border-r border-slate-600 transition-all shadow-sm whitespace-nowrap"
                :class="{'bg-cyan-500 text-white': selectedCategory === cat.id, 'bg-slate-700 text-slate-300 hover:bg-slate-600': selectedCategory !== cat.id}"
                x-text="cat.name"
            ></button>
        </template>
    </div>

    <!-- Search Bar -->
    <div class="p-2 bg-slate-800 border-b border-slate-700 shadow-sm z-10">
        <div class="relative">
            <input 
                type="text" 
                id="product-search"
                x-model="searchQuery" 
                @keydown.enter="handleSearchEnter()"
                class="w-full pl-3 pr-10 py-2 rounded-none bg-slate-600 border border-slate-500 text-white placeholder-slate-400 focus:ring-1 focus:ring-cyan-500 focus:border-cyan-500 text-sm" 
                placeholder="Cari..." 
                autofocus
            >
            <div class="absolute inset-y-0 right-0 pr-3 flex items-center pointer-events-none">
                <svg class="h-4 w-4 text-slate-300" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
            </div>
        </div>
    </div>

    <!-- Product Grid -->
    <div class="flex-1 overflow-y-auto p-2 bg-slate-900 pos-scrollbar">
        <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-2">
            <template x-for="product in filteredProducts" :key="product.id">
                <div 
                    @click="addToCart(product)" 
                    class="group bg-white rounded shadow-sm overflow-hidden cursor-pointer hover:ring-2 hover:ring-cyan-400 transition-all transform active:scale-95 flex flex-col h-full relative"
                >
                    <div class="aspect-square bg-white relative p-2 flex items-center justify-center">
                        <template x-if="product.image">
                            <img :src="product.image" class="max-w-full max-h-full object-contain" :alt="product.name">
                        </template>
                        <template x-if="!product.image">
                            <div class="w-full h-full flex items-center justify-center text-gray-300 bg-gray-50 rounded">
                                <span class="text-xl font-bold" x-text="product.name.substring(0,2).toUpperCase()"></span>
                            </div>
                        </template>
                        
                        <!-- Stock Badge -->
                        <div class="absolute top-1 right-1" x-show="product.stock <= 10">
                             <span 
                                :class="{'bg-yellow-100 text-yellow-800': product.stock > 0, 'bg-red-100 text-red-800': product.stock === 0}"
                                class="text-[10px] font-bold px-1.5 py-0.5 rounded shadow-sm border border-gray-200" x-text="product.stock">
                             </span>
                        </div>
                    </div>
                    <div class="p-2 flex items-center justify-between border-t border-gray-100 bg-gray-50">
                        <div class="flex-1 min-w-0 pr-2">
                             <h3 class="font-bold text-gray-800 text-xs leading-tight truncate" x-text="product.name"></h3>
                             <p class="text-[10px] text-gray-500 truncate" x-text="product.barcode"></p>
                        </div>
                        <span class="font-bold text-indigo-700 text-xs whitespace-nowrap" x-text="formatPrice(product.price).replace('Rp', '')"></span>
                    </div>
                </div>
            </template>
            <!-- Empty State -->
            <div x-show="filteredProducts.length === 0" class="col-span-full h-64 flex flex-col items-center justify-center text-slate-500">
                <svg class="h-16 w-16 mb-4 text-slate-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
                </svg>
                <p class="text-xl font-bold">Produk tidak ditemukan</p>
                <p class="text-sm">Coba kata kunci lain.</p>
            </div>
        </div>
    </div>
</div>
