<x-layouts.dashboard>
    <div class="p-6">
        <h1 class="text-2xl font-bold mb-6">AI Intelligence Dashboard</h1>

        @if(session('success'))
            <div class="bg-green-100 text-green-700 p-3 rounded mb-4">{{ session('success') }}</div>
        @endif

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            
            <!-- Sales Forecast Widget -->
            <div class="bg-white p-6 rounded shadow">
                <h2 class="text-lg font-bold mb-4 flex items-center">
                    <span class="mr-2">📈</span> Sales Forecast (Next Month)
                </h2>
                
                <div class="flex items-center gap-4 mb-6">
                    <div>
                        <p class="text-sm text-gray-500">Predicted Revenue</p>
                        <p class="text-3xl font-bold text-blue-600">
                            Rp {{ number_format($forecast['prediction']['next_month']) }}
                        </p>
                    </div>
                    <div class="p-2 rounded 
                        {{ $forecast['prediction']['trend'] == 'up' ? 'bg-green-100 text-green-700' : 'bg-yellow-100 text-yellow-700' }}">
                        Trend: {{ ucfirst($forecast['prediction']['trend']) }}
                    </div>
                </div>

                <!-- Simple Bar Chart Visualization (CSS only for simplicity) -->
                <div class="h-40 flex items-end gap-2 border-b border-l border-gray-300 p-2">
                    @php 
                        $historyData = $forecast['history']['data'];
                        $max = count($historyData) > 0 ? max($historyData) : 1; 
                    @endphp

                    @forelse($historyData as $index => $value)
                        @php 
                             $height = $max > 0 ? ($value / $max) * 100 : 0;
                        @endphp
                        <div class="w-1/6 bg-blue-400 hover:bg-blue-600 transition relative group" style="height: {{ $height }}%">
                            <div class="absolute bottom-[-20px] left-0 w-full text-center text-xs text-gray-500 truncate">
                                {{ $forecast['history']['labels'][$index] }}
                            </div>
                             <div class="hidden group-hover:block absolute -top-8 left-0 bg-black text-white text-xs p-1 rounded z-10">
                                {{ number_format($value) }}
                            </div>
                        </div>
                    @empty
                        <div class="flex-1 text-center text-xs text-gray-400 pb-2">No historical data found</div>
                    @endforelse
                    
                    <!-- Prediction Bar -->
                    @php 
                        $predHeight = ($forecast['prediction']['next_month'] / $max) * 100;
                    @endphp
                    <div class="w-1/6 bg-purple-400 hover:bg-purple-600 transition relative group border-t-2 border-white" style="height: {{ $predHeight }}%">
                        <div class="absolute bottom-[-20px] left-0 w-full text-center text-xs text-gray-500 font-bold">
                            Forecast
                        </div>
                         <div class="hidden group-hover:block absolute -top-8 left-0 bg-black text-white text-xs p-1 rounded z-10">
                            {{ number_format($forecast['prediction']['next_month']) }}
                        </div>
                    </div>
                </div>
            </div>

            <!-- Pricing Intelligence Widget -->
            <div class="bg-white p-6 rounded shadow">
                <h2 class="text-lg font-bold mb-4 flex items-center">
                    <span class="mr-2">💡</span> Pricing Suggestions
                </h2>

                <div class="space-y-4">
                    @forelse($suggestions as $s)
                    <div class="border-l-4 p-3 rounded bg-gray-50 flex justify-between items-center
                        {{ $s['severity'] == 'high' ? 'border-red-500' : 'border-yellow-500' }}">
                        <div>
                            <p class="font-bold">{{ $s['product']->name }}</p>
                            <p class="text-xs text-gray-500">{{ $s['reason'] }}</p>
                            <p class="text-sm mt-1">
                                Current: <span class="line-through text-gray-400">{{ number_format($s['product']->price) }}</span> 
                                → <span class="font-bold text-green-600">{{ number_format($s['suggested_price']) }}</span>
                            </p>
                        </div>
                        <div class="flex flex-col items-end gap-2">
                            <span class="px-2 py-1 rounded text-xs uppercase font-bold
                                 {{ $s['type'] == 'markup' ? 'bg-green-100 text-green-800' : 'bg-blue-100 text-blue-800' }}">
                                {{ $s['type'] }}
                            </span>
                            <form action="{{ route('forecast.apply') }}" method="POST">
                                @csrf
                                <input type="hidden" name="product_id" value="{{ $s['product']->id }}">
                                <input type="hidden" name="price" value="{{ $s['suggested_price'] }}">
                                <button type="submit" class="text-xs bg-white border border-gray-300 px-2 py-1 rounded hover:bg-gray-100">
                                    Approve
                                </button>
                            </form>
                        </div>
                    </div>
                    @empty
                    <div class="text-center text-gray-500 py-4">
                        No pricing suggestions at this time.
                    </div>
                    @endforelse
                </div>
            </div>

        </div>
    </div>
</x-layouts.dashboard>
