<script setup>
import { ref, computed, watch } from 'vue';
import { 
    ChevronUp, 
    ChevronDown, 
    Search, 
    Filter, 
    ChevronLeft, 
    ChevronRight,
    MoreHorizontal,
    Download,
    Eye,
    Edit3,
    Trash2,
    RefreshCw
} from 'lucide-vue-next';

const props = defineProps({
    columns: {
        type: Array,
        required: true,
        // Column shape: { key: 'id', label: 'ID', sortable: true, align: 'left', width: '100px' }
    },
    items: {
        type: Array,
        required: true
    },
    loading: {
        type: Boolean,
        default: false
    },
    searchPlaceholder: {
        type: String,
        default: 'Scan or search data...'
    },
    actions: {
        type: Boolean,
        default: true
    },
    title: String,
    subtitle: String
});

const emit = defineEmits(['view', 'edit', 'delete', 'refresh']);

const searchQuery = ref('');
const sortKey = ref('');
const sortOrder = ref('asc'); // asc | desc
const currentPage = ref(1);
const itemsPerPage = ref(10);

// Sorting logic
const handleSort = (key) => {
    if (sortKey.value === key) {
        sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc';
    } else {
        sortKey.value = key;
        sortOrder.value = 'asc';
    }
};

// Filtering logic (Client-side)
const filteredItems = computed(() => {
    let result = [...props.items];
    
    // Search
    if (searchQuery.value) {
        const query = searchQuery.value.toLowerCase();
        result = result.filter(item => {
            return Object.values(item).some(val => 
                String(val).toLowerCase().includes(query)
            );
        });
    }
    
    // Sort
    if (sortKey.value) {
        result.sort((a, b) => {
            const valA = a[sortKey.value];
            const valB = b[sortKey.value];
            if (valA < valB) return sortOrder.value === 'asc' ? -1 : 1;
            if (valA > valB) return sortOrder.value === 'asc' ? 1 : -1;
            return 0;
        });
    }
    
    return result;
});

// Pagination logic
const totalPages = computed(() => Math.ceil(filteredItems.value.length / itemsPerPage.value));
const paginatedItems = computed(() => {
    const start = (currentPage.value - 1) * itemsPerPage.value;
    return filteredItems.value.slice(start, start + itemsPerPage.value);
});

const startItem = computed(() => (currentPage.value - 1) * itemsPerPage.value + 1);
const endItem = computed(() => Math.min(currentPage.value * itemsPerPage.value, filteredItems.value.length));

watch(searchQuery, () => {
    currentPage.value = 1;
});
</script>

