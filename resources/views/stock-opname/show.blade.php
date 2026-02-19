<x-layouts.dashboard>
    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="flex justify-between items-center mb-6 px-6">
                <div>
                    <h2 class="text-2xl font-bold text-gray-800">Audit Reference: {{ $stockOpname->reference_number }}</h2>
                    <p class="text-sm text-gray-500">Date: {{ $stockOpname->opname_date->format('d M Y') }} | Status: <span class="uppercase font-bold">{{ $stockOpname->status }}</span></p>
                </div>
                
                @if($stockOpname->status === 'draft')
                <form action="{{ route('stock-opname.adjust', $stockOpname) }}" method="POST" onsubmit="return confirm('This will update actual product stock. Continue?');">
                    @csrf
                    @method('POST')
                    <button type="submit" class="bg-green-600 text-white px-4 py-2 rounded-lg hover:bg-green-700 font-bold">
                        Confirm Adjustments
                    </button>
                </form>
                @endif
            </div>

            <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg mx-6 p-6">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead>
                        <tr>
                            <th class="text-left text-xs font-bold text-gray-500 uppercase">Product</th>
                            <th class="text-left text-xs font-bold text-gray-500 uppercase">System Stock</th>
                            <th class="text-left text-xs font-bold text-gray-500 uppercase">Physical Count</th>
                            <th class="text-left text-xs font-bold text-gray-500 uppercase">Difference</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-200">
                        @foreach($stockOpname->items as $item)
                        <tr class="{{ $item->difference != 0 ? 'bg-orange-50' : '' }}">
                            <td class="py-3 text-sm font-medium text-gray-900">{{ $item->product->name }}</td>
                            <td class="py-3 text-sm text-gray-500">{{ $item->system_stock }}</td>
                            <td class="py-3 text-sm font-bold text-gray-900">{{ $item->physical_stock }}</td>
                            <td class="py-3 text-sm font-bold {{ $item->difference < 0 ? 'text-red-600' : ($item->difference > 0 ? 'text-green-600' : 'text-gray-400') }}">
                                {{ $item->difference > 0 ? '+' : '' }}{{ $item->difference }}
                            </td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</x-layouts.dashboard>
