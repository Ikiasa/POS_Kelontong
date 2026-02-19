<script setup>
import { computed } from 'vue';
import { AlertTriangle, TrendingDown, ShieldCheck } from 'lucide-vue-next';

const props = defineProps({
    riskScore: Object
});

const score = computed(() => props.riskScore?.risk_score ?? 0);
const isHigh = computed(() => score.value > 30);

const formatKey = (key) => key.replace(/_/g, ' ');
</script>

<template>
    <div class="bg-white dark:bg-zinc-900 rounded-xl border p-6"
         :class="isHigh ? 'border-danger/20 dark:border-danger/30 bg-danger/5' : 'border-gray-100 dark:border-zinc-800 shadow-sm'">
        <div class="flex items-center justify-between mb-4">
            <h3 class="text-lg font-bold text-gray-900 dark:text-white">Profit Leak Detector</h3>
            <span v-if="isHigh" class="animate-pulse flex h-3 w-3 rounded-full bg-red-400 opacity-75"></span>
        </div>

        <div class="flex items-center space-x-4 mb-6">
            <div class="flex-shrink-0 w-16 h-16 rounded-full border-4 flex items-center justify-center transition-colors duration-500"
                 :class="isHigh ? 'border-danger text-danger' : 'border-success text-success'">
                <span class="text-xl font-bold">{{ score }}%</span>
            </div>
            <div>
                <p class="text-sm font-medium text-gray-900 dark:text-white">Risk Threshold</p>
                <p class="text-xs text-gray-500 dark:text-gray-400">
                    {{ isHigh ? 'High probability of revenue loss' : 'Low risk detected' }}
                </p>
            </div>
        </div>

        <div class="space-y-3">
            <template v-if="riskScore && riskScore.indicators">
                <div v-for="(count, key) in riskScore.indicators" :key="key">
                    <div v-if="count > 0" class="flex items-start bg-white dark:bg-zinc-900 p-3 rounded-lg border border-gray-100 dark:border-zinc-800 shadow-sm">
                        <div class="flex-shrink-0 mt-0.5">
                            <TrendingDown class="text-danger" :size="18" />
                        </div>
                        <div class="ml-3">
                            <h4 class="text-xs font-bold text-gray-900 dark:text-white capitalize">{{ formatKey(key) }}</h4>
                            <p class="text-[10px] text-gray-500 dark:text-gray-400">{{ count }} occurrences detected today.</p>
                        </div>
                    </div>
                </div>
            </template>
             <div v-if="!isHigh" class="mt-4 flex items-center justify-center py-6">
                <ShieldCheck :size="48" class="text-green-100 dark:text-green-900/20" />
            </div>
        </div>
    </div>
</template>
