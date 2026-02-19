@props(['recommendations'])

<div class="bg-white rounded-xl border border-gray-100 shadow-sm p-6">
    <div class="flex items-center justify-between mb-6">
        <div>
            <h3 class="text-lg font-bold text-gray-900">Smart Replenishment</h3>
            <p class="text-xs text-gray-500">Suggested reorders based on sales velocity</p>
        </div>
        <div class="h-8 w-8 bg-indigo-50 rounded-lg flex items-center justify-center">
            <svg class="h-5 w-5 text-indigo-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01" />
            </svg>
        </div>
    </div>

    <div class="space-y-6">
        @forelse($recommendations as $supplierId => $group)
            <div class="border rounded-lg overflow-hidden">
                <div class="bg-gray-50 px-4 py-2 flex items-center justify-between border-b">
                    <span class="text-sm font-bold text-gray-700">{{ $group['supplier_name'] }}</span>
                    <span class="text-[10px] bg-indigo-100 text-indigo-700 px-2 py-0.5 rounded-full">
                        {{ $group['total_items'] }} Items
                    </span>
                </div>
                <div class="divide-y">
                    @foreach($group['items'] as $item)
                        <div class="px-4 py-3 flex items-center justify-between">
                            <div>
                                <h4 class="text-sm font-medium text-gray-900">{{ $item['product_name'] }}</h4>
                                <div class="flex space-x-2 text-[10px] text-gray-500">
                                    <span>Stock: {{ number_format($item['current_stock']) }}</span>
                                    <span>•</span>
                                    <span>Sugg: +{{ $item['suggested_qty'] }}</span>
                                </div>
                            </div>
                            <div class="text-right">
                                <p class="text-[10px] text-gray-400">Velocity</p>
                                <p class="text-xs font-bold text-indigo-600">{{ number_format($item['avg_daily_sales'], 1) }}/day</p>
                            </div>
                        </div>
                    @endforeach
                </div>
                <div class="p-3 bg-white">
                    <button class="w-full py-2 bg-indigo-600 text-white text-xs font-bold rounded-lg hover:bg-indigo-700 transition-colors">
                        Generate PO Suggestion
                    </button>
                </div>
            </div>
        @empty
            <div class="py-12 text-center text-gray-400">
                <div class="text-3xl mb-2">📦</div>
                <p class="text-sm">All stock levels optimized.</p>
            </div>
        @endforelse
    </div>
</div>
