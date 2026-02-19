@props(['stores' => []])

<div x-data="{ 
    open: false, 
    currentStore: localStorage.getItem('current_store_name') || 'Main Store',
    init() {
        // Check if there's a store selection in session/local storage
        // For prototype, we sync with local storage
    },
    switchStore(store) {
        if(window.location.pathname.includes('/pos') && document.querySelector('[x-data=pos]')._x_dataStack[0].cart.length > 0) {
            if(!confirm('Switching stores will clear your current cart. Continue?')) return;
        }
        
        this.currentStore = store.name;
        localStorage.setItem('current_store_id', store.id);
        localStorage.setItem('current_store_name', store.name);
        this.open = false;
        
        // Simulate backend switch
        window.location.reload(); 
    }
}" class="relative">
    <button @click="open = !open" @click.outside="open = false" type="button" class="group bg-gray-800 text-gray-200 hover:text-white px-3 py-2 rounded-md text-sm font-medium flex items-center gap-2 transition-colors border border-gray-700">
        <svg class="h-5 w-5 text-gray-400 group-hover:text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m8-2a2 2 0 100-4 2 2 0 000 4z" />
        </svg>
        <span x-text="currentStore"></span>
        <svg class="h-4 w-4 text-gray-500 group-hover:text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
        </svg>
    </button>

    <div 
        x-show="open" 
        x-transition:enter="transition ease-out duration-100"
        x-transition:enter-start="transform opacity-0 scale-95"
        x-transition:enter-end="transform opacity-100 scale-100"
        x-transition:leave="transition ease-in duration-75"
        x-transition:leave-start="transform opacity-100 scale-100"
        x-transition:leave-end="transform opacity-0 scale-95"
        class="absolute right-0 mt-2 w-56 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5 focus:outline-none z-50"
        style="display: none;"
    >
        <div class="py-1" role="menu" aria-orientation="vertical">
            <template x-for="store in {{ Js::from($stores) }}" :key="store.id">
                <button 
                    @click="switchStore(store)"
                    class="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 hover:text-gray-900"
                    :class="{'bg-gray-50 font-semibold text-indigo-600': currentStore === store.name}"
                    role="menuitem"
                >
                    <span x-text="store.name"></span>
                    <span x-show="currentStore === store.name" class="float-right text-indigo-600">&check;</span>
                </button>
            </template>
        </div>
    </div>
</div>
