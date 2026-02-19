<div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
    <!-- Connectivity -->
    <div class="bg-white p-4 rounded shadow border-l-4 border-green-500" x-data="{ online: navigator.onLine }" @online.window="online = true" @offline.window="online = false">
        <h3 class="text-xs font-bold text-gray-500 uppercase">System Connectivity</h3>
        <div class="flex items-center gap-2 mt-2">
            <span class="w-3 h-3 rounded-full" :class="online ? 'bg-green-500' : 'bg-red-500'"></span>
            <span class="text-lg font-bold" x-text="online ? 'Online' : 'Offline'">Checking...</span>
        </div>
        <p class="text-xs text-gray-400 mt-1" x-text="online ? 'Sync Active' : 'Changes saved locally'">...</p>
    </div>

    <!-- DB Status -->
    <div class="bg-white p-4 rounded shadow border-l-4 border-blue-500">
        <h3 class="text-xs font-bold text-gray-500 uppercase">Database Status</h3>
        <div class="flex items-center gap-2 mt-2">
            <span class="w-3 h-3 rounded-full bg-green-500"></span>
            <span class="text-lg font-bold">Healthy</span>
        </div>
        <p class="text-xs text-gray-400 mt-1">Last Backup: {{ \App\Models\AuditLog::latest()->first()?->created_at->diffForHumans() ?? 'N/A' }}</p>
    </div>
    
    <!-- Printer/Hardware Mock -->
    <div class="bg-white p-4 rounded shadow border-l-4 border-gray-500">
        <h3 class="text-xs font-bold text-gray-500 uppercase">Hardware</h3>
         <div class="flex items-center gap-2 mt-2">
            <span class="w-3 h-3 rounded-full bg-green-500"></span>
            <span class="text-lg font-bold">Ready</span>
        </div>
        <p class="text-xs text-gray-400 mt-1">Printer: Connected (Mock)</p>
    </div>
</div>
