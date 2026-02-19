<x-layouts.dashboard>
    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="flex justify-between items-center mb-6 px-6">
                <h2 class="text-2xl font-bold text-gray-800">Promotions & Discounts</h2>
                <a href="{{ route('promotions.create') }}" class="bg-indigo-600 text-white px-4 py-2 rounded-lg hover:bg-indigo-700">
                    + New Promotion
                </a>
            </div>

            <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg mx-6">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Name</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Value</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Scope</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Validity</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Status</th>
                            <th class="px-6 py-3 text-right text-xs font-bold text-gray-500 uppercase">Action</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        @forelse($promotions as $promo)
                        <tr>
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ $promo->name }}</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                                @if($promo->type == 'percentage')
                                    <span class="bg-blue-100 text-blue-800 px-2 py-1 rounded text-xs font-bold">{{ $promo->value }}% OFF</span>
                                @else
                                    <span class="bg-green-100 text-green-800 px-2 py-1 rounded text-xs font-bold">Rp {{ number_format($promo->value) }} OFF</span>
                                @endif
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                @if($promo->product)
                                    Producto: {{ $promo->product->name }}
                                @elseif($promo->category)
                                    Category: {{ $promo->category->name }}
                                @else
                                    All Items
                                @endif
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-xs text-gray-500">
                                {{ $promo->start_date->format('d M') }} - {{ $promo->end_date->format('d M Y') }}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full {{ $promo->is_active ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800' }}">
                                    {{ $promo->is_active ? 'Active' : 'Inactive' }}
                                </span>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                <a href="{{ route('promotions.edit', $promo) }}" class="text-indigo-600 hover:text-indigo-900 mr-2">Edit</a>
                            </td>
                        </tr>
                        @empty
                        <tr>
                            <td colspan="6" class="px-6 py-4 text-center text-gray-500">No active promotions related.</td>
                        </tr>
                        @endforelse
                    </tbody>
                </table>
                <div class="px-6 py-4">
                    {{ $promotions->links() }}
                </div>
            </div>
        </div>
    </div>
</x-layouts.dashboard>
