<div class="bg-slate-800 rounded-xl shadow-lg border border-slate-700 overflow-hidden">
    <!-- Header -->
    <div class="p-6 border-b border-slate-700 flex flex-col md:flex-row justify-between items-center gap-4">
        <div>
            <h2 class="text-xl font-bold text-white">Purchase Orders</h2>
            <p class="text-sm text-slate-400">Track and manage procurement</p>
        </div>
        <a href="{{ route('purchase-orders.create') }}" class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-lg flex items-center gap-2 transition-colors">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
            Create PO
        </a>
    </div>

    <!-- Filters -->
    <div class="px-6 py-4 bg-slate-700/30 flex flex-col md:flex-row gap-4">
        <input wire:model.live.debounce.300ms="search" type="text" placeholder="Search PO Number or Supplier..." 
            class="w-full md:w-1/3 bg-slate-900 border border-slate-600 rounded-lg py-2 px-4 text-white focus:outline-none focus:border-indigo-500">
        
        <select wire:model.live="statusFilter" class="w-full md:w-1/4 bg-slate-900 border border-slate-600 rounded-lg py-2 px-4 text-white focus:outline-none focus:border-indigo-500">
            <option value="">All Statuses</option>
            <option value="draft">Draft</option>
            <option value="ordered">Ordered</option>
            <option value="received">Received</option>
            <option value="cancelled">Cancelled</option>
        </select>
    </div>

    <!-- Table -->
    <div class="overflow-x-auto">
        <table class="w-full text-left text-sm text-slate-300">
            <thead class="bg-slate-700/50 text-xs uppercase font-semibold text-slate-400">
                <tr>
                    <th class="px-6 py-4">PO Number</th>
                    <th class="px-6 py-4">Supplier</th>
                    <th class="px-6 py-4">Status</th>
                    <th class="px-6 py-4">Total Amount</th>
                    <th class="px-6 py-4">Dates</th>
                    <th class="px-6 py-4 text-center">Actions</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-slate-700">
                @forelse($orders as $po)
                    <tr class="hover:bg-slate-700/30 transition-colors">
                        <td class="px-6 py-4 font-mono font-medium text-white">{{ $po->po_number }}</td>
                        <td class="px-6 py-4">{{ $po->supplier->name }}</td>
                        <td class="px-6 py-4">
                            <span class="px-2 py-1 rounded text-xs font-bold uppercase
                                {{ $po->status === 'draft' ? 'bg-gray-500/20 text-gray-400' : '' }}
                                {{ $po->status === 'ordered' ? 'bg-blue-500/20 text-blue-400' : '' }}
                                {{ $po->status === 'received' ? 'bg-green-500/20 text-green-400' : '' }}
                                {{ $po->status === 'cancelled' ? 'bg-red-500/20 text-red-400' : '' }}
                            ">
                                {{ $po->status }}
                            </span>
                        </td>
                        <td class="px-6 py-4 font-mono text-white">Rp {{ number_format($po->total_amount, 0, ',', '.') }}</td>
                        <td class="px-6 py-4 text-xs text-slate-400">
                            <div>Created: {{ $po->created_at->format('d M Y') }}</div>
                            @if($po->expected_at)
                            <div>Exp: {{ $po->expected_at->format('d M Y') }}</div>
                            @endif
                        </td>
                        <td class="px-6 py-4 text-center">
                            <a href="{{ route('purchase-orders.edit', $po->id) }}" class="text-blue-400 hover:text-blue-300 mx-2">
                                {{ $po->status === 'draft' ? 'Edit' : 'View' }}
                            </a>
                        </td>
                    </tr>
                @empty
                    <tr><td colspan="6" class="px-6 py-8 text-center">No purchase orders found.</td></tr>
                @endforelse
            </tbody>
        </table>
    </div>

    <div class="px-6 py-4 border-t border-slate-700">
        {{ $orders->links() }}
    </div>
</div>
