<div 
    x-data="{
        isOnline: navigator.onLine,
        isSyncing: false,
        offlineCount: 0,
        init() {
            window.addEventListener('online', () => {
                this.isOnline = true;
                this.syncData();
            });
            window.addEventListener('offline', () => {
                this.isOnline = false;
            });
            
            // Check offline queue size on load
            this.updateOfflineCount();
            
            // Listen for custom events from pos.js
            window.addEventListener('offline-queue-updated', () => this.updateOfflineCount());
            window.addEventListener('sync-start', () => this.isSyncing = true);
            window.addEventListener('sync-end', () => this.isSyncing = false);
        },
        updateOfflineCount() {
            const queue = JSON.parse(localStorage.getItem('offlineTransactions') || '[]');
            this.offlineCount = queue.length;
        },
        syncData() {
            // Trigger sync in the main pos component if it exists
            const posComponent = document.querySelector('[x-data=pos]');
            if (posComponent && posComponent._x_dataStack) {
                posComponent._x_dataStack[0].syncOfflineTransactions();
            }
        }
    }"
    class="flex items-center"
>
    <!-- Offline Warning -->
    <div 
        x-show="!isOnline" 
        style="display: none;"
        class="flex items-center bg-red-100 text-red-700 px-3 py-1 rounded-full text-xs font-bold mr-2 animate-pulse"
    >
        <svg class="w-4 h-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 5.636a9 9 0 010 12.728m0 0l-2.829-2.829m2.829 2.829L21 21M15.536 8.464a5 5 0 010 7.072m0 0l-2.829-2.829m-4.243 2.829a4.978 4.978 0 01-1.414-2.83m-1.414 5.658a9 9 0 01-2.167-9.238m7.824 2.167a1 1 0 111.414 1.414m-1.414-1.414L3 3m8.293 8.293l1.414 1.414" />
        </svg>
        OFFLINE MODE
    </div>

    <!-- Syncing Indicator -->
    <div 
        x-show="isOnline && isSyncing" 
        style="display: none;"
        class="flex items-center bg-blue-100 text-blue-700 px-3 py-1 rounded-full text-xs font-bold mr-2"
    >
        <svg class="animate-spin w-4 h-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
        </svg>
        SYNCING...
    </div>

    <!-- Pending Items Indicator -->
    <div 
        x-show="offlineCount > 0" 
        style="display: none;"
        class="flex items-center text-orange-600 bg-orange-50 px-2 py-1 rounded text-xs font-medium border border-orange-200"
    >
        <span class="w-2 h-2 rounded-full bg-orange-500 mr-2"></span>
        <span x-text="offlineCount + ' Pending'"></span>
    </div>

    <div x-show="isOnline && !isSyncing && offlineCount === 0" class="flex items-center gap-2 text-sm text-gray-500 bg-gray-50 px-3 py-1 rounded-full border border-gray-100">
        <span class="w-2 h-2 rounded-full bg-green-500"></span>
        <span>Online</span>
    </div>
</div>
