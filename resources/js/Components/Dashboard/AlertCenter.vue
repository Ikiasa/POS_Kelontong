<script setup>
import { computed } from 'vue';
import { ShieldCheck, AlertTriangle } from 'lucide-vue-next';

const props = defineProps({
    alerts: {
        type: Array,
        default: () => []
    }
});

const recentAlerts = computed(() => {
    return props.alerts.slice(0, 5);
});

const getSeverityClass = (severity) => {
    switch(severity) {
        case 'critical': return 'bg-danger/10 text-danger border-danger/20 dark:bg-danger/20 dark:text-danger dark:border-danger/30';
        case 'warning': return 'bg-warning/10 text-warning-800 border-warning/20 dark:bg-warning/20 dark:text-warning dark:border-warning/30';
        case 'info': return 'bg-info/10 text-info-800 border-info/20 dark:bg-info/20 dark:text-info dark:border-info/30';
        default: return 'bg-success/10 text-success-800 border-success/20 dark:bg-success/20 dark:text-success dark:border-success/30';
    }
};

const formatDate = (dateString) => {
    const date = new Date(dateString);
    return new Intl.RelativeTimeFormat('en', { numeric: 'auto' }).format(
        Math.ceil((date - new Date()) / (1000 * 60 * 60 * 24)), 
        'day'
    );
};
</script>

<template>
    <div class="bg-white dark:bg-zinc-900 rounded-xl border border-gray-100 dark:border-zinc-800 shadow-sm p-6 max-h-[400px] overflow-y-auto">
        <h3 class="text-lg font-bold text-gray-900 dark:text-white mb-4 flex items-center justify-between">
            <span class="flex items-center gap-2">
                <AlertTriangle class="text-orange-500" :size="20" />
                Notifikasi Sistem
            </span>
            <span v-if="alerts.length > 0" class="text-xs bg-brand-100 text-brand-700 dark:bg-brand-600/20 dark:text-brand-300 px-2 py-0.5 rounded-full">
                {{ alerts.length }} Aktif
            </span>
        </h3>

        <div v-if="alerts.length === 0" class="flex flex-col items-center justify-center py-8 text-center text-gray-400">
            <ShieldCheck :size="48" class="text-green-500 opacity-50 mb-2" />
            <p>Semua sistem berjalan normal</p>
        </div>

        <div v-else class="space-y-3">
            <div v-for="alert in recentAlerts" :key="alert.id" 
                 class="p-3 rounded-lg flex items-start gap-3"
                 :class="getSeverityClass(alert.severity)">
                <div class="flex-shrink-0 mt-0.5">
                    <AlertTriangle :size="16" />
                </div>
                <div>
                    <p class="text-sm font-bold">{{ alert.message }}</p>
                    <div class="flex items-center gap-2 mt-1">
                        <span class="text-[10px] uppercase font-bold tracking-wider opacity-75">{{ alert.severity }}</span>
                        <span class="text-[10px] opacity-75">• {{ formatDate(alert.created_at) }}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
