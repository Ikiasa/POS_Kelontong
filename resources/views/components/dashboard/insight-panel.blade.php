@props(['insights'])

<div class="bg-white rounded-xl border border-gray-100 shadow-sm overflow-hidden">
    <div class="p-6 border-b border-gray-50 flex items-center justify-between bg-indigo-50/30">
        <div>
            <h3 class="text-lg font-bold text-gray-900">AI Sales Advisor</h3>
            <p class="text-xs text-gray-500">Data-driven suggestions to optimize your store</p>
        </div>
        <div class="h-8 w-8 bg-indigo-100 rounded-lg flex items-center justify-center">
            <svg class="h-5 w-5 text-indigo-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
            </svg>
        </div>
    </div>

    <div class="divide-y max-h-[600px] overflow-y-auto">
        @forelse($insights as $insight)
            <div class="p-5 hover:bg-gray-50/50 transition-colors">
                <div class="flex items-start justify-between mb-3">
                    <div class="flex-1">
                        <div class="flex items-center space-x-2 mb-1">
                            <span @class([
                                'px-1.5 py-0.5 rounded text-[9px] font-bold uppercase',
                                'bg-green-100 text-green-700' => $insight->type === 'price_increase',
                                'bg-blue-100 text-blue-700' => $insight->type === 'discount',
                                'bg-purple-100 text-purple-700' => $insight->type === 'bundle',
                            ])>
                                {{ str_replace('_', ' ', $insight->type) }}
                            </span>
                            <h4 class="text-sm font-bold text-gray-900">{{ $insight->title }}</h4>
                        </div>
                        <p class="text-xs text-gray-600 leading-relaxed">{{ $insight->description }}</p>
                    </div>
                </div>
                
                <div class="bg-gray-50 border border-gray-100 rounded-lg p-3 mb-4">
                    <div class="flex items-center space-x-2 mb-1">
                        <svg class="h-3 w-3 text-indigo-500" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" />
                        </svg>
                        <span class="text-[10px] font-bold text-gray-700 uppercase">Analysis</span>
                    </div>
                    <p class="text-[11px] text-gray-600 italic">{{ $insight->explanation }}</p>
                </div>

                <div class="flex items-center gap-2">
                    @if($insight->status === 'pending')
                        <button onclick="approvalAction({{ $insight->id }}, 'approve')" class="flex-1 py-2 bg-indigo-600 text-white text-[10px] font-bold rounded-lg hover:bg-indigo-700 transition-colors">
                            Approve & Apply
                        </button>
                        <button onclick="approvalAction({{ $insight->id }}, 'dismiss')" class="px-3 py-2 bg-white border text-gray-500 text-[10px] font-bold rounded-lg hover:bg-gray-50">
                            Dismiss
                        </button>
                    @elseif($insight->status === 'applied')
                        <div class="w-full py-2 bg-green-50 text-green-700 text-[10px] font-bold rounded-lg text-center border border-green-100">
                             Applied
                        </div>
                    @endif
                </div>
            </div>
        @empty
            <div class="py-16 text-center text-gray-400">
                <div class="text-4xl mb-3">⚡</div>
                <p class="text-sm">Generating new insights based on latest sales...</p>
            </div>
        @endforelse
    </div>
</div>

<script>
    function approvalAction(id, action) {
        if (!confirm('Are you sure you want to ' + action + ' this suggestion?')) return;
        
        fetch(`/insights/${id}/${action}`, {
            method: 'POST',
            headers: {
                'X-CSRF-TOKEN': '{{ csrf_token() }}',
                'Content-Type': 'application/json'
            }
        }).then(res => {
            if (res.ok) window.location.reload();
        });
    }
</script>
