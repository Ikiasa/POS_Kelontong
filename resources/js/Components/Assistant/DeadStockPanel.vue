<script setup>
import { ref, onMounted } from 'vue';
import { Archive, DollarSign, PackageX, Loader2 } from 'lucide-vue-next';

const deadStock = ref([]);
const isLoading = ref(true);
const error = ref(null);

const fetchDeadStock = async () => {
    isLoading.value = true;
    try {
        const response = await axios.get('/api/assistant/dead-stock?store_id=1');
        deadStock.value = response.data;
    } catch (err) {
        console.error('Failed to fetch dead stock:', err);
        error.value = 'Failed to load data.';
    } finally {
        isLoading.value = false;
    }
};

onMounted(() => {
    fetchDeadStock();
});

const formatCurrency = (value) => {
    return new Intl.NumberFormat('id-ID', {
        style: 'currency',
        currency: 'IDR',
        minimumFractionDigits: 0
    }).format(value);
};

const getRiskColor = (level) => {
    switch (level) {
        case 'critical': return 'text-red-600 bg-red-100 dark:bg-red-900/40 dark:text-red-300';
        case 'medium': return 'text-orange-600 bg-orange-100 dark:bg-orange-900/40 dark:text-orange-300';
        default: return 'text-gray-600 bg-gray-100 dark:bg-zinc-800 dark:text-gray-300';
    }
};
</script>

<template>
    <div>
        <div class="flex items-center justify-between mb-6">
            <div>
                <h2 class="text-xl font-bold text-zinc-900 dark:text-white">Dead Stock Detection</h2>
                <p class="text-sm text-zinc-500">Products with no sales for > 45 days</p>
            </div>
            <button @click="fetchDeadStock" class="text-sm text-red-600 font-bold hover:underline">
                Refresh Analysis
            </button>
        </div>

        <div v-if="isLoading" class="flex flex-col items-center justify-center py-12 text-zinc-400">
            <Loader2 class="animate-spin mb-2" :size="32" />
            <p>Scanning inventory history...</p>
        </div>

        <div v-else-if="error" class="p-4 rounded-lg bg-red-50 text-red-600 text-center">
            {{ error }}
        </div>

        <div v-else-if="deadStock.length === 0" class="flex flex-col items-center justify-center py-12 text-zinc-400">
            <Archive :size="48" class="mb-4 opacity-50" />
            <p class="font-medium">Inventory is moving fast!</p>
            <p class="text-sm">No dead stock detected.</p>
        </div>

        <div v-else class="overflow-x-auto">
            <table class="w-full text-left text-sm whitespace-nowrap">
                <thead class="uppercase tracking-wider border-b-2 border-gray-100 dark:border-zinc-800 text-zinc-500 font-bold">
                    <tr>
                        <th scope="col" class="px-4 py-3">Product Name</th>
                        <th scope="col" class="px-4 py-3 text-center">Inactive Days</th>
                        <th scope="col" class="px-4 py-3 text-center">Unsold Stock</th>
                        <th scope="col" class="px-4 py-3 text-right">Value Tied Up</th>
                        <th scope="col" class="px-4 py-3 text-center">Risk</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100 dark:divide-zinc-800">
                    <tr v-for="item in deadStock" :key="item.product_name" class="hover:bg-gray-50 dark:hover:bg-zinc-800/50 transition-colors">
                        <td class="px-4 py-3 font-medium text-zinc-900 dark:text-white flex items-center gap-2">
                            <PackageX :size="16" class="text-red-400" />
                            {{ item.product_name }}
                        </td>
                        <td class="px-4 py-3 text-center text-zinc-600 dark:text-zinc-400">
                            {{ item.days_since_last_sale }} days
                        </td>
                        <td class="px-4 py-3 text-center font-medium text-zinc-900 dark:text-white">
                            {{ item.current_stock }}
                        </td>
                        <td class="px-4 py-3 text-right font-bold text-zinc-900 dark:text-white">
                            {{ formatCurrency(item.stock_value) }}
                        </td>
                        <td class="px-4 py-3 text-center">
                            <span class="px-2 py-1 rounded text-xs font-bold uppercase" :class="getRiskColor(item.risk_level)">
                                {{ item.risk_level }}
                            </span>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</template>
