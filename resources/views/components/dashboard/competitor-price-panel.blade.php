@props(['pricingData'])

<div class="bg-white rounded-xl border border-gray-100 shadow-sm overflow-hidden">
    <div class="p-6 border-b border-gray-50 flex items-center justify-between bg-orange-50/30">
        <div>
            <h3 class="text-lg font-bold text-gray-900">Market Price Monitor</h3>
            <p class="text-xs text-gray-500">Comparison with local competitors</p>
        </div>
        <div class="h-8 w-8 bg-orange-100 rounded-lg flex items-center justify-center">
            <svg class="h-5 w-5 text-orange-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
            </svg>
        </div>
    </div>

    <div class="divide-y max-h-[400px] overflow-y-auto">
        @forelse($pricingData as $item)
            <div class="p-4 hover:bg-gray-50 transition-colors">
                <div class="flex items-center justify-between mb-2">
                    <div class="flex-1">
                        <h4 class="text-sm font-bold text-gray-900">{{ $item['product']->name }}</h4>
                        <p class="text-[10px] text-gray-400">vs {{ $item['competitor_name'] }}</p>
                    </div>
                    <div class="text-right">
                        <span @class([
                            'px-2 py-0.5 rounded-full text-[10px] font-bold uppercase',
                            'bg-red-100 text-red-700' => $item['status'] === 'overpriced',
                            'bg-green-100 text-green-700' => $item['status'] === 'underpriced',
                        ])>
                            {{ $item['status'] }}
                        </span>
                        <p @class([
                            'text-xs font-bold mt-1',
                            'text-red-600' => $item['diff_percentage'] > 0,
                            'text-green-600' => $item['diff_percentage'] < 0,
                        ])>
                            {{ $item['diff_percentage'] > 0 ? '+' : '' }}{{ $item['diff_percentage'] }}%
                        </p>
                    </div>
                </div>

                <div class="flex items-center justify-between mt-3 bg-gray-50 p-2 rounded-lg border border-gray-100">
                    <div class="text-center flex-1">
                        <p class="text-[9px] text-gray-400 uppercase">Your Price</p>
                        <p class="text-xs font-bold font-mono">Rp {{ number_format($item['internal_price'], 0, ',', '.') }}</p>
                    </div>
                    <div class="px-3">
                        <svg class="h-3 w-3 text-gray-300" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 5l7 7-7 7M5 5l7 7-7 7" />
                        </svg>
                    </div>
                    <div class="text-center flex-1">
                        <p class="text-[9px] text-gray-400 uppercase">Market Avg</p>
                        <p class="text-xs font-bold font-mono">Rp {{ number_format($item['competitor_price'], 0, ',', '.') }}</p>
                    </div>
                </div>

                @if($item['status'] === 'overpriced')
                    <div class="mt-3 p-2 bg-red-50/50 rounded-lg text-[10px] text-red-700 border border-red-100">
                        <p><strong>Impact:</strong> Price match would reduce margin by <strong>{{ $item['margin_impact']['new_margin_percentage'] }}%</strong>. Consider if volume increase offsets margin loss.</p>
                    </div>
                @else
                    <div class="mt-3 p-2 bg-green-50/50 rounded-lg text-[10px] text-green-700 border border-green-100">
                        <p><strong>Opportunity:</strong> Price match would increase profit by <strong>Rp {{ number_format(abs($item['margin_impact']['per_unit']), 0) }}</strong> per unit.</p>
                    </div>
                @endif
            </div>
        @empty
            <div class="py-12 text-center text-gray-400">
                <p class="text-xs italic">Pricing is competitive across all monitored items.</p>
            </div>
        @endforelse
    </div>
</div>
