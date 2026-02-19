<div class="bg-slate-800 rounded-xl shadow-lg border border-slate-700 overflow-hidden">
    <div class="p-6 border-b border-slate-700">
        <h2 class="text-xl font-bold text-white">{{ $isEditing ? 'Edit Purchase Order' : 'Create Purchase Order' }}</h2>
    </div>

    <div class="p-6 space-y-6">
        <!-- Top Form -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div>
                <label class="block text-sm text-slate-400 mb-1">Supplier</label>
                <select wire:model="supplier_id" class="w-full bg-slate-900 border border-slate-600 rounded-lg px-3 py-2 text-white focus:border-indigo-500">
                    <option value="">Select Supplier</option>
                    @foreach($suppliers as $supplier)
                        <option value="{{ $supplier->id }}">{{ $supplier->name }}</option>
                    @endforeach
                </select>
                @error('supplier_id') <span class="text-red-400 text-xs">{{ $message }}</span> @enderror
            </div>
            
            <div>
                <label class="block text-sm text-slate-400 mb-1">PO Number</label>
                <input wire:model="po_number" type="text" class="w-full bg-slate-900 border border-slate-600 rounded-lg px-3 py-2 text-white focus:border-indigo-500">
                @error('po_number') <span class="text-red-400 text-xs">{{ $message }}</span> @enderror
            </div>

            <div>
                <label class="block text-sm text-slate-400 mb-1">Status</label>
                <select wire:model="status" class="w-full bg-slate-900 border border-slate-600 rounded-lg px-3 py-2 text-white focus:border-indigo-500">
                    <option value="draft">Draft (Planning)</option>
                    <option value="ordered">Ordered (Sent to Supplier)</option>
                    <option value="received">Received (Stock Updated)</option>
                    <option value="cancelled">Cancelled</option>
                </select>
                @error('status') <span class="text-red-400 text-xs">{{ $message }}</span> @enderror
            </div>
            
            <div>
                <label class="block text-sm text-slate-400 mb-1">Order Date</label>
                <input wire:model="ordered_at" type="date" class="w-full bg-slate-900 border border-slate-600 rounded-lg px-3 py-2 text-white focus:border-indigo-500">
            </div>

             <div>
                <label class="block text-sm text-slate-400 mb-1">Expected Date</label>
                <input wire:model="expected_at" type="date" class="w-full bg-slate-900 border border-slate-600 rounded-lg px-3 py-2 text-white focus:border-indigo-500">
            </div>
        </div>

        <!-- Items Table -->
        <div class="border border-slate-700 rounded-lg overflow-hidden">
            <table class="w-full text-left text-sm text-slate-300">
                <thead class="bg-slate-700/50 text-xs uppercase font-semibold text-slate-400">
                    <tr>
                        <th class="px-4 py-2 w-1/3">Product</th>
                        <th class="px-4 py-2 w-24">Qty</th>
                        <th class="px-4 py-2 w-32">Unit Cost</th>
                        <th class="px-4 py-2 w-32 text-right">Total</th>
                        <th class="px-4 py-2 w-10"></th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-700">
                    @foreach($items as $index => $item)
                    <tr>
                        <td class="px-4 py-2 relative">
                            @if($item['product_id'])
                                <div class="flex justify-between items-center text-white font-medium">
                                    {{ $item['product_name'] }}
                                    <button wire:click="selectProduct({{ $index }}, '', '', 0)" class="text-xs text-slate-500 hover:text-red-400">Change</button>
                                </div>
                            @else
                                <div class="relative">
                                    <input type="text" wire:model.live.debounce.300ms="productSearch" wire:keyup="updatedProductSearch($event.target.value)" placeholder="Search product..." 
                                        class="w-full bg-slate-900/50 border border-slate-600 rounded px-2 py-1 text-white text-xs">
                                    
                                    @if(count($this->searchResults) > 0)
                                        <div class="absolute z-10 w-full bg-slate-800 border border-slate-600 rounded shadow-xl mt-1 max-h-48 overflow-y-auto">
                                            @foreach($searchResults as $result)
                                                <div wire:click="selectProduct({{ $index }}, {{ $result->id }}, '{{ addslashes($result->name) }}', {{ $result->cost_price }})" 
                                                    class="px-3 py-2 hover:bg-slate-700 cursor-pointer text-white">
                                                    {{ $result->name }} (Stock: {{ $result->stock }})
                                                </div>
                                            @endforeach
                                        </div>
                                    @endif
                                </div>
                            @endif
                            @error("items.{$index}.product_id") <span class="text-red-400 text-xs">Required</span> @enderror
                        </td>
                        <td class="px-4 py-2">
                            <input type="number" wire:model.live="items.{{ $index }}.quantity" wire:change="calculateRowTotal({{ $index }})" min="1"
                                class="w-full bg-slate-900 border border-slate-600 rounded px-2 py-1 text-white text-right">
                        </td>
                        <td class="px-4 py-2">
                            <input type="number" wire:model.live="items.{{ $index }}.unit_cost" wire:change="calculateRowTotal({{ $index }})" min="0"
                                class="w-full bg-slate-900 border border-slate-600 rounded px-2 py-1 text-white text-right">
                        </td>
                        <td class="px-4 py-2 text-right font-mono text-white">
                            {{ number_format($item['total_cost'], 0, ',', '.') }}
                        </td>
                        <td class="px-4 py-2 text-center">
                            <button wire:click="removeItem({{ $index }})" class="text-red-400 hover:text-red-300">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path></svg>
                            </button>
                        </td>
                    </tr>
                    @endforeach
                </tbody>
                <tfoot class="bg-slate-700/30">
                    <tr>
                        <td colspan="3" class="px-4 py-3 text-right font-bold text-white uppercase text-xs tracking-wider">Grand Total</td>
                        <td class="px-4 py-3 text-right font-bold text-indigo-400 font-mono text-lg">
                            Rp {{ number_format(collect($items)->sum('total_cost'), 0, ',', '.') }}
                        </td>
                        <td></td>
                    </tr>
                </tfoot>
            </table>
        </div>
        
        <button wire:click="addItem" class="text-sm text-indigo-400 hover:text-indigo-300 font-medium flex items-center gap-1">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
            Add Item
        </button>

        <!-- Notes -->
        <div>
            <label class="block text-sm text-slate-400 mb-1">Notes</label>
            <textarea wire:model="notes" class="w-full bg-slate-900 border border-slate-600 rounded-lg px-3 py-2 text-white focus:border-indigo-500" rows="3"></textarea>
        </div>

        <div class="flex justify-end gap-4 border-t border-slate-700 pt-6">
            <a href="{{ route('purchase-orders.index') }}" class="px-6 py-2 bg-slate-700 text-white rounded-lg hover:bg-slate-600">Cancel</a>
            <button wire:click="save" class="px-6 py-2 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 font-bold shadow-lg shadow-indigo-500/30">
                Save Purchase Order
            </button>
        </div>
    </div>
</div>
