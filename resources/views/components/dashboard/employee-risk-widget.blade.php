@props(['riskScores'])

<div class="bg-white rounded-xl border border-gray-100 shadow-sm overflow-hidden">
    <div class="p-6 border-b border-gray-50 flex items-center justify-between bg-gray-50/50">
        <div>
            <h3 class="text-lg font-bold text-gray-900">Employee Behavior Monitor</h3>
            <p class="text-xs text-gray-500">Risk profiles based on operational patterns</p>
        </div>
        <div class="h-8 w-8 bg-red-50 rounded-lg flex items-center justify-center">
            <svg class="h-5 w-5 text-red-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
            </svg>
        </div>
    </div>

    <div class="divide-y">
        @forelse($riskScores as $score)
            <div class="p-4 hover:bg-gray-50 transition-colors">
                <div class="flex items-center justify-between mb-2">
                    <div class="flex items-center space-x-3">
                        <div class="h-10 w-10 rounded-full bg-indigo-100 flex items-center justify-center text-indigo-700 font-bold">
                            {{ substr($score->user->name, 0, 2) }}
                        </div>
                        <div>
                            <p class="text-sm font-bold text-gray-900">{{ $score->user->name }}</p>
                            <p class="text-[10px] text-gray-500 uppercase tracking-wider">{{ $score->user->role ?? 'Cashier' }}</p>
                        </div>
                    </div>
                    <div class="text-right">
                        <span @class([
                            'px-2 py-1 rounded-full text-[10px] font-bold uppercase',
                            'bg-green-100 text-green-700' => $score->risk_level === 'low',
                            'bg-yellow-100 text-yellow-700' => $score->risk_level === 'medium',
                            'bg-orange-100 text-orange-700' => $score->risk_level === 'high',
                            'bg-red-100 text-red-700 animate-pulse' => $score->risk_level === 'critical',
                        ])>
                            {{ $score->risk_level }}
                        </span>
                        <p class="text-xs font-bold text-gray-900 mt-1">{{ round($score->risk_score) }}% Risk</p>
                    </div>
                </div>

                <div class="grid grid-cols-3 gap-2 mt-3">
                    <div class="text-center p-2 bg-gray-50 rounded-lg">
                        <p class="text-[9px] text-gray-400">Voids</p>
                        <p class="text-xs font-bold">{{ $score->indicators['voids']['count'] }}</p>
                    </div>
                    <div class="text-center p-2 bg-gray-50 rounded-lg">
                        <p class="text-[9px] text-gray-400">Variance</p>
                        <p class="text-xs font-bold">Rp {{ number_format($score->indicators['variance']['amount'], 0, ',', '.') }}</p>
                    </div>
                    <div class="text-center p-2 bg-gray-50 rounded-lg">
                        <p class="text-[9px] text-gray-400">Overrides</p>
                        <p class="text-xs font-bold">{{ $score->indicators['price_edits']['count'] }}</p>
                    </div>
                </div>
            </div>
        @empty
            <div class="py-12 text-center text-gray-400">
                <p>No high-risk activity detected.</p>
            </div>
        @endforelse
    </div>

    @if(count($riskScores) > 0)
        <div class="p-3 bg-gray-50 text-center">
            <button class="text-xs font-bold text-indigo-600 hover:text-indigo-800">View Full Audit History</button>
        </div>
    @endif
</div>