<template>
    <div class="bg-white dark:bg-dark-surface rounded-[32px] shadow-premium border border-surface-100 dark:border-dark-border overflow-hidden flex flex-col transition-all duration-500 animate-in fade-in slide-in-from-bottom-4">
        
        <!-- Table Header / Toolbelt -->
        <div class="px-10 py-8 border-b border-surface-50 dark:border-dark-border flex flex-wrap items-center justify-between gap-6 bg-surface-50/30 dark:bg-dark-bg/20">
            <div v-if="title || subtitle">
                <h3 class="text-2xl font-black text-slate-900 dark:text-zinc-100 tracking-tighter italic uppercase font-serif">{{ title }}</h3>
                <p v-if="subtitle" class="text-[10px] font-black text-slate-400 dark:text-zinc-500 uppercase tracking-[0.2em] mt-1">{{ subtitle }}</p>
            </div>

            <div class="flex items-center gap-4 flex-1 max-w-2xl justify-end">
                <!-- Search Sector -->
                <div class="relative flex-1 max-w-md group">
                    <input 
                        v-model="searchQuery" 
                        type="text" 
                        :placeholder="searchPlaceholder"
                        class="w-full pl-12 pr-4 py-3 bg-white dark:bg-dark-bg border border-surface-200 dark:border-dark-border rounded-2xl text-xs font-bold focus:ring-8 focus:ring-brand-500/10 focus:border-brand-600 transition-all shadow-inner outline-none placeholder-slate-300 dark:placeholder-zinc-700"
                    />
                    <Search :size="16" class="absolute left-4 top-1/2 -translate-y-1/2 text-slate-300 group-hover:text-brand-500 transition-colors" />
                </div>

                <!-- Global Actions -->
                <div class="flex items-center gap-2">
                    <button @click="$emit('refresh')" class="w-11 h-11 flex items-center justify-center bg-white dark:bg-dark-bg border border-surface-200 dark:border-dark-border rounded-xl hover:bg-surface-50 dark:hover:bg-zinc-800 transition-all active:scale-95 text-slate-400 hover:text-brand-600">
                        <RefreshCw :size="18" :class="{ 'animate-spin': loading }" />
                    </button>
                    <slot name="header-actions"></slot>
                </div>
            </div>
        </div>

        <!-- The Ledger -->
        <div class="flex-1 overflow-x-auto custom-scrollbar">
            <table class="w-full text-left border-collapse min-w-[800px]">
                <thead class="bg-surface-50/50 dark:bg-dark-bg/40 text-slate-400 dark:text-zinc-500 text-[10px] font-black uppercase tracking-[0.2em] border-b border-surface-100 dark:border-dark-border">
                    <tr>
                        <th v-for="col in columns" :key="col.key" 
                            class="py-6 px-10 whitespace-nowrap"
                            :class="[col.align === 'right' ? 'text-right' : col.align === 'center' ? 'text-center' : 'text-left']"
                            :style="{ width: col.width }">
                            <div class="flex items-center gap-2 group cursor-pointer" 
                                 @click="col.sortable !== false && handleSort(col.key)"
                                 :class="{ 'justify-end': col.align === 'right', 'justify-center': col.align === 'center' }">
                                <span>{{ col.label }}</span>
                                <div v-if="col.sortable !== false" class="flex flex-col opacity-0 group-hover:opacity-100 transition-opacity" :class="{ 'opacity-100': sortKey === col.key }">
                                    <ChevronUp :size="10" :class="{ 'text-brand-600': sortKey === col.key && sortOrder === 'asc' }" />
                                    <ChevronDown :size="10" :class="{ 'text-brand-600': sortKey === col.key && sortOrder === 'desc' }" />
                                </div>
                            </div>
                        </th>
                        <th v-if="actions" class="py-6 px-10 w-24 text-center">Protocol</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-surface-100 dark:divide-dark-border bg-white dark:bg-dark-surface">
                    <tr v-if="loading" v-for="i in 5" :key="i" class="animate-pulse">
                        <td v-for="col in columns" class="py-6 px-10"><div class="h-4 bg-slate-100 dark:bg-zinc-800/50 rounded-lg w-full"></div></td>
                        <td class="py-6 px-10"><div class="h-4 bg-slate-100 dark:bg-zinc-800/50 rounded-lg w-full"></div></td>
                    </tr>
                    <tr v-else-if="paginatedItems.length === 0">
                        <td :colspan="columns.length + (actions ? 1 : 0)" class="py-32 text-center">
                            <div class="flex flex-col items-center justify-center opacity-20">
                                <Search :size="64" stroke-width="0.5" class="mb-4 text-slate-400" />
                                <span class="text-xl font-black italic tracking-tighter uppercase font-serif">No Data Found</span>
                                <span class="text-[10px] font-bold mt-1 uppercase tracking-widest">System Search Results Consumed 0.0s</span>
                            </div>
                        </td>
                    </tr>
                    <tr v-for="(item, idx) in paginatedItems" :key="item.id || idx" 
                        class="hover:bg-brand-50/30 dark:hover:bg-brand-900/5 transition-all group relative">
                        <td v-for="col in columns" :key="col.key" 
                            class="py-6 px-10 whitespace-nowrap"
                            :class="[col.align === 'right' ? 'text-right' : col.align === 'center' ? 'text-center' : 'text-left']">
                            <slot :name="`col-${col.key}`" :item="item" :value="item[col.key]">
                                <span class="font-bold text-slate-700 dark:text-zinc-200">{{ item[col.key] }}</span>
                            </slot>
                        </td>
                        
                        <!-- Action Protocol -->
                        <td v-if="actions" class="py-6 px-10 text-center">
                            <div class="flex items-center justify-center gap-2 opacity-0 group-hover:opacity-100 transition-all transform translate-x-2 group-hover:translate-x-0">
                                <button v-if="$slots['actions-prefix']" @click="$emit('view', item)">
                                    <slot name="actions-prefix" :item="item"></slot>
                                </button>
                                <button @click="$emit('edit', item)" class="p-2 text-slate-400 hover:text-brand-600 hover:bg-brand-50 dark:hover:bg-brand-900/20 rounded-lg transition-colors">
                                    <Edit3 :size="16" />
                                </button>
                                <button @click="$emit('delete', item)" class="p-2 text-slate-400 hover:text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition-colors">
                                    <Trash2 :size="16" />
                                </button>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Table Footer / Navigation -->
        <div class="px-10 py-6 border-t border-surface-50 dark:border-dark-border flex items-center justify-between bg-white dark:bg-dark-surface shrink-0">
            <div class="text-[10px] font-black text-slate-400 dark:text-zinc-600 uppercase tracking-widest italic">
                Showing <span class="text-slate-900 dark:text-zinc-400">{{ startItem }}-{{ endItem }}</span> of <span class="text-slate-900 dark:text-zinc-400">{{ filteredItems.length }}</span> entries
            </div>

            <div class="flex items-center gap-2">
                <button 
                    @click="currentPage--" 
                    :disabled="currentPage === 1"
                    class="w-10 h-10 flex items-center justify-center rounded-xl bg-surface-50 dark:bg-dark-bg border border-surface-200 dark:border-dark-border hover:bg-brand-600 hover:text-white disabled:opacity-30 disabled:hover:bg-surface-50 disabled:hover:text-inherit transition-all active:scale-90"
                >
                    <ChevronLeft :size="18" />
                </button>
                
                <div class="flex items-center gap-1">
                    <button 
                        v-for="p in totalPages" :key="p"
                        @click="currentPage = p"
                        class="w-10 h-10 rounded-xl text-[11px] font-black transition-all active:scale-90"
                        :class="currentPage === p 
                            ? 'bg-brand-600 text-white shadow-lg shadow-brand-200' 
                            : 'hover:bg-surface-100 dark:hover:bg-zinc-800 text-slate-500'"
                    >
                        {{ p }}
                    </button>
                </div>

                <button 
                    @click="currentPage++" 
                    :disabled="currentPage === totalPages"
                    class="w-10 h-10 flex items-center justify-center rounded-xl bg-surface-50 dark:bg-dark-bg border border-surface-200 dark:border-dark-border hover:bg-brand-600 hover:text-white disabled:opacity-30 disabled:hover:bg-surface-50 disabled:hover:text-inherit transition-all active:scale-90"
                >
                    <ChevronRight :size="18" />
                </button>
            </div>
        </div>
    </div>
</template>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
    height: 8px;
    width: 8px;
}
.custom-scrollbar::-webkit-scrollbar-track {
    background: transparent;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
    background: #e2e8f0;
    border-radius: 10px;
}
.dark .custom-scrollbar::-webkit-scrollbar-thumb {
    background: #1e1e2e;
}
</style>
