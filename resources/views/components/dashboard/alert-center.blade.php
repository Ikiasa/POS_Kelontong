@props(['alerts'])

<div class="bg-white rounded-xl border border-gray-100 shadow-sm overflow-hidden">
    <div class="p-4 border-b border-gray-50 flex items-center justify-between bg-red-50/20">
        <div class="flex items-center space-x-2">
            <div class="h-2 w-2 bg-red-500 rounded-full animate-pulse"></div>
            <h3 class="text-sm font-bold text-gray-900 uppercase tracking-tight">System Notifications</h3>
        </div>
        <span class="text-[10px] font-bold text-red-600 bg-red-100 px-2 py-0.5 rounded-full">
            {{ $alerts->count() }} ACTIVE
        </span>
    </div>

    <div class="divide-y max-h-[300px] overflow-y-auto">
        @forelse($alerts as $alert)
            <div @class([
                'p-4 transition-colors',
                'bg-red-50/30' => $alert->severity === 'critical',
                'bg-orange-50/30' => $alert->severity === 'warning',
                'hover:bg-gray-50' => $alert->severity === 'info',
            ])>
                <div class="flex items-start space-x-3">
                    <div @class([
                        'mt-1 h-5 w-5 rounded-lg flex items-center justify-center flex-shrink-0',
                        'bg-red-100 text-red-600' => $alert->severity === 'critical',
                        'bg-orange-100 text-orange-600' => $alert->severity === 'warning',
                        'bg-blue-100 text-blue-600' => $alert->severity === 'info',
                    ])>
                        @if($alert->severity === 'critical')
                            <svg class="h-3 w-3" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd" /></svg>
                        @elseif($alert->severity === 'warning')
                            <svg class="h-3 w-3" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" /></svg>
                        @else
                            <svg class="h-3 w-3" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd" /></svg>
                        @endif
                    </div>
                    <div class="flex-1">
                        <div class="flex items-center justify-between">
                            <span class="text-[9px] font-black uppercase tracking-widest text-gray-400">
                                {{ str_replace('_', ' ', $alert->type) }}
                            </span>
                            <span class="text-[9px] text-gray-400">{{ $alert->created_at->diffForHumans() }}</span>
                        </div>
                        <p class="text-xs font-bold text-gray-900 leading-tight mt-0.5">{{ $alert->message }}</p>
                    </div>
                </div>
            </div>
        @empty
            <div class="py-12 text-center text-gray-400">
                <p class="text-xs italic">All systems clear. No active alerts.</p>
            </div>
        @endforelse
    </div>
    
    <div class="p-3 bg-gray-50 border-t border-gray-100 text-center">
        <button class="text-[10px] font-bold text-indigo-600 hover:text-indigo-700 uppercase">
            View Notification History
        </button>
    </div>
</div>
