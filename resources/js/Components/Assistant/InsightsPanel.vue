<script setup>
import { ref, onMounted } from 'vue';
import { Sparkles, TrendingUp, Activity, Loader2 } from 'lucide-vue-next';
import HealthWidget from '@/Components/Dashboard/HealthWidget.vue';

const summary = ref(null);
const isLoading = ref(true);
const error = ref(null);

const fetchSummary = async () => {
    isLoading.value = true;
    try {
        const response = await axios.get('/api/assistant/dashboard-summary?store_id=1');
        summary.value = response.data;
    } catch (err) {
        console.error('Failed to fetch summary:', err);
        error.value = 'Failed to load insights.';
    } finally {
        isLoading.value = false;
    }
};

onMounted(() => {
    fetchSummary();
});
</script>

<template>
    <div>
        <div class="flex items-center justify-between mb-6">
            <div>
                <h2 class="text-xl font-bold text-zinc-900 dark:text-white">Business Intelligence</h2>
                <p class="text-sm text-zinc-500">Real-time health check & AI insights</p>
            </div>
            <button @click="fetchSummary" class="text-sm text-red-700 font-bold hover:underline hover:text-red-900 transition-colors">
                Refresh Analysis
            </button>
        </div>

        <div v-if="isLoading" class="flex flex-col items-center justify-center py-12 text-zinc-400">
            <Loader2 class="animate-spin mb-2" :size="32" />
            <p>Analyzing business data...</p>
        </div>

        <div v-else-if="error" class="p-4 rounded-lg bg-red-50 text-red-600 text-center">
            {{ error }}
        </div>

        <div v-else class="space-y-6">
            
            <!-- Health Score Widget (Reusable) -->
            <HealthWidget :healthScore="summary.health_score" />

            <!-- AI Insights Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div 
                    v-for="(insight, index) in summary.insights" 
                    :key="index"
                    class="bg-gradient-to-br from-red-50 to-white dark:from-zinc-800 dark:to-zinc-900 p-4 rounded-xl border border-red-100 dark:border-zinc-700 shadow-sm flex items-start gap-3 group hover:border-red-200 transition-colors"
                >
                    <div class="p-2 bg-red-100 dark:bg-red-900/30 text-red-700 dark:text-red-400 rounded-lg shrink-0 group-hover:scale-110 transition-transform">
                        <Sparkles :size="20" />
                    </div>
                    <div>
                        <h4 class="font-bold text-zinc-900 dark:text-white mb-1">Insight #{{ index + 1 }}</h4>
                        <p class="text-sm text-zinc-600 dark:text-zinc-300 leading-relaxed">{{ insight }}</p>
                    </div>
                </div>
            </div>

            <!-- Risk Metrics -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div class="p-4 rounded-xl bg-gray-50 dark:bg-zinc-800 border border-gray-100 dark:border-zinc-700">
                    <p class="text-xs text-zinc-500 uppercase font-bold">Expiry Risk Value</p>
                    <p class="text-xl font-bold text-zinc-900 dark:text-white mt-1">
                        Rp {{ new Intl.NumberFormat('id-ID').format(summary.expiry_risk.near_expiry_risk_value) }}
                    </p>
                </div>
                <div class="p-4 rounded-xl bg-gray-50 dark:bg-zinc-800 border border-gray-100 dark:border-zinc-700">
                    <p class="text-xs text-zinc-500 uppercase font-bold">Total Inventory Value</p>
                    <p class="text-xl font-bold text-zinc-900 dark:text-white mt-1">
                        Rp {{ new Intl.NumberFormat('id-ID').format(summary.expiry_risk.total_inventory_value) }}
                    </p>
                </div>
                <div class="p-4 rounded-xl bg-gray-50 dark:bg-zinc-800 border border-gray-100 dark:border-zinc-700">
                    <p class="text-xs text-zinc-500 uppercase font-bold">Risk Ratio</p>
                    <p class="text-xl font-bold text-zinc-900 dark:text-white mt-1">
                        {{ summary.expiry_risk.risk_ratio }}%
                    </p>
                </div>
            </div>

        </div>
    </div>
</template>
