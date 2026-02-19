<script setup>
import { ref, onMounted } from 'vue';
import { Clock, AlertTriangle, CheckCircle, Loader2 } from 'lucide-vue-next';
import axios from 'axios';

const alerts = ref([]);
const isLoading = ref(true);
const error = ref(null);

const fetchExpiry = async () => {
    isLoading.value = true;
    try {
        const response = await axios.get('/api/assistant/expiry?store_id=1');
        alerts.value = response.data;
    } catch (err) {
        console.error('Failed to fetch expiry alerts:', err);
        error.value = 'Failed to load data.';
    } finally {
        isLoading.value = false;
    }
};

onMounted(() => {
    fetchExpiry();
});

const getStatusColor = (status) => {
    switch (status) {
        case 'expired': return 'bg-danger/10 text-danger border-danger/20 dark:bg-danger/20 dark:text-danger dark:border-danger/30';
        case 'critical': return 'bg-warning/10 text-warning border-warning/20 dark:bg-warning/20 dark:text-warning dark:border-warning/30';
        case 'warning': return 'bg-warning/10 text-warning border-warning/20 dark:bg-warning/20 dark:text-warning dark:border-warning/30';
        default: return 'bg-success/10 text-success border-success/20 dark:bg-success/20 dark:text-success dark:border-success/30';
    }
};
</script>

<template>
    <div>
        <div class="flex items-center justify-between mb-6">
            <div>
                <h2 class="text-xl font-bold text-zinc-900 dark:text-white">Monitor Kadaluarsa</h2>
                <p class="text-sm text-zinc-500">Batch yang akan expired dalam 30 hari</p>
            </div>
            <button @click="fetchExpiry" class="text-sm text-brand-600 font-bold hover:underline">
                Refresh Data
            </button>
        </div>

        <div v-if="isLoading" class="flex flex-col items-center justify-center py-12 text-zinc-400">
            <Loader2 class="animate-spin mb-2" :size="32" />
            <p>Mengecek tanggal...</p>
        </div>

        <div v-else-if="error" class="p-4 rounded-lg bg-red-50 text-red-600 text-center">
            {{ error }}
        </div>

        <div v-else-if="alerts.length === 0" class="flex flex-col items-center justify-center py-12 text-zinc-400">
            <CheckCircle :size="48" class="mb-4 text-green-500 opacity-50" />
            <p class="font-medium">Aman!</p>
            <p class="text-sm">Tidak ada barang yang segera expired.</p>
        </div>

        <div v-else class="space-y-4">
            <div 
                v-for="(item, index) in alerts" 
                :key="index"
                class="flex items-center justify-between p-4 rounded-xl border bg-white dark:bg-zinc-800 shadow-sm"
                :class="getStatusColor(item.status)"
            >
                <div class="flex items-center gap-4">
                    <div class="p-3 bg-white/50 backdrop-blur-sm rounded-lg">
                        <AlertTriangle v-if="item.status === 'expired'" :size="20" />
                        <Clock v-else :size="20" />
                    </div>
                    <div>
                        <h3 class="font-bold">{{ item.product_name }}</h3>
                        <p class="text-xs opacity-80">Batch: {{ item.batch_code }} | Qty: {{ item.quantity }}</p>
                    </div>
                </div>

                <div class="text-right">
                    <p class="font-bold text-lg" :class="item.days_to_expiry < 0 ? 'text-danger' : ''">
                        {{ item.days_to_expiry }} HARI
                    </p>
                    <p class="text-[10px] font-bold uppercase tracking-wide opacity-70 max-w-[120px] truncate ml-auto" :title="item.suggested_action">{{ item.suggested_action }}</p>
                </div>
            </div>
        </div>
    </div>
</template>
