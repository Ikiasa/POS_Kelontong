<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head, useForm } from '@inertiajs/vue3';
import { computed, ref } from 'vue';
import { DollarSign, Clock, TrendingUp, History } from 'lucide-vue-next';

const props = defineProps({
    current: Object,
    history: Object,
    storeName: String
});

const openForm = useForm({
    opening_balance: 0,
    notes: ''
});

const closeForm = useForm({
    closing_balance: 0,
    notes: ''
});

const variance = computed(() => {
    if (!props.current || !closeForm.closing_balance) return 0;
    return closeForm.closing_balance - (props.current.expected_balance || 0);
});

const varianceColor = computed(() => {
    const val = variance.value;
    if (Math.abs(val) < 1000) return 'text-green-600';
    if (Math.abs(val) < 50000) return 'text-yellow-600';
    return 'text-red-600';
});

const formatCurrency = (value) => {
    return new Intl.NumberFormat('id-ID', {
        style: 'currency',
        currency: 'IDR',
        minimumFractionDigits: 0
    }).format(value || 0);
};

const formatDateTime = (dateString) => {
    return new Date(dateString).toLocaleString('id-ID', {
        dateStyle: 'medium',
        timeStyle: 'short'
    });
};

const submitOpen = () => {
    openForm.post(route('cash-drawer.open'), {
        preserveScroll: true
    });
};

const submitClose = () => {
    if (!props.current) return;
    closeForm.put(route('cash-drawer.close', props.current.id), {
        preserveScroll: true
    });
};
</script>

