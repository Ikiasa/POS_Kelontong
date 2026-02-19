<x-layouts.dashboard>
    <div class="p-6">
        <h1 class="text-2xl font-bold mb-6">Inventory Batch Management</h1>

        @if(session('success'))
            <div class="bg-green-100 text-green-700 p-3 rounded mb-4">{{ session('success') }}</div>
        @endif

        <!-- Receive Stock Form -->
        <div class="bg-white p-6 rounded shadow mb-8">
            <h2 class="text-lg font-bold mb-4">Receive New Stock (Add Batch)</h2>
            <form action="{{ route('batches.store') }}" method="POST" class="grid grid-cols-1 md:grid-cols-5 gap-4 items-end">
                @csrf
                <div class="md:col-span-2">
                    <label class="block text-sm font-bold mb-1">Product</label>
                    <select name="product_id" class="w-full border p-2 rounded" required>
                        <option value="">Select Product...</option>
                        @foreach($products as $p)
                            <option value="{{ $p->id }}">{{ $p->name }} (Current: {{ $p->stock }})</option>
                        @endforeach
                    </select>
                </div>
                <div>
                    <label class="block text-sm font-bold mb-1">Quantity</label>
                    <input type="number" name="quantity" class="w-full border p-2 rounded" min="1" required>
                </div>
                <div>
                    <label class="block text-sm font-bold mb-1">Cost Price (Per Unit)</label>
                    <input type="number" name="cost_price" class="w-full border p-2 rounded" min="0" step="100" required>
                </div>
                <div>
                    <label class="block text-sm font-bold mb-1">Expiry Date</label>
                    <input type="date" name="expiry_date" class="w-full border p-2 rounded">
                </div>
                <div class="md:col-span-5 text-right mt-2">
                    <button type="submit" class="bg-blue-600 text-white px-6 py-2 rounded hover:bg-blue-700">
                        Receive Stock
                    </button>
                </div>
            </form>
        </div>

        <!-- Active Batches List -->
        <div class="bg-white shadow rounded overflow-hidden">
            <div class="p-4 border-b">
                <h2 class="text-lg font-bold">Active Batches (FIFO Order)</h2>
            </div>
            <table class="w-full text-left">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="p-3">Batch #</th>
                        <th class="p-3">Product</th>
                        <th class="p-3">Expiry</th>
                        <th class="p-3 text-right">Cost</th>
                        <th class="p-3 text-right">Qty Rem.</th>
                        <th class="p-3 text-right">Total Value</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($products as $product)
                        @foreach($product->batches as $batch)
                        <tr class="border-t hover:bg-gray-50">
                            <td class="p-3 font-mono text-sm">{{ $batch->batch_number }}</td>
                            <td class="p-3 font-bold">{{ $product->name }}</td>
                            <td class="p-3 {{ $batch->expiry_date && $batch->expiry_date->isPast() ? 'text-red-600 font-bold' : '' }}">
                                {{ $batch->expiry_date ? $batch->expiry_date->format('Y-m-d') : '-' }}
                                @if($batch->expiry_date && $batch->expiry_date->isPast()) (EXPIRED) @endif
                            </td>
                            <td class="p-3 text-right">{{ number_format($batch->cost_price) }}</td>
                            <td class="p-3 text-right font-bold">{{ number_format($batch->current_quantity) }}</td>
                            <td class="p-3 text-right text-gray-500">{{ number_format($batch->current_quantity * $batch->cost_price) }}</td>
                        </tr>
                        @endforeach
                    @empty
                        <tr><td colspan="6" class="p-4 text-center">No batches found.</td></tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>
</x-layouts.dashboard>
