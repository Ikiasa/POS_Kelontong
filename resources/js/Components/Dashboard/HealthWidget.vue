<script setup>
import { computed } from 'vue';

const props = defineProps({
    healthScore: Object
});

const score = computed(() => props.healthScore?.score ?? 0);
const color = computed(() => {
    if (score.value > 80) return 'green';
    if (score.value > 40) return 'yellow';
    return 'red';
});

const statusText = computed(() => {
    if (score.value > 80) return 'Stable';
    if (score.value > 40) return 'Warning';
    return 'Critical';
});

const textClass = computed(() => {
    if (score.value > 80) return 'text-success dark:text-success';
    if (score.value > 40) return 'text-warning dark:text-warning';
    return 'text-danger dark:text-danger';
});

const bgClass = computed(() => {
    if (score.value > 80) return 'bg-success/10 text-success-800 dark:bg-success/20 dark:text-success';
    if (score.value > 40) return 'bg-warning/10 text-warning-800 dark:bg-warning/20 dark:text-warning';
    return 'bg-danger/10 text-danger-800 dark:bg-danger/20 dark:text-danger';
});

const barClass = computed(() => {
    if (score.value > 80) return 'bg-success';
    if (score.value > 40) return 'bg-warning';
    return 'bg-danger';
});

const formatKey = (key) => key.replace(/_/g, ' ');
</script>

<template>
    <div class="bg-white dark:bg-zinc-900 rounded-xl border border-gray-100 dark:border-zinc-800 shadow-sm p-6">
        <div class="flex items-center justify-between mb-4">
            <h3 class="text-lg font-bold text-gray-900 dark:text-white">Business Health</h3>
            <span class="px-3 py-1 rounded-full text-xs font-medium" :class="bgClass">
                {{ statusText }}
            </span>
        </div>

        <div class="relative pt-1">
            <div class="flex mb-2 items-center justify-between">
                <div>
                    <span class="text-xs font-semibold inline-block py-1 px-2 uppercase rounded-full" 
                          :class="score > 80 ? 'text-success bg-success/20 dark:bg-success/30 dark:text-success' : (score > 40 ? 'text-warning bg-warning/20 dark:bg-warning/30 dark:text-warning' : 'text-danger bg-danger/20 dark:bg-danger/30 dark:text-danger')">
                        Overall Score
                    </span>
                </div>
                <div class="text-right">
                    <span class="text-xl font-bold inline-block" :class="textClass">
                        {{ score }}%
                    </span>
                </div>
            </div>
            <div class="overflow-hidden h-4 mb-4 text-xs flex rounded bg-gray-100 dark:bg-dark-bg border border-zinc-200 dark:border-zinc-700">
                <div :style="{ width: score + '%' }" 
                     class="shadow-none flex flex-col text-center whitespace-nowrap text-white justify-center transition-all duration-500" 
                     :class="barClass"></div>
            </div>
        </div>

        <div v-if="healthScore && healthScore.breakdown" class="mt-4 space-y-3">
            <div v-for="(subScore, key) in healthScore.breakdown" :key="key" class="flex items-center justify-between">
                <span class="text-sm text-gray-500 dark:text-gray-400 capitalize">{{ formatKey(key) }}</span>
                <span class="text-sm font-medium" 
                      :class="subScore > 70 ? 'text-success dark:text-success' : (subScore > 40 ? 'text-warning dark:text-warning' : 'text-danger dark:text-danger')">
                    {{ typeof subScore === 'number' ? subScore.toFixed(1) : subScore }}%
                </span>
            </div>
        </div>

        <div v-if="healthScore?.explanation" class="mt-4 p-3 bg-gray-50 dark:bg-zinc-800 rounded-lg border border-gray-200 dark:border-zinc-700">
            <p class="text-xs text-gray-600 dark:text-gray-400 italic">
                <span class="font-bold">Insight:</span> {{ healthScore.explanation }}
            </p>
        </div>
        
        <div v-else class="mt-4 p-3 bg-gray-50 dark:bg-zinc-800 border-dashed border border-gray-200 dark:border-zinc-700 rounded-lg text-center text-gray-400 text-xs">
            Data insufficient for diagnosis
        </div>
    </div>
</template>
