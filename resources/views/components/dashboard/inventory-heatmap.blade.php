@props(['stockData'])

<div class="bg-white rounded-xl border border-gray-100 shadow-sm overflow-hidden">
    <div class="p-6 border-b border-gray-50 flex items-center justify-between">
        <div>
            <h3 class="text-lg font-bold text-gray-900">Inventory Heatmap</h3>
            <p class="text-xs text-gray-500">Capital efficiency & stock velocity</p>
        </div>
        <div class="text-right">
            <p class="text-[10px] uppercase text-gray-400 font-bold tracking-wider">Capital Locked</p>
            <p class="text-lg font-black text-gray-900">Rp {{ number_format($stockData['total_capital_locked'], 0, ',', '.') }}</p>
        </div>
    </div>

    <div class="p-6">
        <div class="grid grid-cols-4 gap-4 mb-6">
            <div class="p-3 bg-red-50 rounded-lg border border-red-100">
                <p class="text-[10px] text-red-600 font-bold uppercase">Dead</p>
                <p class="text-xl font-bold text-red-900">{{ $stockData['summary']['dead'] }}</p>
            </div>
            <div class="p-3 bg-orange-50 rounded-lg border border-orange-100">
                <p class="text-[10px] text-orange-600 font-bold uppercase">Slow</p>
                <p class="text-xl font-bold text-orange-900">{{ $stockData['summary']['slow'] }}</p>
            </div>
            <div class="p-3 bg-blue-50 rounded-lg border border-blue-100">
                <p class="text-[10px] text-blue-600 font-bold uppercase">Medium</p>
                <p class="text-xl font-bold text-blue-900">{{ $stockData['summary']['medium'] }}</p>
            </div>
            <div class="p-3 bg-green-50 rounded-lg border border-green-100">
                <p class="text-[10px] text-green-600 font-bold uppercase">Fast</p>
                <p class="text-xl font-bold text-green-900">{{ $stockData['summary']['fast'] }}</p>
            </div>
        </div>

        <div class="space-y-3">
            <p class="text-xs font-bold text-gray-700 uppercase">Top Capital Traps (Dead Stock)</p>
            <div class="overflow-x-auto">
                <table class="w-full text-left text-xs">
                    <thead>
                        <tr class="text-gray-400 uppercase tracking-tighter">
                            <th class="pb-2 font-medium">Product</th>
                            <th class="pb-2 font-medium text-right">Units</th>
                            <th class="pb-2 font-medium text-right">Locked Capital</th>
                            <th class="pb-2 font-medium text-right">Age</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-50">
                        @foreach(collect($stockData['products'])->where('classification', 'dead')->sortByDesc('capital_locked')->take(5) as $item)
                            <tr>
                                <td class="py-2 font-bold text-gray-800">{{ $item['product']->name }}</td>
                                <td class="py-2 text-right">{{ $item['product']->stock }}</td>
                                <td class="py-2 text-right text-red-600">Rp {{ number_format($item['capital_locked'], 0, ',', '.') }}</td>
                                <td class="py-2 text-right text-gray-400">{{ $item['days_on_hand'] }}d</td>
                            </tr>
                        @endforeach
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
