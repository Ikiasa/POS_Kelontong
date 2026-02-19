<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head } from '@inertiajs/vue3';
import { 
    ShieldAlert, 
    BarChartHorizontal, 
    Truck, 
    TrendingUp,
    AlertCircle,
    ArrowUpRight,
    ArrowDownRight,
    Layers
} from 'lucide-vue-next';

const props = defineProps({
    consolidated: Object,
    marginViolations: Array,
    replenishment: Array,
    branches: Array
});

const formatCurrency = (value) => {
    return new Intl.NumberFormat('id-ID', {
        style: 'currency',
        currency: 'IDR',
        minimumFractionDigits: 0
    }).format(value || 0);
};
</script>

<template>
    <Head title="HQ Intelligence Hub" />

    <MainLayout title="HQ Intelligence Hub">
        <div class="space-y-8">
            <!-- Header Group Metrics -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                <div class="bg-white dark:bg-zinc-900 p-6 rounded-3xl border border-gray-100 dark:border-zinc-800 shadow-sm relative overflow-hidden group">
                    <div class="absolute top-0 right-0 p-4 opacity-5 group-hover:scale-110 transition-transform">
                        <TrendingUp :size="80" />
                    </div>
                    <h3 class="text-xs font-bold text-zinc-500 uppercase tracking-widest mb-1">Net Group Performance</h3>
                    <p class="text-2xl font-black text-emerald-600 tracking-tight">{{ formatCurrency(consolidated.net_group_performance) }}</p>
                    <div class="mt-4 flex items-center gap-1 text-[10px] font-bold text-emerald-600 bg-emerald-50 dark:bg-emerald-900/20 px-2 py-0.5 rounded-full w-fit">
                        <ArrowUpRight :size="10" /> +12.5% vs Last Month
                    </div>
                </div>

                <div class="bg-white dark:bg-zinc-900 p-6 rounded-3xl border border-gray-100 dark:border-zinc-800 shadow-sm relative overflow-hidden group">
                    <div class="absolute top-0 right-0 p-4 opacity-5 group-hover:scale-110 transition-transform">
                        <Layers :size="80" />
                    </div>
                    <h3 class="text-xs font-bold text-zinc-500 uppercase tracking-widest mb-1">Internal Eliminations</h3>
                    <p class="text-2xl font-black text-red-500 tracking-tight">{{ formatCurrency(consolidated.internal_elimination) }}</p>
                    <p class="text-[10px] text-zinc-400 mt-2 font-medium">Inter-branch transfers removed</p>
                </div>

                <div class="bg-white dark:bg-zinc-900 p-6 rounded-3xl border border-gray-100 dark:border-zinc-800 shadow-sm relative overflow-hidden group">
                    <div class="absolute top-0 right-0 p-4 opacity-5 group-hover:scale-110 transition-transform">
                        <ShieldAlert :size="80" />
                    </div>
                    <h3 class="text-xs font-bold text-zinc-500 uppercase tracking-widest mb-1">Margin Guard Alerts</h3>
                    <p class="text-2xl font-black text-zinc-900 dark:text-zinc-100 tracking-tight">{{ marginViolations.length }} Critical</p>
                    <div class="mt-4 flex items-center gap-1 text-[10px] font-bold text-red-600 bg-red-50 dark:bg-red-900/20 px-2 py-0.5 rounded-full w-fit">
                        <AlertCircle :size="10" /> Action Required
                    </div>
                </div>

                <div class="bg-white dark:bg-zinc-900 p-6 rounded-3xl border border-gray-100 dark:border-zinc-800 shadow-sm relative overflow-hidden group">
                    <div class="absolute top-0 right-0 p-4 opacity-5 group-hover:scale-110 transition-transform">
                        <Truck :size="80" />
                    </div>
                    <h3 class="text-xs font-bold text-zinc-500 uppercase tracking-widest mb-1">DC Replenishment</h3>
                    <p class="text-2xl font-black text-zinc-900 dark:text-zinc-100 tracking-tight">{{ replenishment.length }} Items</p>
                    <p class="text-[10px] text-zinc-400 mt-2 font-medium">Pending allocations from DC</p>
                </div>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                <!-- Branch Performance Leaderboard -->
                <div class="bg-white dark:bg-zinc-900 p-8 rounded-3xl border border-gray-100 dark:border-zinc-800 shadow-sm">
                    <div class="flex items-center justify-between mb-8">
                        <div>
                            <h3 class="text-xl font-black tracking-tight text-zinc-900 dark:text-zinc-100">Branch Leaderboard</h3>
                            <p class="text-sm text-zinc-500 font-medium">Real-time performance by store</p>
                        </div>
                        <BarChartHorizontal :size="24" class="text-zinc-400" />
                    </div>

                    <div class="space-y-6">
                        <div v-for="branch in branches" :key="branch.name" class="group">
                            <div class="flex items-center justify-between mb-2">
                                <span class="font-bold text-sm text-zinc-700 dark:text-zinc-300">{{ branch.name }}</span>
                                <span class="font-black text-sm text-zinc-900 dark:text-zinc-100">{{ formatCurrency(branch.monthly_sales) }}</span>
                            </div>
                            <div class="w-full h-2 bg-gray-100 dark:bg-zinc-800 rounded-full overflow-hidden shadow-inner">
                                <div class="h-full rounded-full transition-all duration-1000 ease-out"
                                     :class="branch.status === 'healthy' ? 'bg-gradient-to-r from-emerald-500 to-teal-400' : 'bg-gradient-to-r from-orange-500 to-amber-400'"
                                     :style="{ width: Math.min((branch.monthly_sales / 20000000) * 100, 100) + '%' }">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Margin Safeguard Panel -->
                <div class="bg-white dark:bg-zinc-900 p-8 rounded-3xl border border-gray-100 dark:border-zinc-800 shadow-sm border-l-4 border-l-red-600">
                    <div class="flex items-center justify-between mb-8">
                        <div>
                            <h3 class="text-xl font-black tracking-tight text-red-800 dark:text-red-400">Margin Safeguard</h3>
                            <p class="text-sm text-zinc-500 font-medium">Profit leakage detection system</p>
                        </div>
                        <ShieldAlert :size="24" class="text-red-600 animate-pulse" />
                    </div>

                    <div class="overflow-hidden">
                        <table class="w-full text-left">
                            <thead class="bg-gray-50 dark:bg-zinc-800/50">
                                <tr>
                                    <th class="px-4 py-3 text-[10px] font-black text-zinc-500 uppercase tracking-widest">Product</th>
                                    <th class="px-4 py-3 text-[10px] font-black text-zinc-500 uppercase tracking-widest text-right">Current</th>
                                    <th class="px-4 py-3 text-[10px] font-black text-zinc-500 uppercase tracking-widest text-right">Target</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-100 dark:divide-zinc-800">
                                <tr v-for="item in marginViolations" :key="item.id" class="hover:bg-red-50/50 dark:hover:bg-red-950/10 transition-colors group">
                                    <td class="px-4 py-4">
                                        <div class="font-bold text-xs text-zinc-800 dark:text-zinc-200">{{ item.name }}</div>
                                        <div class="text-[9px] text-zinc-400 uppercase font-black">{{ item.store }}</div>
                                    </td>
                                    <td class="px-4 py-4 text-right">
                                        <span class="text-xs font-black text-red-600">{{ item.margin }}%</span>
                                    </td>
                                    <td class="px-4 py-4 text-right">
                                        <span class="text-xs font-bold text-emerald-600">{{ item.target_margin }}%</span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Replenishment Warnings -->
            <div class="bg-gradient-to-br from-indigo-900 to-brand-900 p-8 rounded-[2.5rem] text-white shadow-2xl relative overflow-hidden">
                <div class="absolute -right-20 -bottom-20 w-80 h-80 bg-white/5 rounded-full blur-3xl opacity-50"></div>
                <div class="relative z-10 flex flex-col md:flex-row items-center justify-between gap-8">
                    <div class="max-w-xl">
                        <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-indigo-500/20 text-indigo-200 text-[10px] font-black uppercase tracking-widest border border-indigo-400/30 mb-4">
                            Logistics AI
                        </div>
                        <h2 class="text-3xl font-black mb-4 leading-tight tracking-tight">Enterprise Replenishment</h2>
                        <p class="text-indigo-100/80 text-sm leading-relaxed font-medium">Sistem mendeteksi {{ replenishment.length }} item di gudang cabang yang berada di bawah level aman. HQ Replenishment Service sedang menyiapkan alokasi stok otomatis untuk menyeimbangkan inventori grup.</p>
                    </div>
                    <div class="w-full md:w-64 space-y-3">
                         <button class="w-full py-4 bg-white text-indigo-900 rounded-2xl font-black text-sm shadow-xl hover:scale-105 transition-transform active:scale-95">
                            Approve All Allocations
                        </button>
                        <button class="w-full py-4 bg-indigo-800/50 text-indigo-100 border border-indigo-700 rounded-2xl font-black text-sm hover:bg-indigo-800 transition-colors">
                            Review Stock Alerts
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </MainLayout>
</template>
