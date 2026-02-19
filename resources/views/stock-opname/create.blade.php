<x-layouts.dashboard>
    <div class="py-12" x-data="stockOpname()">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <h2 class="text-2xl font-bold mb-6 px-6">New Stock Audit</h2>

            <form action="{{ route('stock-opname.store') }}" method="POST">
                @csrf
                <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg p-6 mx-6 mb-6">
                    <div class="grid grid-cols-2 gap-6 mb-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700">Audit Date</label>
                            <input type="date" name="opname_date" value="{{ date('Y-m-d') }}" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm" required>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700">Notes</label>
                            <input type="text" name="notes" class="mt-1 block w-full rounded-md border-gray-300 shadow-sm">
                        </div>
                    </div>
                </div>

                <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg p-6 mx-6">
                    <h3 class="text-lg font-bold mb-4">Items to Audit</h3>
                    
                    <table class="min-w-full divide-y divide-gray-200 mb-4">
                        <thead>
                            <tr>
                                <th class="text-left font-bold text-gray-500 uppercase text-xs">Product</th>
                                <th class="text-left font-bold text-gray-500 uppercase text-xs w-32">Physical Count</th>
                                <th class="text-right font-bold text-gray-500 uppercase text-xs w-20">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <template x-for="(item, index) in items" :key="index">
                                <tr>
                                    <td class="py-2">
                                        <select :name="'items['+index+'][product_id]'" x-model="item.product_id" class="w-full rounded-md border-gray-300 shadow-sm text-sm">
                                            <option value="">Select Product...</option>
                                            @foreach($products as $product)
                                                <option value="{{ $product->id }}">{{ $product->name }} (System: {{ $product->stock }})</option>
                                            @endforeach
                                        </select>
                                    </td>
                                    <td class="py-2">
                                        <input type="number" :name="'items['+index+'][physical_stock]'" x-model="item.physical_stock" class="w-full rounded-md border-gray-300 shadow-sm text-sm" placeholder="Qty">
                                    </td>
                                    <td class="py-2 text-right">
                                        <button type="button" @click="removeItem(index)" class="text-red-600 hover:text-red-900 font-bold">&times;</button>
                                    </td>
                                </tr>
                            </template>
                        </tbody>
                    </table>

                    <button type="button" @click="addItem()" class="text-sm text-indigo-600 font-bold hover:underline mb-6">+ Add Item Row</button>

                    <div class="flex justify-end gap-3 border-t pt-4">
                        <a href="{{ route('stock-opname.index') }}" class="bg-gray-200 text-gray-700 px-4 py-2 rounded-lg hover:bg-gray-300">Cancel</a>
                        <button type="submit" class="bg-indigo-600 text-white px-4 py-2 rounded-lg hover:bg-indigo-700">Save Draft</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    @push('scripts')
    <script>
        document.addEventListener('alpine:init', () => {
             Alpine.data('stockOpname', () => ({
                items: [{ product_id: '', physical_stock: '' }],
                addItem() {
                    this.items.push({ product_id: '', physical_stock: '' });
                },
                removeItem(index) {
                    if(this.items.length > 1) {
                        this.items.splice(index, 1);
                    }
                }
             }));
        });
    </script>
    @endpush
</x-layouts.dashboard>
