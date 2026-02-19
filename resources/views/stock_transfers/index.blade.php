<x-layouts.dashboard>
    <div class="p-6" x-data="{ showModal: false }">
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold">Stock Transfers</h1>
            <button @click="showModal = true" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
                + New Transfer
            </button>
        </div>

        @if(session('success'))
            <div class="bg-green-100 text-green-700 p-3 rounded mb-4">{{ session('success') }}</div>
        @endif
        @if(session('error'))
            <div class="bg-red-100 text-red-700 p-3 rounded mb-4">{{ session('error') }}</div>
        @endif

        <div class="bg-white shadow rounded overflow-hidden">
            <table class="w-full text-left">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="p-3">Transfer #</th>
                        <th class="p-3">Source -> Dest</th>
                        <th class="p-3">Status</th>
                        <th class="p-3">Date Created</th>
                        <th class="p-3 text-right">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($transfers as $t)
                    <tr class="border-t">
                        <td class="p-3 font-bold">{{ $t->transfer_number }}</td>
                        <td class="p-3">{{ $t->sourceStore->name }} -> {{ $t->destStore->name }}</td>
                        <td class="p-3">
                            <span class="px-2 py-1 rounded text-xs uppercase font-bold
                                {{ $t->status == 'received' ? 'bg-green-100 text-green-800' : 
                                  ($t->status == 'in_transit' ? 'bg-blue-100 text-blue-800' : 'bg-yellow-100 text-yellow-800') }}">
                                {{ $t->status }}
                            </span>
                        </td>
                        <td class="p-3">{{ $t->created_at->format('d M Y') }}</td>
                        <td class="p-3 text-right space-x-2">
                            @if($t->status == 'pending')
                                <form action="{{ route('stock-transfers.ship', $t->id) }}" method="POST" class="inline">
                                    @csrf @method('PUT')
                                    <button class="text-blue-600 hover:underline">Ship</button>
                                </form>
                            @elseif($t->status == 'in_transit')
                                <form action="{{ route('stock-transfers.receive', $t->id) }}" method="POST" class="inline">
                                    @csrf @method('PUT')
                                    <button class="text-green-600 hover:underline">Receive</button>
                                </form>
                            @endif
                        </td>
                    </tr>
                    @empty
                    <tr><td colspan="5" class="p-4 text-center text-gray-500">No transfers found.</td></tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        <!-- Create Modal (Simplified) -->
        <div x-show="showModal" style="display: none;" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4">
            <div class="bg-white rounded max-w-lg w-full p-6">
                <h2 class="text-xl font-bold mb-4">New Transfer Request</h2>
                <form action="{{ route('stock-transfers.store') }}" method="POST">
                    @csrf
                    <div class="grid grid-cols-2 gap-4 mb-4">
                        <div>
                            <label class="block text-sm font-bold mb-1">Source Store</label>
                            <select name="source_store_id" class="w-full border p-2 rounded">
                                @foreach($stores as $s)
                                <option value="{{ $s->id }}">{{ $s->name }}</option>
                                @endforeach
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-bold mb-1">Dest Store</label>
                            <select name="dest_store_id" class="w-full border p-2 rounded">
                                @foreach($stores as $s)
                                <option value="{{ $s->id }}">{{ $s->name }}</option>
                                @endforeach
                            </select>
                        </div>
                    </div>
                    
                    <!-- Simplified Item Interface: Just enter ID and Qty for demo -->
                    <div class="mb-4 bg-gray-50 p-3 rounded">
                        <label class="block text-sm font-bold mb-2">Item (Product ID)</label>
                        <div class="flex gap-2">
                            <input type="number" name="items[0][product_id]" placeholder="Prod ID" class="border p-2 rounded w-1/2" required>
                            <input type="number" name="items[0][quantity]" placeholder="Qty" class="border p-2 rounded w-1/2" required>
                        </div>
                        <p class="text-xs text-gray-500 mt-1">For demo purposes, enter Product ID manually.</p>
                    </div>

                    <div class="mb-4">
                        <label class="block text-sm font-bold mb-1">Notes</label>
                        <textarea name="notes" class="w-full border p-2 rounded"></textarea>
                    </div>

                    <div class="flex justify-end gap-2">
                        <button type="button" @click="showModal = false" class="px-4 py-2 border rounded">Cancel</button>
                        <button type="submit" class="px-4 py-2 bg-blue-600 text-white rounded">Create Transfer</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</x-layouts.dashboard>
