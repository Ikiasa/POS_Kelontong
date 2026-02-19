<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head, router } from '@inertiajs/vue3';
import { Truck, CheckCircle2, XCircle, ArrowRight, User, Calendar, FileText } from 'lucide-vue-next';

const props = defineProps({
    transfer: Object
});

const getStatusColor = (status) => {
    switch (status) {
        case 'pending': return 'bg-yellow-100 text-yellow-700 dark:bg-yellow-900/30 dark:text-yellow-400 border-yellow-200 dark:border-yellow-800';
        case 'completed': return 'bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400 border-green-200 dark:border-green-800';
        case 'cancelled': return 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400 border-red-200 dark:border-red-800';
        default: return 'bg-zinc-100 text-zinc-700 dark:bg-zinc-800';
    }
};

const approve = () => {
    if (confirm('Approve this transfer? Stock will be updated immediately.')) {
        router.put(route('stock-transfers.approve', props.transfer.id));
    }
};

const reject = () => {
    if (confirm('Reject this transfer?')) {
        router.put(route('stock-transfers.reject', props.transfer.id));
    }
};
</script>

<template>
    <Head :title="`Transfer #${transfer.transfer_number}`" />

    <MainLayout title="Transfer Details">
        <div class="max-w-5xl mx-auto space-y-6">
            <!-- Header -->
            <div class="flex items-center justify-between">
                <div>
                     <h2 class="text-xl font-black text-zinc-900 dark:text-white flex items-center gap-2">
                        <Truck class="text-red-600" />
                        Transfer #{{ transfer.transfer_number }}
                    </h2>
                    <p class="text-sm text-zinc-500">
                        {{ new Date(transfer.created_at).toLocaleString() }}
                    </p>
                </div>
                <div class="flex items-center gap-4">
                    <span class="px-3 py-1 rounded-full text-xs font-black uppercase tracking-widest border" :class="getStatusColor(transfer.status)">
                        {{ transfer.status }}
                    </span>
                    
                    <template v-if="transfer.status === 'pending'">
                        <button @click="reject" class="px-4 py-2 bg-white dark:bg-zinc-800 text-zinc-700 dark:text-zinc-300 border border-zinc-200 dark:border-zinc-700 rounded-xl font-bold hover:text-red-600 hover:border-red-200 transition-colors flex items-center gap-2">
                            <XCircle :size="18" /> Reject
                        </button>
                        <button @click="approve" class="px-4 py-2 bg-green-600 hover:bg-green-700 text-white rounded-xl font-bold shadow-lg shadow-green-600/20 transition-all flex items-center gap-2">
                            <CheckCircle2 :size="18" /> Approve
                        </button>
                    </template>
                </div>
            </div>

            <!-- Route & Info -->
            <div class="bg-white dark:bg-zinc-900 rounded-xl border border-zinc-200 dark:border-zinc-800 p-6 shadow-sm">
                <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                    <div class="space-y-1">
                        <h3 class="text-xs font-bold text-zinc-500 uppercase tracking-widest">Source (From)</h3>
                        <p class="text-lg font-bold text-zinc-900 dark:text-white">{{ transfer.source_store?.name }}</p>
                        <p class="text-sm text-zinc-500">{{ transfer.source_store?.address || 'No Address' }}</p>
                    </div>

                    <div class="flex justify-center items-center text-zinc-300 dark:text-zinc-700">
                        <ArrowRight :size="32" />
                    </div>

                    <div class="text-right space-y-1">
                        <h3 class="text-xs font-bold text-zinc-500 uppercase tracking-widest">Destination (To)</h3>
                        <p class="text-lg font-bold text-zinc-900 dark:text-white">{{ transfer.dest_store?.name }}</p>
                        <p class="text-sm text-zinc-500">{{ transfer.dest_store?.address || 'No Address' }}</p>
                    </div>
                </div>

                <div class="mt-8 pt-8 border-t border-zinc-100 dark:border-zinc-800 grid grid-cols-2 md:grid-cols-4 gap-6">
                    <div>
                        <div class="text-xs font-bold text-zinc-400 uppercase mb-1">Created By</div>
                        <div class="flex items-center gap-2 text-sm font-medium">
                            <User :size="14" /> {{ transfer.created_by?.name }}
                        </div>
                    </div>
                    <div v-if="transfer.received_by">
                        <div class="text-xs font-bold text-zinc-400 uppercase mb-1">Received By</div>
                        <div class="flex items-center gap-2 text-sm font-medium">
                            <CheckCircle2 :size="14" class="text-green-500" /> {{ transfer.received_by?.name }}
                        </div>
                    </div>
                    <div v-if="transfer.notes" class="col-span-2">
                        <div class="text-xs font-bold text-zinc-400 uppercase mb-1">Notes</div>
                        <p class="text-sm text-zinc-600 dark:text-zinc-400 italic">"{{ transfer.notes }}"</p>
                    </div>
                </div>
            </div>

            <!-- Items Table -->
            <div class="bg-white dark:bg-zinc-900 rounded-xl border border-zinc-200 dark:border-zinc-800 overflow-hidden shadow-sm">
                <div class="px-6 py-4 border-b border-zinc-200 dark:border-zinc-800 bg-zinc-50 dark:bg-zinc-950">
                    <h3 class="font-bold text-zinc-900 dark:text-white">Items to Transfer</h3>
                </div>
                <table class="w-full text-left">
                    <thead class="bg-zinc-50/50 dark:bg-zinc-900/50 border-b border-zinc-100 dark:border-zinc-800">
                        <tr>
                            <th class="px-6 py-3 text-xs font-bold text-zinc-400 uppercase">Product</th>
                            <th class="px-6 py-3 text-xs font-bold text-zinc-400 uppercase text-right">Requested Qty</th>
                            <th class="px-6 py-3 text-xs font-bold text-zinc-400 uppercase text-right">Shipped Qty</th>
                            <th class="px-6 py-3 text-xs font-bold text-zinc-400 uppercase text-right">Received Qty</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-zinc-100 dark:divide-zinc-800/50">
                        <tr v-for="item in transfer.items" :key="item.id">
                            <td class="px-6 py-4">
                                <div class="font-bold text-zinc-900 dark:text-white">{{ item.product?.name }}</div>
                                <div class="text-xs text-zinc-500">{{ item.product?.barcode }}</div>
                            </td>
                            <td class="px-6 py-4 text-right font-mono font-bold">{{ item.request_quantity }}</td>
                            <td class="px-6 py-4 text-right font-mono text-zinc-600 dark:text-zinc-400">{{ item.shipped_quantity || '-' }}</td>
                            <td class="px-6 py-4 text-right font-mono text-zinc-600 dark:text-zinc-400">{{ item.received_quantity || '-' }}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </MainLayout>
</template>