<template>
    <Head title="Cash Drawer" />

    <MainLayout title="Cash Drawer Management">
        <div class="max-w-4xl mx-auto space-y-6">
            <!-- Current Session Card -->
            <div v-if="!current" class="bg-white dark:bg-zinc-900 p-8 rounded-xl border border-gray-100 dark:border-zinc-800 shadow-sm">
                <div class="text-center mb-6">
                    <div class="inline-flex items-center justify-center w-16 h-16 bg-green-100 dark:bg-green-900/20 rounded-full mb-4">
                        <DollarSign :size="32" class="text-green-600 dark:text-green-400" />
                    </div>
                    <h2 class="text-2xl font-bold text-zinc-900 dark:text-white mb-2">Start New Session</h2>
                    <p class="text-zinc-500">Open the cash drawer to begin POS operations</p>
                </div>

                <form @submit.prevent="submitOpen" class="space-y-4">
                    <div>
                        <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300 mb-2">
                            Opening Cash Balance
                        </label>
                        <input 
                            v-model="openForm.opening_balance" 
                            type="number" 
                            step="100"
                            class="w-full px-4 py-3 rounded-lg border border-gray-300 dark:border-zinc-700 bg-white dark:bg-zinc-800 text-zinc-900 dark:text-white focus:ring-2 focus:ring-red-500 focus:border-transparent"
                            required
                        />
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300 mb-2">
                            Notes (Optional)
                        </label>
                        <textarea 
                            v-model="openForm.notes"
                            rows="3"
                            class="w-full px-4 py-3 rounded-lg border border-gray-300 dark:border-zinc-700 bg-white dark:bg-zinc-800 text-zinc-900 dark:text-white focus:ring-2 focus:ring-red-500 focus:border-transparent"
                        ></textarea>
                    </div>

                    <button 
                        type="submit"
                        :disabled="openForm.processing"
                        class="w-full bg-gradient-to-r from-green-600 to-emerald-600 text-white font-bold py-3 rounded-lg hover:from-green-700 hover:to-emerald-700 transition-all shadow-lg shadow-green-500/20 disabled:opacity-50"
                    >
                        {{ openForm.processing ? 'Opening...' : 'Open Drawer & Start POS' }}
                    </button>
                </form>
            </div>

            <!-- Active Session Card -->
            <div v-else class="bg-white dark:bg-zinc-900 p-8 rounded-xl border border-gray-100 dark:border-zinc-800 shadow-sm">
                <div class="flex items-center justify-between mb-6">
                    <div>
                        <h2 class="text-2xl font-bold text-zinc-900 dark:text-white">Active Session</h2>
                        <p class="text-sm text-zinc-500 flex items-center gap-2 mt-1">
                            <Clock :size="16" />
                            {{ formatDateTime(current.opened_at) }}
                        </p>
                    </div>
                    <div class="px-4 py-2 bg-green-100 dark:bg-green-900/20 text-green-700 dark:text-green-400 rounded-full text-sm font-medium">
                        Open
                    </div>
                </div>

                <!-- Session Stats -->
                <div class="grid grid-cols-2 gap-4 mb-6">
                    <div class="p-4 bg-zinc-50 dark:bg-zinc-800/50 rounded-lg">
                        <p class="text-xs text-zinc-500 mb-1">Opening Balance</p>
                        <p class="text-lg font-bold text-zinc-900 dark:text-white">{{ formatCurrency(current.opening_balance) }}</p>
                    </div>
                    <div class="p-4 bg-zinc-50 dark:bg-zinc-800/50 rounded-lg">
                        <p class="text-xs text-zinc-500 mb-1">Expected Balance</p>
                        <p class="text-lg font-bold text-zinc-900 dark:text-white">{{ formatCurrency(current.expected_balance) }}</p>
                    </div>
                </div>

                <!-- Close Form -->
                <form @submit.prevent="submitClose" class="space-y-4">
                    <div>
                        <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300 mb-2">
                            Closing Cash Count (Actual)
                        </label>
                        <input 
                            v-model="closeForm.closing_balance" 
                            type="number" 
                            step="100"
                            class="w-full px-4 py-3 rounded-lg border border-gray-300 dark:border-zinc-700 bg-white dark:bg-zinc-800 text-zinc-900 dark:text-white focus:ring-2 focus:ring-red-500 focus:border-transparent"
                            required
                        />
                    </div>

                    <!-- Live Variance Display -->
                    <div v-if="closeForm.closing_balance > 0" class="p-4 bg-zinc-50 dark:bg-zinc-800/50 rounded-lg border-2 border-dashed" :class="varianceColor">
                        <div class="flex items-center justify-between">
                            <span class="font-medium">Variance:</span>
                            <span class="text-xl font-bold">{{ formatCurrency(variance) }}</span>
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300 mb-2">
                            Closing Notes (Optional)
                        </label>
                        <textarea 
                            v-model="closeForm.notes"
                            rows="3"
                            class="w-full px-4 py-3 rounded-lg border border-gray-300 dark:border-zinc-700 bg-white dark:bg-zinc-800 text-zinc-900 dark:text-white focus:ring-2 focus:ring-red-500 focus:border-transparent"
                        ></textarea>
                    </div>

                    <button 
                        type="submit"
                        :disabled="closeForm.processing"
                        class="w-full bg-gradient-to-r from-red-600 to-rose-600 text-white font-bold py-3 rounded-lg hover:from-red-700 hover:to-rose-700 transition-all shadow-lg shadow-red-500/20 disabled:opacity-50"
                    >
                        {{ closeForm.processing ? 'Closing...' : 'Close Drawer & End Session' }}
                    </button>
                </form>
            </div>

            <!-- History Section -->
            <div v-if="history && history.data.length > 0" class="bg-white dark:bg-zinc-900 p-6 rounded-xl border border-gray-100 dark:border-zinc-800 shadow-sm">
                <h3 class="text-lg font-bold text-zinc-900 dark:text-white mb-4 flex items-center gap-2">
                    <History :size="20" />
                    Session History
                </h3>

                <div class="space-y-3">
                    <div 
                        v-for="session in history.data" 
                        :key="session.id"
                        class="p-4 bg-zinc-50 dark:bg-zinc-800/50 rounded-lg hover:bg-zinc-100 dark:hover:bg-zinc-800 transition-colors"
                    >
                        <div class="flex items-center justify-between mb-2">
                            <span class="text-sm text-zinc-500">{{ formatDateTime(session.opened_at) }}</span>
                            <span 
                                class="text-sm font-medium"
                                :class="Math.abs(session.variance) < 1000 ? 'text-green-600' : 'text-red-600'"
                            >
                                Variance: {{ formatCurrency(session.variance) }}
                            </span>
                        </div>
                        <div class="grid grid-cols-3 gap-2 text-xs">
                            <div>
                                <span class="text-zinc-500">Opening:</span>
                                <span class="font-medium text-zinc-900 dark:text-white ml-1">{{ formatCurrency(session.opening_balance) }}</span>
                            </div>
                            <div>
                                <span class="text-zinc-500">Expected:</span>
                                <span class="font-medium text-zinc-900 dark:text-white ml-1">{{ formatCurrency(session.expected_balance) }}</span>
                            </div>
                            <div>
                                <span class="text-zinc-500">Actual:</span>
                                <span class="font-medium text-zinc-900 dark:text-white ml-1">{{ formatCurrency(session.closing_balance) }}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </MainLayout>
</template>
