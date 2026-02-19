<x-layouts.dashboard>
    <div class="max-w-md mx-auto bg-white p-8 rounded shadow mt-10">
        <h2 class="text-2xl font-bold mb-6 text-center">Cash Drawer Management</h2>

        @if(session('error'))
            <div class="bg-red-100 text-red-700 p-3 rounded mb-4">{{ session('error') }}</div>
        @endif

        @if(!$current)
            <!-- Open Drawer Form -->
            <form action="{{ route('cash-drawer.open') }}" method="POST">
                @csrf
                <div class="mb-4">
                    <label class="block text-gray-700 font-bold mb-2">Opening Cash Balance</label>
                    <input type="number" name="opening_balance" class="w-full border p-2 rounded" required step="100">
                </div>
                <div class="mb-6">
                    <label class="block text-gray-700 mb-2">Notes (Optional)</label>
                    <textarea name="notes" class="w-full border p-2 rounded"></textarea>
                </div>
                <button type="submit" class="w-full bg-green-600 text-white font-bold py-2 rounded hover:bg-green-700">
                    Open Drawer & Start POS
                </button>
            </form>
        @else
            <!-- Close Drawer Form -->
            <div class="bg-blue-50 p-4 mb-6 rounded">
                <p><strong>Drawer Opened At:</strong> {{ $current->opened_at }}</p>
                <p><strong>Opening Balance:</strong> Rp {{ number_format($current->opening_balance, 0) }}</p>
            </div>

            <form action="{{ route('cash-drawer.close', $current->id) }}" method="POST">
                @csrf
                @method('PUT')
                <div class="mb-4">
                    <label class="block text-gray-700 font-bold mb-2">Closing Cash Count (Actual)</label>
                    <input type="number" name="closing_balance" class="w-full border p-2 rounded" required step="100">
                </div>
                <div class="mb-6">
                    <label class="block text-gray-700 mb-2">Notes (Optional)</label>
                    <textarea name="notes" class="w-full border p-2 rounded"></textarea>
                </div>
                <button type="submit" class="w-full bg-red-600 text-white font-bold py-2 rounded hover:bg-red-700">
                    Close Drawer & Ends Session
                </button>
            </form>
        @endif
    </div>
</x-layouts.dashboard>
