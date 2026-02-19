<x-layouts.dashboard>
    <div class="mb-8 flex justify-between items-center">
        <div>
            <h2 class="text-2xl font-bold text-gray-800">Overview</h2>
            <p class="text-gray-500 text-sm">Real-time performance for {{ now()->format('F Y') }}</p>
        </div>
        <div class="flex gap-2 text-xs">
            <span class="px-3 py-1 bg-green-100 text-green-800 rounded-full font-bold">Store: {{ auth()->user()->store_id ?? 'Main' }}</span>
        </div>
    </div>

    <!-- Metrics Grid -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <x-dashboard.metric-card 
            title="Today's Sales" 
            :value="$todaySales" 
            :change="0" 
            :isCurrency="true"
        >
             <x-slot:icon>
                <svg class="h-6 w-6 text-indigo-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
             </x-slot:icon>
        </x-dashboard.metric-card>

        <x-dashboard.metric-card 
            title="Active Products" 
            :value="$totalProducts" 
            :change="0" 
            :isCurrency="false"
        >
            <x-slot:icon>
                <svg class="h-6 w-6 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
                </svg>
            </x-slot:icon>
        </x-dashboard.metric-card>

        <x-dashboard.metric-card 
            title="Customer Base" 
            :value="$totalCustomers" 
            :change="0" 
            :isCurrency="false"
        >
            <x-slot:icon>
                <svg class="h-6 w-6 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                </svg>
            </x-slot:icon>
        </x-dashboard.metric-card>
        
        <x-dashboard.metric-card 
            title="Backups Created" 
            :value="$backupCount" 
            :change="0" 
            :isCurrency="false"
        >
            <x-slot:icon>
                <svg class="h-6 w-6 text-orange-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 7v10c0 2 1.5 3 3.5 3h9c2 0 3.5-1 3.5-3V7c0-2-1.5-3-3.5-3h-9C5.5 4 4 5 4 7z" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4" />
                </svg>
            </x-slot:icon>
        </x-dashboard.metric-card>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 mb-8">
        <div class="lg:col-span-2 space-y-8">
            <!-- Sales Chart -->
            <div class="bg-white p-6 rounded-xl border border-gray-100 shadow-sm">
                <h3 class="text-lg font-bold text-gray-800 mb-4">Daily Sales Performance</h3>
                <div class="relative h-72">
                    @if(count($salesHistory) > 0)
                        <canvas id="salesChart"></canvas>
                    @else
                        <div class="flex items-center justify-center h-full text-gray-400">No sales data for past 7 days</div>
                    @endif
                </div>
            </div>
            
            <!-- Cashflow Projection -->
            <x-dashboard.cashflow-chart :projections="$cashflowProjections" />

            <!-- Inventory Heatmap (Phase 17) -->
            <x-dashboard.inventory-heatmap :stockData="$stockData" />
        </div>
        
        <!-- Security & Intelligence -->
        <div class="space-y-6">
            <!-- System Alerts (Phase 19) -->
            <x-dashboard.alert-center :alerts="$alerts" />

            <!-- AI Sales Advisor -->
            @if(count($aiInsights) > 0)
                <div class="mb-4">
                    <h3 class="text-lg font-bold text-gray-800 flex items-center gap-2">
                        <span>🤖 Asisten Penjualan Cerdas</span>
                        <span class="text-xs bg-indigo-100 text-indigo-700 px-2 py-0.5 rounded-full">AI Powered</span>
                    </h3>
                </div>
                <x-dashboard.insight-panel :insights="$aiInsights" />
            @endif

            <!-- Competitor Price Monitor (Phase 18) -->
            <x-dashboard.competitor-price-panel :pricingData="$pricingData" />

            <!-- Business Health Score -->
            @if($healthScore)
                <x-dashboard.health-widget :healthScore="$healthScore" />
            @else
                <div class="bg-gray-50 border border-dashed border-gray-200 p-6 rounded-xl text-center text-gray-500">
                    <p class="text-sm italic">Score calculation pending...</p>
                </div>
            @endif

            <!-- Profit Leak Risk -->
            @if($riskScore)
                <x-dashboard.leak-warning-panel :riskScore="$riskScore" />
            @else
                <div class="bg-gray-50 border border-dashed border-gray-200 p-6 rounded-xl text-center text-gray-500">
                    <p class="text-sm italic">Risk analysis pending...</p>
                </div>
            @endif

            <!-- Existing Security Alerts -->
            <div class="bg-white p-6 rounded-xl border border-gray-100 shadow-sm">
                <h3 class="text-lg font-bold text-gray-800 mb-2 flex items-center justify-between">
                    <span>Security Alerts</span>
                    <span class="text-xs bg-red-100 text-red-700 px-2 py-0.5 rounded-full">{{ count($pendingAlerts) }}</span>
                </h3>
                <div class="divide-y text-sm">
                    @forelse($pendingAlerts as $alert)
                        <div class="py-3">
                            <p class="font-bold text-gray-900 line-clamp-1">{{ $alert->reason }}</p>
                            <p class="text-xs text-gray-500 uppercase">{{ $alert->severity }} • {{ $alert->created_at->diffForHumans() }}</p>
                        </div>
                    @empty
                        <div class="py-6 text-center text-gray-400">
                             <div class="text-2xl mb-1">🛡️</div>
                             System Secure
                        </div>
                    @endforelse
                </div>
            </div>

            <!-- Smart Replenishment Recommendations -->
            <x-dashboard.reorder-panel :recommendations="$recommendations" />

            <!-- Employee Risk Monitoring (Owner/Admin Only) -->
            @if(count($employeeRisks) > 0)
                <x-dashboard.employee-risk-widget :riskScores="$employeeRisks" />
            @endif

            <!-- Health Status -->
            <div class="bg-white p-6 rounded-xl border border-gray-100 shadow-sm">
                <h3 class="text-lg font-bold text-gray-800 mb-4">System Health</h3>
                <div class="space-y-3">
                    <div class="flex items-center justify-between text-sm">
                        <span class="text-gray-600">Sync Status</span>
                        <span class="text-green-600 font-bold">Synchronized</span>
                    </div>
                    <div class="flex items-center justify-between text-sm">
                        <span class="text-gray-600">Connectivity</span>
                        <span class="text-green-600 font-bold">Active</span>
                    </div>
                    <div class="flex items-center justify-between text-sm">
                        <span class="text-gray-600">Database</span>
                        <span class="text-green-600 font-bold">Stable</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    @push('scripts')
    @if(count($salesHistory) > 0)
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const salesCtx = document.getElementById('salesChart').getContext('2d');
            new Chart(salesCtx, {
                type: 'line',
                data: {
                    labels: {!! json_encode(array_keys($salesHistory)) !!},
                    datasets: [{
                        label: 'Revenue',
                        data: {!! json_encode(array_values($salesHistory)) !!},
                        borderColor: 'rgb(79, 70, 229)',
                        backgroundColor: 'rgba(79, 70, 229, 0.1)',
                        fill: true,
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false }
                    },
                    scales: {
                        y: { beginAtZero: true, ticks: { callback: (val) => 'Rp ' + val/1000 + 'k' } }
                    }
                }
            });
        });
    </script>
    @endif
    @endpush
</x-layouts.dashboard>
