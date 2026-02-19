<div class="bg-slate-800 rounded-xl shadow-lg border border-slate-700 overflow-hidden">
    <!-- Inventory Summary Cards -->
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 p-6 pb-2 border-b border-slate-700/50">
        <div class="bg-slate-700/30 p-4 rounded-xl border border-slate-700 flex items-center gap-4">
            <div class="p-3 bg-indigo-500/20 text-indigo-400 rounded-lg">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"></path></svg>
            </div>
            <div>
                <p class="text-xs text-slate-400 font-medium uppercase">Total Produk</p>
                <p class="text-2xl font-bold text-white">{{ $totalProducts }}</p>
            </div>
        </div>
        <div class="bg-slate-700/30 p-4 rounded-xl border border-slate-700 flex items-center gap-4">
            <div class="p-3 bg-yellow-500/20 text-yellow-500 rounded-lg">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path></svg>
            </div>
            <div>
                <p class="text-xs text-slate-400 font-medium uppercase">Stok Menipis</p>
                <p class="text-2xl font-bold text-white">{{ $lowStockCount }}</p>
            </div>
        </div>
        <div class="bg-slate-700/30 p-4 rounded-xl border border-slate-700 flex items-center gap-4">
            <div class="p-3 bg-red-500/20 text-red-500 rounded-lg">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
            </div>
            <div>
                <p class="text-xs text-slate-400 font-medium uppercase">Dead Stock (>30d)</p>
                <p class="text-2xl font-bold text-white">{{ $deadStockCount }}</p>
            </div>
        </div>
        <div class="bg-slate-700/30 p-4 rounded-xl border border-slate-700 flex items-center gap-4">
            <div class="p-3 bg-green-500/20 text-green-500 rounded-lg">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
            </div>
            <div>
                <p class="text-xs text-slate-400 font-medium uppercase">Total Aset</p>
                <p class="text-lg font-bold text-white">Rp {{ number_format($totalValue, 0, ',', '.') }}</p>
            </div>
        </div>
    </div>

    <!-- Header Controls -->
    <div class="p-6 border-b border-slate-700 space-y-4">
        <div class="flex flex-col md:flex-row gap-4 justify-between items-center">
            <h2 class="text-xl font-bold text-white">Daftar Produk</h2>
            <a href="{{ route('products.create') }}" class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-lg font-medium transition-colors flex items-center gap-2">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
                Tambah Produk
            </a>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <!-- Search -->
            <div class="md:col-span-2 relative">
                <input wire:model.live.debounce.300ms="search" type="text" placeholder="Cari nama atau barcode..." 
                    class="w-full bg-slate-900 border border-slate-600 rounded-lg py-2.5 pl-10 pr-4 text-white placeholder-slate-400 focus:outline-none focus:border-indigo-500">
                <svg class="absolute left-3 top-3 w-5 h-5 text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
            </div>

            <!-- Category Filter -->
            <select wire:model.live="category" class="bg-slate-900 border border-slate-600 rounded-lg py-2.5 px-3 text-white focus:outline-none focus:border-indigo-500">
                <option value="">Semua Kategori</option>
                @foreach($categories as $cat)
                    <option value="{{ $cat->id }}">{{ $cat->name }}</option>
                @endforeach
            </select>

            <!-- Stock Filter -->
            <select wire:model.live="stockFilter" class="bg-slate-900 border border-slate-600 rounded-lg py-2.5 px-3 text-white focus:outline-none focus:border-indigo-500">
                <option value="">Semua Status Stok</option>
                <option value="active">Tersedia (> 0)</option>
                <option value="low">Menipis (≤ 10)</option>
                <option value="out">Habis (0)</option>
                <option value="dead_stock">Dead Stock (> 30 Hari)</option>
            </select>
        </div>
    </div>

    <!-- Table -->
    <div class="overflow-x-auto">
        <table class="w-full text-left text-sm text-slate-300">
            <thead class="bg-slate-700/50 text-xs uppercase font-semibold text-slate-400">
                <tr>
                    <th class="px-6 py-4 cursor-pointer hover:text-white" wire:click="sortBy('name')">
                        <div class="flex items-center gap-1">
                            Nama Produk
                            @if($sortField === 'name')
                                <span>{{ $sortDirection === 'asc' ? '↑' : '↓' }}</span>
                            @endif
                        </div>
                    </th>
                    <th class="px-6 py-4">Kategori</th>
                    <th class="px-6 py-4 cursor-pointer hover:text-white" wire:click="sortBy('price')">
                        <div class="flex items-center gap-1">
                            Harga
                            @if($sortField === 'price')
                                <span>{{ $sortDirection === 'asc' ? '↑' : '↓' }}</span>
                            @endif
                        </div>
                    </th>
                    <th class="px-6 py-4 cursor-pointer hover:text-white" wire:click="sortBy('stock')">
                        <div class="flex items-center gap-1">
                            Stok
                            @if($sortField === 'stock')
                                <span>{{ $sortDirection === 'asc' ? '↑' : '↓' }}</span>
                            @endif
                        </div>
                    </th>
                    <th class="px-6 py-4 text-center">Aksi</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-slate-700">
                @forelse($products as $product)
                    <tr class="hover:bg-slate-700/30 transition-colors">
                        <td class="px-6 py-4 font-medium text-white flex items-center gap-3">
                            <div class="w-10 h-10 rounded-lg bg-slate-700 flex items-center justify-center text-xl shrink-0">
                                {{ $product->image ? '🖼️' : '📦' }}
                            </div>
                            <div>
                                <div class="line-clamp-1">{{ $product->name }}</div>
                                <div class="text-xs text-slate-500 font-mono">{{ $product->barcode }}</div>
                            </div>
                        </td>
                        <td class="px-6 py-4">
                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-indigo-500/10 text-indigo-400 border border-indigo-500/20">
                                {{ $product->category->name ?? 'Uncategorized' }}
                            </span>
                        </td>
                        <td class="px-6 py-4">
                            <div class="font-bold text-white">Rp {{ number_format($product->price, 0, ',', '.') }}</div>
                            <div class="text-xs text-slate-500">Modal: Rp {{ number_format($product->cost_price ?? 0, 0, ',', '.') }}</div>
                        </td>
                        <td class="px-6 py-4 cursor-pointer hover:bg-slate-700/50 transition-colors group" wire:click="$dispatch('showProductHistory', { productId: {{ $product->id }} })">
                            <div class="flex items-center gap-2">
                                @if($product->stock <= 0)
                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-500/10 text-red-500 border border-red-500/20">
                                        Habis
                                    </span>
                                @elseif($product->stock <= 10)
                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-500/10 text-yellow-500 border border-yellow-500/20">
                                        Menipis ({{ $product->stock }})
                                    </span>
                                @else
                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-500/10 text-green-500 border border-green-500/20">
                                        {{ $product->stock }} Unit
                                    </span>
                                @endif
                                <svg class="w-4 h-4 text-slate-500 opacity-0 group-hover:opacity-100 transition-opacity" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                            </div>
                        </td>
                        <td class="px-6 py-4 text-center">
                            <div class="flex items-center justify-center gap-2">
                                <a href="{{ route('products.edit', $product) }}" class="p-2 text-blue-400 hover:text-blue-300 hover:bg-blue-500/10 rounded-lg transition-colors" title="Edit">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path></svg>
                                </a>
                                <form action="{{ route('products.destroy', $product) }}" method="POST" onsubmit="return confirm('Yakin ingin menghapus?');">
                                    @csrf
                                    @method('DELETE')
                                    <button type="submit" class="p-2 text-red-400 hover:text-red-300 hover:bg-red-500/10 rounded-lg transition-colors" title="Hapus">
                                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path></svg>
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="5" class="px-6 py-12 text-center text-slate-500">
                            <div class="flex flex-col items-center justify-center gap-2">
                                <svg class="w-12 h-12 opacity-50" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"></path></svg>
                                <p>Tidak ada produk ditemukan.</p>
                            </div>
                        </td>
                    </tr>
                @endforelse
            </tbody>
        </table>
    </div>

    <!-- Pagination -->
    <div class="px-6 py-4 border-t border-slate-700">
        {{ $products->links() }}
    </div>
</div>
