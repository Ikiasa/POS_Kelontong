<x-layouts.dashboard>
    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="flex justify-between items-center mb-6 px-6">
                <h2 class="text-2xl font-bold text-gray-800">Expiring Batches (Next {{ $days }} Days)</h2>
                <form method="GET" class="flex gap-2">
                    <select name="days" class="rounded-md border-gray-300 shadow-sm text-sm" onchange="this.form.submit()">
                        <option value="30" {{ $days == 30 ? 'selected' : '' }}>Next 30 Days</option>
                        <option value="60" {{ $days == 60 ? 'selected' : '' }}>Next 60 Days</option>
                        <option value="90" {{ $days == 90 ? 'selected' : '' }}>Next 90 Days</option>
                    </select>
                </form>
            </div>

            <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg mx-6">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Product</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Batch Ref</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Qty Rem.</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Expiry Date</th>
                            <th class="px-6 py-3 text-left text-xs font-bold text-gray-500 uppercase">Status</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        @forelse($batches as $batch)
                        @php
                            $daysLeft = now()->diffInDays($batch->expiry_date, false);
                        @endphp
                        <tr class="{{ $daysLeft < 0 ? 'bg-red-50' : ($daysLeft < 7 ? 'bg-orange-50' : '') }}">
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ $batch->product->name }}</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ $batch->batch_number }}</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900 font-bold">{{ $batch->current_quantity }}</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-600">
                                {{ $batch->expiry_date->format('d M Y') }}
                                <span class="text-xs text-gray-400">({{ $daysLeft }} days)</span>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                @if($daysLeft < 0)
                                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">EXPIRED</span>
                                @elseif($daysLeft < 7)
                                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-orange-100 text-orange-800">CRITICAL</span>
                                @else
                                    <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">WARNING</span>
                                @endif
                            </td>
                        </tr>
                        @empty
                        <tr>
                            <td colspan="5" class="px-6 py-4 text-center text-gray-500">No expiring batches found within range.</td>
                        </tr>
                        @endforelse
                    </tbody>
                </table>
                <div class="px-6 py-4">
                    {{ $batches->appends(['days' => $days])->links() }}
                </div>
            </div>
        </div>
    </div>
</x-layouts.dashboard>
