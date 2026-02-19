<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head, router, Link } from '@inertiajs/vue3';
import { Truck, Plus, ChevronRight, CheckCircle2, XCircle, Clock, ArrowRight } from 'lucide-vue-next';

defineProps({
    transfers: Object
});

const getStatusColor = (status) => {
    switch (status) {
        case 'pending': return 'bg-yellow-100 text-yellow-700 dark:bg-yellow-900/30 dark:text-yellow-400';
        case 'approved': 
        case 'completed': return 'bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400';
        case 'rejected': 
        case 'cancelled': return 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400';
        default: return 'bg-zinc-100 text-zinc-700 dark:bg-zinc-800';
    }
};

const formatDate = (dateString) => {
    return new Date(dateString).toLocaleDateString('id-ID', {
        day: 'numeric', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit'
    });
};
</script>

<template>
    <Head title="Stock Transfers" />

    <MainLayout title="Inventory Management">
        <div class="space-y-6">
            <!-- Header -->
            <div class="flex items-center justify-between">
                <div>
                    <h2 class="text-xl font-black text-zinc-900 dark:text-white flex items-center gap-2">
                        <Truck class="text-red-600" />
                        Stock Transfers
                    </h2>
                    <p class="text-sm text-zinc-500">Move inventory between stores and warehouses</p>
                </div>
                <Link :href="route('stock-transfers.create')" 
                        class="bg-red-600 hover:bg-red-700 text-white px-6 h-11 rounded-xl flex items-center gap-2 font-bold shadow-lg shadow-red-600/20 transition-all">
                    <Plus :size="18" />
                    New Transfer
                </Link>
            </div>

            <!-- List -->
            <div class="bg-white dark:bg-zinc-900 rounded-xl border border-zinc-200 dark:border-zinc-800 overflow-hidden shadow-sm">
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-zinc-50 dark:bg-zinc-950 px-6 py-4 border-b border-zinc-200 dark:border-zinc-800">
                                <th class="px-6 py-4 text-xs font-bold text-zinc-400 uppercase tracking-widest">Transfer ID</th>
                                <th class="px-6 py-4 text-xs font-bold text-zinc-400 uppercase tracking-widest">Route</th>
                                <th class="px-6 py-4 text-xs font-bold text-zinc-400 uppercase tracking-widest">Status</th>
                                <th class="px-6 py-4 text-xs font-bold text-zinc-400 uppercase tracking-widest">Created By</th>
                                <th class="px-6 py-4 text-xs font-bold text-zinc-400 uppercase tracking-widest">Date</th>
                                <th class="px-6 py-4 text-xs font-bold text-zinc-400 uppercase tracking-widest text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-zinc-100 dark:divide-zinc-800/50">
                            <tr v-for="transfer in transfers.data" :key="transfer.id" class="hover:bg-zinc-50/50 dark:hover:bg-zinc-800/30 transition-colors">
                                <td class="px-6 py-4 font-mono font-bold text-red-600 dark:text-red-400 text-sm">
                                    {{ transfer.transfer_number }}
                                </td>
                                <td class="px-6 py-4">
                                    <div class="flex items-center gap-2 text-sm font-medium text-zinc-900 dark:text-white">
                                        <span>{{ transfer.source_store?.name || 'Unknown' }}</span>
                                        <ArrowRight :size="14" class="text-zinc-400" />
                                        <span>{{ transfer.dest_store?.name || 'Unknown' }}</span>
                                    </div>
                                </td>
                                <td class="px-6 py-4">
                                    <span class="px-2.5 py-1 rounded-full text-[10px] font-black uppercase tracking-widest border border-transparent" 
                                          :class="getStatusColor(transfer.status)">
                                        {{ transfer.status }}
                                    </span>
                                </td>
                                <td class="px-6 py-4 text-sm text-zinc-600 dark:text-zinc-400">
                                    {{ transfer.created_by?.name || 'System' }}
                                </td>
                                <td class="px-6 py-4 text-xs text-zinc-500">
                                    {{ formatDate(transfer.created_at) }}
                                </td>
                                <td class="px-6 py-4 text-center">
                                    <Link :href="route('stock-transfers.show', transfer.id)" 
                                          class="inline-flex p-2 text-zinc-400 hover:text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition-all">
                                        <ChevronRight :size="18" />
                                    </Link>
                                </td>
                            </tr>
                            <tr v-if="transfers.data.length === 0">
                                <td colspan="6" class="px-6 py-12 text-center text-zinc-500 italic">
                                    No stock transfers recorded yet.
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </MainLayout>
</template>
