<script setup>
import { ref, onMounted } from 'vue';
import { AlertCircle, ShoppingCart, Loader2 } from 'lucide-vue-next';

const suggestions = ref([]);
const isLoading = ref(true);
const error = ref(null);

const fetchSuggestions = async () => {
    isLoading.value = true;
    try {
        // Mock store ID 1 for now
        const response = await axios.get('/api/assistant/reorder?store_id=1');
        suggestions.value = response.data;
    } catch (err) {
        console.error('Failed to fetch reorder suggestions:', err);
        error.value = 'Failed to load data.';
    } finally {
        isLoading.value = false;
    }
};

onMounted(() => {
    fetchSuggestions();
});

const getUrgencyColor = (level) => {
    switch (level) {
        case 'critical': return 'text-red-600 bg-red-50 border-red-100 dark:bg-red-900/20 dark:text-red-400 dark:border-red-900';
        case 'medium': return 'text-orange-600 bg-orange-50 border-orange-100 dark:bg-orange-900/20 dark:text-orange-400 dark:border-orange-900';
        default: return 'text-zinc-600 bg-zinc-50 border-zinc-100 dark:bg-zinc-900/20 dark:text-zinc-400 dark:border-zinc-900';
    }
};
</script>

<template>
    <div>
        <div class="flex items-center justify-between mb-6">
            <div>
                <h2 class="text-xl font-bold text-zinc-900 dark:text-white">Smart Restock Suggestions</h2>
                <p class="text-sm text-zinc-500">Based on 30-day sales velocity</p>
            </div>
            <button @click="fetchSuggestions" class="text-sm text-red-600 font-bold hover:underline">
                Refresh Data
            </button>
        </div>

        <div v-if="isLoading" class="flex flex-col items-center justify-center py-12 text-zinc-400">
            <Loader2 class="animate-spin mb-2" :size="32" />
            <p>Analyzing sales patterns...</p>
        </div>

        <div v-else-if="error" class="p-4 rounded-lg bg-red-50 text-red-600 text-center">
            {{ error }}
        </div>

        <div v-else-if="suggestions.length === 0" class="flex flex-col items-center justify-center py-12 text-zinc-400">
            <ShoppingCart :size="48" class="mb-4 opacity-50" />
            <p class="font-medium">Stock levels are healthy!</p>
            <p class="text-sm">No reorders needed at this time.</p>
        </div>

        <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <div 
                v-for="item in suggestions" 
                :key="item.product_id"
                class="bg-white dark:bg-zinc-800 rounded-xl border p-5 shadow-sm hover:shadow-md transition-shadow"
                :class="item.urgency_level === 'critical' ? 'border-red-200 dark:border-red-900' : 'border-gray-100 dark:border-zinc-700'"
            >
                <div class="flex justify-between items-start mb-3">
                    <span 
                        class="px-2 py-1 rounded-md text-xs font-bold uppercase tracking-wide border"
                        :class="getUrgencyColor(item.urgency_level)"
                    >
                        {{ item.urgency_level }} urgency
                    </span>
                    <span class="text-xs text-zinc-400 font-mono">ID: {{ item.product_id }}</span>
                </div>

                <h3 class="font-bold text-zinc-900 dark:text-white mb-1 line-clamp-1">{{ item.product_name }}</h3>
                
                <div class="flex items-center gap-4 text-sm text-zinc-600 dark:text-zinc-400 mb-4">
                    <div class="flex items-center gap-1">
                        <span class="font-medium text-zinc-900 dark:text-white">{{ item.current_stock }}</span>
                        <span class="text-xs">in stock</span>
                    </div>
                    <div class="w-px h-3 bg-zinc-300 dark:bg-zinc-700"></div>
                    <div class="flex items-center gap-1">
                        <span class="font-medium text-zinc-900 dark:text-white">{{ item.days_remaining }}</span>
                        <span class="text-xs">days left</span>
                    </div>
                </div>

                <div class="bg-red-50 dark:bg-red-900/20 rounded-lg p-3 flex items-center justify-between">
                    <div>
                        <p class="text-[10px] uppercase font-bold text-red-600/70 dark:text-red-400/70 mb-0.5">Suggested Order</p>
                        <p class="font-black text-lg text-red-600 dark:text-red-400">{{ item.suggested_reorder_quantity }} <span class="text-xs font-normal">units</span></p>
                    </div>
                    <button class="bg-red-600 hover:bg-red-700 text-white p-2 rounded-lg transition-colors">
                        <ShoppingCart :size="18" />
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>
