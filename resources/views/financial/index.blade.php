<x-layouts.dashboard>
    <div class="p-6">
        <h1 class="text-2xl font-bold mb-6">Financial Control & Cash Management</h1>

        <!-- Aging Report -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
            @foreach($agingReport as $range => $amount)
            <div class="bg-white p-4 rounded shadow border-l-4 {{ $loop->first ? 'border-green-500' : 'border-red-500' }}">
                <h3 class="text-gray-500 text-sm font-bold uppercase">{{ $range }} Days</h3>
                <p class="text-2xl font-bold">Rp {{ number_format($amount, 0) }}</p>
            </div>
            @endforeach
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
            
            <!-- Installments -->
            <div class="bg-white p-6 rounded shadow">
                <h2 class="text-xl font-bold mb-4">Overdue Installments</h2>
                <div class="overflow-x-auto">
                    <table class="w-full text-sm text-left">
                        <thead class="bg-gray-50 uppercase text-xs">
                            <tr>
                                <th class="p-2">Due Date</th>
                                <th class="p-2">Customer</th>
                                <th class="p-2 text-right">Amount</th>
                                <th class="p-2 text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            @forelse($overdueInstallments as $inst)
                            <tr class="border-b hover:bg-gray-50">
                                <td class="p-2 text-red-600 font-bold">{{ $inst->due_date }}</td>
                                <td class="p-2">{{ $inst->transaction->user->name ?? 'Guest' }}</td>
                                <td class="p-2 text-right">Rp {{ number_format($inst->amount - $inst->paid_amount, 0) }}</td>
                                <td class="p-2 text-center">
                                    <form action="{{ route('installments.pay', $inst->id) }}" method="POST" class="inline">
                                        @csrf
                                        <input type="hidden" name="amount" value="{{ $inst->amount - $inst->paid_amount }}">
                                        <button class="bg-blue-600 text-white px-3 py-1 rounded hover:bg-blue-700">Pay</button>
                                    </form>
                                </td>
                            </tr>
                            @empty
                            <tr><td colspan="4" class="p-4 text-center text-gray-500">No overdue installments.</td></tr>
                            @endforelse
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Budgets -->
            <div class="bg-white p-6 rounded shadow">
                <h2 class="text-xl font-bold mb-4">Budget Monitoring (Current Month)</h2>
                <div class="space-y-4">
                    @foreach($budgetStatus as $b)
                    <div>
                        <div class="flex justify-between mb-1">
                            <span class="font-medium">{{ $b['category'] }}</span>
                            <span class="text-sm {{ $b['status'] == 'over' ? 'text-red-600 font-bold' : 'text-gray-600' }}">
                                {{ $b['percentage'] }}% ({{ number_format($b['remaining']) }} left)
                            </span>
                        </div>
                        <div class="w-full bg-gray-200 rounded-full h-2.5">
                            <div class="bg-{{ $b['status'] == 'over' ? 'red' : ($b['status'] == 'warning' ? 'yellow' : 'green') }}-600 h-2.5 rounded-full" style="width: {{ min($b['percentage'], 100) }}%"></div>
                        </div>
                    </div>
                    @endforeach
                    @if(empty($budgetStatus))
                        <p class="text-gray-500 text-center">No active budgets found.</p>
                    @endif
                </div>
            </div>

        </div>
    </div>
</x-layouts.dashboard>
