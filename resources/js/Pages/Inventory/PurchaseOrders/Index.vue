<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head, router } from '@inertiajs/vue3';
import { ShoppingCart, Clock, CheckCircle, Package, Plus, Search, ChevronRight } from 'lucide-vue-next';

const props = defineProps({
    orders: Object
});

const getStatusColor = (status) => {
    switch (status) {
        case 'draft': return 'bg-zinc-100 text-zinc-600 dark:bg-zinc-800 dark:text-zinc-400';
        case 'ordered': return 'bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400';
        case 'received': return 'bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400';
        case 'cancelled': return 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400';
        default: return 'bg-zinc-100 text-zinc-700 dark:bg-zinc-800';
    }
};

const formatCurrency = (val) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', minimumFractionDigits: 0 }).format(val);
</script>

<template>
    <Head title="Purchase Orders" />

    <MainLayout title="Inventory Procurement">
        <div class="space-y-6">
            <!-- Header -->
            <div class="flex items-center justify-between">
                <div>
                    <h2 class="text-xl font-black text-zinc-900 dark:text-white flex items-center gap-2">
                        <ShoppingCart class="text-red-600" />
                        Purchase Orders
                    </h2>
                    <p class="text-sm text-zinc-500">Manage supplier orders and stock intake</p>
                </div>
                <Link :href="route('purchase-orders.create')" 
                        class="bg-red-600 hover:bg-red-700 text-white px-6 h-11 rounded-xl flex items-center gap-2 font-bold shadow-lg shadow-red-600/20 transition-all">
                    <Plus :size="18" />
                    New Order
                </Link>
            </div>

            <!-- Stats Bar -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div class="group bg-white dark:bg-zinc-900 rounded-2xl border border-zinc-200 dark:border-zinc-800 p-6 hover:shadow-xl hover:shadow-red-500/5 transition-all relative overflow-hidden">
                    
                    <div class="flex items-start justify-between mb-4">
                        <div class="w-12 h-12 bg-red-50 dark:bg-red-900/20 rounded-xl flex items-center justify-center text-red-600 dark:text-red-400 font-bold text-lg">
                            <ShoppingCart :size="20" />
                        </div>
                    </div>
                    <div>
                        <div class="text-zinc-500 text-xs font-medium uppercase tracking-wider">Total Active</div>
                        <div class="text-xl font-bold dark:text-white">{{ orders.total }} Orders</div>
                    </div>
                </div>
                <!-- Add more stats if needed -->
            </div>

            <!-- Orders List -->
            <div class="bg-white dark:bg-zinc-900 rounded-xl border border-zinc-200 dark:border-zinc-800 overflow-hidden shadow-sm">
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-zinc-50 dark:bg-zinc-950 px-6 py-4 border-b border-zinc-200 dark:border-zinc-800">
                                <th class="px-6 py-4 text-xs font-bold text-zinc-400 uppercase tracking-widest">Order ID</th>
                                <th class="px-6 py-4 text-xs font-bold text-zinc-400 uppercase tracking-widest">Supplier</th>
                                <th class="px-6 py-4 text-xs font-bold text-zinc-400 uppercase tracking-widest">Status</th>
                                <th class="px-6 py-4 text-xs font-bold text-zinc-400 uppercase tracking-widest text-right">Total Amount</th>
                                <th class="px-6 py-4 text-xs font-bold text-zinc-400 uppercase tracking-widest">Expected</th>
                                <th class="px-6 py-4 text-xs font-bold text-zinc-400 uppercase tracking-widest text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-zinc-100 dark:divide-zinc-800/50">
                            <tr v-for="order in orders.data" :key="order.id" class="hover:bg-zinc-50/50 dark:hover:bg-zinc-800/30 transition-colors">
                            <td class="px-6 py-4 font-mono font-bold text-indigo-600 dark:text-indigo-400 text-sm">
                                #PO-{{ order.id.toString().padStart(5, '0') }}
                            </td>
                            <td class="px-6 py-4">
                                <div class="font-bold text-zinc-900 dark:text-white">{{ order.supplier?.name || 'Unknown' }}</div>
                                <div class="text-xs text-zinc-500">Items: {{ order.items?.length || 0 }}</div>
                            </td>
                            <td class="px-6 py-4">
                                <span class="px-2.5 py-1 rounded-full text-[10px] font-black uppercase tracking-widest" :class="getStatusColor(order.status)">
                                    {{ order.status }}
                                </span>
                            </td>
                            <td class="px-6 py-4 text-right font-bold text-zinc-900 dark:text-white">
                                {{ formatCurrency(order.total_amount) }}
                            </td>
                            <td class="px-6 py-4 text-xs text-zinc-500">
                                {{ order.expected_at ? new Date(order.expected_at).toLocaleDateString() : 'N/A' }}
                            </td>
                            <td class="px-6 py-4 text-center">
                                <button class="p-2 text-zinc-400 hover:text-indigo-600 hover:bg-zinc-100 dark:hover:bg-zinc-800 rounded-lg transition-all">
                                    <ChevronRight :size="18" />
                                </button>
                            </td>
                            </tr>
                            <tr v-if="orders.data.length === 0">
                                <td colspan="6" class="px-6 py-12 text-center text-zinc-500 italic">
                                    No purchase orders found.
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Simple Pagination -->
                <div v-if="orders.links.length > 3" class="px-6 py-4 border-t border-zinc-100 dark:border-zinc-800 flex justify-center gap-2">
                    <button v-for="link in orders.links" :key="link.label"
                            @click="link.url && router.visit(link.url)"
                            v-html="link.label"
                            :disabled="!link.url"
                            class="px-3 py-1 text-sm rounded-lg border transition-all"
                            :class="link.active 
                                ? 'bg-indigo-600 border-indigo-600 text-white font-bold' 
                                : 'border-zinc-200 dark:border-zinc-700 text-zinc-600 dark:text-zinc-400 hover:bg-zinc-50 dark:hover:bg-zinc-800 disabled:opacity-30'">
                    </button>
                </div>
            </div>
        </div>
    </MainLayout>
</template>
