@props(['riskScore'])

@php
    $score = $riskScore->risk_score ?? 0;
    $isHigh = $score > 30;
@endphp

<div class="bg-white rounded-xl border {{ $isHigh ? 'border-red-200 bg-red-50/10' : 'border-gray-100 shadow-sm' }} p-6">
    <div class="flex items-center justify-between mb-4">
        <h3 class="text-lg font-bold text-gray-900">Profit Leak Detector</h3>
        @if($isHigh)
            <span class="animate-pulse flex h-3 w-3 rounded-full bg-red-400 opacity-75"></span>
        @endif
    </div>

    <div class="flex items-center space-x-4 mb-6">
        <div class="flex-shrink-0 w-16 h-16 rounded-full border-4 {{ $isHigh ? 'border-red-500' : 'border-green-500' }} flex items-center justify-center">
            <span class="text-xl font-bold text-gray-900">{{ $score }}%</span>
        </div>
        <div>
            <p class="text-sm font-medium text-gray-900">Risk Threshold</p>
            <p class="text-xs text-gray-500">{{ $isHigh ? 'High probability of revenue loss' : 'Low risk detected' }}</p>
        </div>
    </div>

    <div class="space-y-4">
        @foreach($riskScore->indicators as $key => $count)
            @if($count > 0)
                <div class="flex items-start bg-white p-3 rounded-lg border border-gray-100 shadow-sm">
                    <div class="flex-shrink-0 mt-0.5">
                        <svg class="h-5 w-5 text-red-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                        </svg>
                    </div>
                    <div class="ml-3">
                        <h4 class="text-xs font-bold text-gray-900 capitalize">{{ str_replace('_', ' ', $key) }}</h4>
                        <p class="text-[10px] text-gray-500">{{ $count }} occurrences detected today.</p>
                    </div>
                </div>
            @endif
        @endforeach
    </div>

    @if(!$isHigh)
        <div class="mt-4 flex items-center justify-center py-8">
            <svg class="h-12 w-12 text-green-100" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M2.166 4.9L9.03 17.003c.456.811 1.623.811 2.08 0L18 4.9a1 1 0 00-1.732-1L10 16.01 3.898 3.9a1 1 0 00-1.732 1z" clip-rule="evenodd" />
            </svg>
        </div>
    @endif
</div>
