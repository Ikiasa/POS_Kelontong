<div>
    @if($showModal)
    <!-- Modal Backdrop -->
    <div class="fixed inset-0 z-50 overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
        <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
            <!-- Background overlay -->
            <div class="fixed inset-0 bg-gray-900 bg-opacity-75 transition-opacity" aria-hidden="true" wire:click="closeModal"></div>

            <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>

            <!-- Modal panel -->
            <div class="inline-block align-bottom bg-slate-800 rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-4xl sm:w-full border border-slate-700">
                <div class="px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                    <div class="sm:flex sm:items-start">
                        <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left w-full">
                            <h3 class="text-lg leading-6 font-medium text-white flex items-center gap-2" id="modal-title">
                                <span>📜</span>
                                Riwayat Stok: <span class="text-indigo-400">{{ $product->name }}</span>
                            </h3>
                            
                            <!-- Product Summary & Actions -->
                            <div class="mt-4 flex flex-col md:flex-row gap-4">
                                <div class="grid grid-cols-3 gap-4 bg-slate-700/50 p-4 rounded-xl border border-slate-600 flex-1">
                                    <div>
                                        <p class="text-xs text-slate-400">Stok Saat Ini</p>
                                        <p class="text-xl font-bold text-white">{{ $product->stock }} Unit</p>
                                    </div>
                                    <div>
                                        <p class="text-xs text-slate-400">Harga Jual</p>
                                        <p class="text-xl font-bold text-white">Rp {{ number_format($product->price, 0, ',', '.') }}</p>
                                    </div>
                                    <div>
                                        <p class="text-xs text-slate-400">Modal</p>
                                        <p class="text-xl font-bold text-white">Rp {{ number_format($product->cost_price ?? 0, 0, ',', '.') }}</p>
                                    </div>
                                </div>
                                
                                <button 
                                    wire:click="toggleAdjustmentForm"
                                    class="bg-indigo-600 hover:bg-indigo-700 text-white px-4 py-2 rounded-xl font-medium transition-colors shadow-lg shadow-indigo-600/20 flex items-center justify-center gap-2"
                                >
                                    <span>⚙️</span>
                                    <span>Sesuaikan Stok</span>
                                </button>
                            </div>

                            <!-- Adjustment Form -->
                            <div x-data x-show="$wire.showAdjustmentForm" x-transition class="mt-4 bg-slate-700/30 border border-indigo-500/30 rounded-xl p-4">
                                <h4 class="text-sm font-bold text-slate-300 mb-3 uppercase tracking-wider">Form Penyesuaian Stok</h4>
                                <div class="grid grid-cols-1 md:grid-cols-4 gap-4 items-end">
                                    <div>
                                        <label class="block text-xs text-slate-400 mb-1">Tipe</label>
                                        <select wire:model="adjType" class="w-full bg-slate-800 border border-slate-600 text-white rounded-lg px-3 py-2 focus:ring-1 focus:ring-indigo-500">
                                            <option value="add">➕ Tambah (Masuk)</option>
                                            <option value="subtract">➖ Kurangi (Keluar/Rusak)</option>
                                        </select>
                                    </div>
                                    <div>
                                        <label class="block text-xs text-slate-400 mb-1">Jumlah</label>
                                        <input type="number" wire:model="adjQty" min="1" class="w-full bg-slate-800 border border-slate-600 text-white rounded-lg px-3 py-2 focus:ring-1 focus:ring-indigo-500" placeholder="0">
                                    </div>
                                    <div class="md:col-span-2">
                                        <label class="block text-xs text-slate-400 mb-1">Catatan (Wajib)</label>
                                        <input type="text" wire:model="adjNote" class="w-full bg-slate-800 border border-slate-600 text-white rounded-lg px-3 py-2 focus:ring-1 focus:ring-indigo-500" placeholder="Contoh: Barang rusak, Restock supplier...">
                                    </div>
                                </div>
                                <div class="mt-3 flex justify-end gap-2">
                                    <button wire:click="toggleAdjustmentForm" class="px-3 py-1.5 text-sm text-slate-400 hover:text-white transition-colors">Batal</button>
                                    <button wire:click="saveAdjustment" class="bg-green-600 hover:bg-green-700 text-white px-4 py-1.5 rounded-lg text-sm font-medium transition-colors shadow-lg shadow-green-600/20">
                                        Simpan Perubahan
                                    </button>
                                </div>
                                @error('adjQty') <span class="text-red-400 text-xs mt-1 block">{{ $message }}</span> @enderror
                                @error('adjNote') <span class="text-red-400 text-xs mt-1 block">{{ $message }}</span> @enderror
                            </div>

                            @if (session()->has('success'))
                                <div class="mt-4 bg-green-500/10 border border-green-500/20 text-green-400 px-4 py-2 rounded-lg text-sm">
                                    {{ session('success') }}
                                </div>
                            @endif

                            <div class="mt-6 overflow-hidden border border-slate-700 rounded-xl">
                                <table class="min-w-full divide-y divide-slate-700">
                                    <thead class="bg-slate-900">
                                        <tr>
                                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-slate-400 uppercase tracking-wider">Tanggal</th>
                                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-slate-400 uppercase tracking-wider">Tipe</th>
                                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-slate-400 uppercase tracking-wider">Perubahan</th>
                                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-slate-400 uppercase tracking-wider">Saldo Akhir</th>
                                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-slate-400 uppercase tracking-wider">User</th>
                                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-slate-400 uppercase tracking-wider">Catatan</th>
                                        </tr>
                                    </thead>
                                    <tbody class="bg-slate-800 divide-y divide-slate-700">
                                        @forelse($movements as $move)
                                            <tr class="hover:bg-slate-700/50 transition-colors">
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-slate-300">
                                                    {{ $move->created_at->format('d M Y H:i') }}
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm">
                                                    @if($move->reference_type === 'sale')
                                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-blue-100 text-blue-800">Penjualan</span>
                                                    @elseif($move->reference_type === 'purchase')
                                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">Pembelian</span>
                                                    @elseif($move->reference_type === 'adjustment')
                                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">Opname</span>
                                                    @else
                                                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-800">{{ ucfirst($move->reference_type) }}</span>
                                                    @endif
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm">
                                                    @if($move->quantity_change > 0)
                                                        <span class="text-green-400 font-bold">+{{ number_format($move->quantity_change) }}</span>
                                                    @elseif($move->quantity_change < 0)
                                                        <span class="text-red-400 font-bold">{{ number_format($move->quantity_change) }}</span>
                                                    @else
                                                        <span class="text-slate-400">0</span>
                                                    @endif
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-slate-300 font-mono">
                                                    {{ number_format($move->balance_after) }}
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-slate-400">
                                                    {{ $move->user->name ?? 'System' }}
                                                </td>
                                                <td class="px-6 py-4 whitespace-nowrap text-sm text-slate-400 italic">
                                                    {{ $move->notes ?? '-' }}
                                                </td>
                                            </tr>
                                        @empty
                                            <tr>
                                                <td colspan="6" class="px-6 py-10 text-center text-slate-500">
                                                    Belum ada riwayat pergerakan stok.
                                                </td>
                                            </tr>
                                        @endforelse
                                    </tbody>
                                </table>
                            </div>
                            
                            <div class="mt-4">
                                {{ $movements->links() }}
                            </div>
                        </div>
                    </div>
                </div>
                <div class="bg-slate-700/50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse border-t border-slate-700">
                    <button type="button" class="mt-3 w-full inline-flex justify-center rounded-md border border-slate-600 shadow-sm px-4 py-2 bg-slate-800 text-base font-medium text-white hover:bg-slate-700 focus:outline-none sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm transition-colors" wire:click="closeModal">
                        Tutup
                    </button>
                </div>
            </div>
        </div>
    </div>
    @endif
</div>
