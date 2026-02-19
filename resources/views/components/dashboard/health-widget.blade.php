@props(['healthScore'])

@php
    $score = $healthScore->score ?? 0;
    $color = $score > 80 ? 'green' : ($score > 40 ? 'yellow' : 'red');
@endphp

<div class="bg-white rounded-xl border border-gray-100 shadow-sm p-6">
    <div class="flex items-center justify-between mb-4">
        <h3 class="text-lg font-bold text-gray-900">Business Health</h3>
        <span class="px-3 py-1 rounded-full text-xs font-medium bg-{{ $color }}-100 text-{{ $color }}-800">
            {{ $score > 80 ? 'Stable' : ($score > 40 ? 'Warning' : 'Critical') }}
        </span>
    </div>

    <div class="relative pt-1">
        <div class="flex mb-2 items-center justify-between">
            <div>
                <span class="text-xs font-semibold inline-block py-1 px-2 uppercase rounded-full text-{{ $color }}-600 bg-{{ $color }}-200">
                    Overall Score
                </span>
            </div>
            <div class="text-right">
                <span class="text-xl font-bold inline-block text-{{ $color }}-600">
                    {{ $score }}%
                </span>
            </div>
        </div>
        <div class="overflow-hidden h-4 mb-4 text-xs flex rounded bg-{{ $color }}-200">
            <div style="width:{{ $score }}%" class="shadow-none flex flex-col text-center whitespace-nowrap text-white justify-center bg-{{ $color }}-500"></div>
        </div>
    </div>

    <div class="mt-4 space-y-3">
        @foreach($healthScore->breakdown as $key => $subScore)
            <div class="flex items-center justify-between">
                <span class="text-sm text-gray-500 capitalize">{{ str_replace('_', ' ', $key) }}</span>
                <span class="text-sm font-medium {{ $subScore > 70 ? 'text-green-600' : ($subScore > 40 ? 'text-yellow-600' : 'text-red-600') }}">
                    {{ $subScore }}%
                </span>
            </div>
        @endforeach
    </div>

    @if($healthScore->explanation)
        <div class="mt-4 p-3 bg-gray-50 rounded-lg border border-gray-200">
            <p class="text-xs text-gray-600 italic">
                <span class="font-bold">Insight:</span> {{ $healthScore->explanation }}
            </p>
        </div>
    @endif
</div>
