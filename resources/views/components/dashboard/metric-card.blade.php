@props(['title', 'value', 'change' => 0, 'icon' => null, 'isCurrency' => false])

@php
    $changeNumeric = (float) $change;
@endphp

<div class="bg-white overflow-hidden rounded-xl border border-gray-100 shadow-sm hover:shadow-md transition-shadow">
    <div class="p-5">
        <div class="flex items-center">
            <div class="flex-shrink-0">
                @if($icon)
                    <div class="rounded-md bg-indigo-50 p-3">
                        {!! $icon !!}
                    </div>
                @else
                    <div class="rounded-md bg-indigo-50 p-3">
                        <svg class="h-6 w-6 text-indigo-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                           <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" />
                        </svg>
                    </div>
                @endif
            </div>
            <div class="ml-5 w-0 flex-1">
                <dl>
                    <dt class="truncate text-sm font-medium text-gray-500">{{ $title }}</dt>
                    <dd>
                        <div class="text-2xl font-bold text-gray-900">
                            {{ $isCurrency ? 'Rp ' . number_format($value, 0, ',', '.') : number_format($value) }}
                        </div>
                    </dd>
                </dl>
            </div>
        </div>
    </div>
    <div class="bg-gray-50 px-5 py-3">
        <div class="text-sm">
            @if($changeNumeric > 0)
                <span class="flex items-center font-medium text-green-600">
                     <svg class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" />
                    </svg>
                    {{ $changeNumeric }}% Increase
                </span>
            @elseif($changeNumeric < 0)
                <span class="flex items-center font-medium text-red-600">
                    <svg class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 17h8m0 0V9m0 8l-8-8-4 4-6-6" />
                    </svg>
                    {{ abs($changeNumeric) }}% Decrease
                </span>
            @else
                <span class="flex items-center font-medium text-gray-500">
                    No change
                </span>
            @endif
        </div>
    </div>
</div>
