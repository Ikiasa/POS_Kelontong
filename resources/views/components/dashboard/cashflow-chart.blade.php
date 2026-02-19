@props(['projections'])

    <div class="flex items-center justify-between mb-6">
        <div>
            <h3 class="text-lg font-bold text-gray-900">30-Day Cashflow Projection</h3>
            <p class="text-xs text-gray-500">Forecasting liquidity based on sales trends and commitments</p>
        </div>
        <div class="flex flex-col items-end space-y-2">
            <div class="flex space-x-2">
                <span class="flex items-center text-xs text-green-600 font-medium">
                    <span class="w-2 h-2 bg-green-500 rounded-full mr-1"></span> In
                </span>
                <span class="flex items-center text-xs text-red-600 font-medium">
                    <span class="w-2 h-2 bg-red-500 rounded-full mr-1"></span> Out
                </span>
            </div>
            <div class="flex space-x-1" id="simulation-controls">
                <button onclick="simulate(0)" class="px-2 py-0.5 text-[9px] bg-gray-100 rounded border hover:bg-gray-200">Baseline</button>
                <button onclick="simulate(10)" class="px-2 py-0.5 text-[9px] bg-blue-50 text-blue-600 rounded border border-blue-100 hover:bg-blue-100">+10% Sales</button>
                <button onclick="simulate(20)" class="px-2 py-0.5 text-[9px] bg-green-50 text-green-600 rounded border border-green-100 hover:bg-green-100">+20% Sales</button>
            </div>
        </div>
    </div>

    @php
        $hasRisk = collect($projections)->contains(fn($p) => $p['net_balance'] < 0);
    @endphp

    @if($hasRisk)
        <div class="mb-4 p-3 bg-red-50 border border-red-100 rounded-lg flex items-center space-x-2">
            <svg class="h-4 w-4 text-red-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
            </svg>
            <span class="text-[10px] font-bold text-red-700 uppercase tracking-wider">Liquidity Risk: Negative cashflow projected in the next 30 days</span>
        </div>
    @endif

    <div class="relative h-64 mb-6">
        <canvas id="cashflowProjectionChart"></canvas>
    </div>

    <div class="grid grid-cols-3 gap-4 border-t pt-6">
        <div>
            <p class="text-[10px] text-gray-400 uppercase font-bold">Total Incoming</p>
            <p class="text-sm font-bold text-green-600">Rp {{ number_format(collect($projections)->sum('projected_incoming'), 0, ',', '.') }}</p>
        </div>
        <div>
            <p class="text-[10px] text-gray-400 uppercase font-bold">Total Outgoing</p>
            <p class="text-sm font-bold text-red-600">Rp {{ number_format(collect($projections)->sum('projected_outgoing'), 0, ',', '.') }}</p>
        </div>
        <div>
            <p class="text-[10px] text-gray-400 uppercase font-bold">Net Runway</p>
            <p class="text-sm font-bold text-indigo-600">Rp {{ number_format(collect($projections)->sum('net_balance'), 0, ',', '.') }}</p>
        </div>
    </div>
</div>

@push('scripts')
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const ctx = document.getElementById('cashflowProjectionChart').getContext('2d');
        const projections = {!! json_encode($projections) !!};
        
        window.cashflowChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: projections.map(p => {
                    const d = new Date(p.projection_date);
                    return d.toLocaleDateString('id-ID', { day: 'numeric', month: 'short' });
                }),
                datasets: [
                    {
                        label: 'Incoming',
                        data: projections.map(p => p.projected_incoming),
                        backgroundColor: 'rgba(34, 197, 94, 0.6)',
                        borderColor: 'rgb(34, 197, 94)',
                        borderWidth: 1
                    },
                    {
                        label: 'Outgoing',
                        data: projections.map(p => p.projected_outgoing),
                        backgroundColor: 'rgba(239, 68, 68, 0.6)',
                        borderColor: 'rgb(239, 68, 68)',
                        borderWidth: 1
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: (val) => 'Rp ' + (val/1000) + 'k'
                        }
                    },
                    x: {
                        grid: { display: false },
                        ticks: {
                            maxRotation: 0,
                            callback: function(val, index) {
                                return index % 5 === 0 ? this.getLabelForValue(val) : '';
                            }
                        }
                    }
                }
            }
        });

        window.simulate = function(percentage) {
            const multiplier = 1 + (percentage / 100);
            const newData = projections.map(p => {
                // We only simulate growth on "forecast_sales" which is part of incoming
                const baseIncoming = p.projected_incoming;
                const forecastSales = p.source_data.sales_forecast;
                const installments = p.source_data.installments;
                
                return (forecastSales * multiplier) + installments;
            });
            
            window.cashflowChart.data.datasets[0].data = newData;
            window.cashflowChart.update();
        };
    });
</script>
@endpush
