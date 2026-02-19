<x-layouts.dashboard>
    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg p-6">
                <div class="flex justify-between items-center mb-6">
                    <h2 class="text-2xl font-bold text-gray-800">Tax & Accounting Summary</h2>
                    <a href="{{ route('reports.journal-export') }}" class="bg-indigo-600 text-white px-4 py-2 rounded-lg hover:bg-indigo-700 transition">
                        Export Journal (CSV)
                    </a>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div class="bg-blue-50 p-6 rounded-xl border border-blue-100">
                        <p class="text-sm text-blue-600 font-medium uppercase tracking-wider mb-1">Total PPN (11%) Collected</p>
                        <p class="text-3xl font-bold text-blue-900">Rp {{ number_format($taxData->total_ppn, 0, ',', '.') }}</p>
                        <p class="text-xs text-blue-500 mt-2 italic">Liability to be submitted</p>
                    </div>

                    <div class="bg-green-50 p-6 rounded-xl border border-green-100">
                        <p class="text-sm text-green-600 font-medium uppercase tracking-wider mb-1">Total Service Income</p>
                        <p class="text-3xl font-bold text-green-900">Rp {{ number_format($taxData->total_service, 0, ',', '.') }}</p>
                        <p class="text-xs text-green-500 mt-2 italic">Operating revenue</p>
                    </div>

                    <div class="bg-purple-50 p-6 rounded-xl border border-purple-100">
                        <p class="text-sm text-purple-600 font-medium uppercase tracking-wider mb-1">Gross Revenue (Inc. Tax)</p>
                        <p class="text-3xl font-bold text-purple-900">Rp {{ number_format($taxData->total_gross, 0, ',', '.') }}</p>
                        <p class="text-xs text-purple-500 mt-2 italic">Total sales volume</p>
                    </div>
                </div>

                <div class="mt-8 bg-gray-50 p-4 rounded-lg border border-gray-200">
                    <h3 class="font-bold text-gray-700 mb-2">PPh Final UMKM Projection (0.5%)</h3>
                    <p class="text-lg text-gray-900">
                        Estimated Tax: <span class="font-bold text-red-600">Rp {{ number_format($taxData->total_gross * 0.005, 0, ',', '.') }}</span>
                    </p>
                    <p class="text-sm text-gray-500 mt-1">Based on Government Regulation (PP) No. 23/2018.</p>
                </div>
            </div>
        </div>
    </div>
</x-layouts.app>
