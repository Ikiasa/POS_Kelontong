<x-layouts.dashboard>
    <div class="p-6">
        <h1 class="text-2xl font-bold mb-6">Customer & Loyalty Management</h1>

        @if(session('success'))
            <div class="bg-green-100 text-green-700 p-3 rounded mb-4">{{ session('success') }}</div>
        @endif

        <div class="bg-white p-4 rounded shadow mb-6">
            <h2 class="text-lg font-bold mb-4">Add New Customer</h2>
            <form action="{{ route('customers.store') }}" method="POST" class="flex gap-4">
                @csrf
                <input type="text" name="name" placeholder="Name" class="border p-2 rounded flex-1" required>
                <input type="text" name="phone" placeholder="Phone (WhatsApp)" class="border p-2 rounded flex-1" required>
                <input type="email" name="email" placeholder="Email (Optional)" class="border p-2 rounded flex-1">
                <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded">Add Customer</button>
            </form>
        </div>

        <div class="bg-white shadow rounded overflow-hidden">
            <table class="w-full text-left">
                <thead class="bg-gray-50">
                    <tr>
                        <th class="p-3">Name</th>
                        <th class="p-3">Phone</th>
                        <th class="p-3">Tier</th>
                        <th class="p-3 text-right">Points Balance</th>
                        <th class="p-3">Last Visit</th>
                    </tr>
                </thead>
                <tbody>
                    @forelse($customers as $c)
                    <tr class="border-t hover:bg-gray-50">
                        <td class="p-3 font-bold">{{ $c->name }}</td>
                        <td class="p-3">{{ $c->phone }}</td>
                        <td class="p-3">
                            <span class="px-2 py-1 rounded text-xs uppercase font-bold 
                                {{ $c->tier == 'platinum' ? 'bg-purple-100 text-purple-800' : 
                                  ($c->tier == 'gold' ? 'bg-yellow-100 text-yellow-800' : 'bg-gray-100 text-gray-800') }}">
                                {{ $c->tier }}
                            </span>
                        </td>
                        <td class="p-3 text-right font-mono text-lg text-green-600">{{ number_format($c->points_balance) }}</td>
                        <td class="p-3 text-sm text-gray-500">{{ $c->last_visit_at ? $c->last_visit_at->diffForHumans() : '-' }}</td>
                    </tr>
                    @empty
                    <tr><td colspan="5" class="p-4 text-center text-gray-500">No customers found.</td></tr>
                    @endforelse
                </tbody>
            </table>
            <div class="p-4">
                {{ $customers->links() }}
            </div>
        </div>
    </div>
</x-layouts.dashboard>
