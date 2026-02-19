<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head, router } from '@inertiajs/vue3';
import { ref, watch } from 'vue';
import debounce from 'lodash/debounce';
import { 
    FileText, Calendar, Download, 
    ArrowUpRight, ArrowDownRight, TrendingUp,
    PieChart, Wallet, CreditCard, Landmark
} from 'lucide-vue-next';

const props = defineProps({
    data: Object,
    filters: Object
});

const filters = ref({
    start_date: props.filters.start_date,
    end_date: props.filters.end_date,
    tab: props.filters.tab || 'pl'
});

const formatCurrency = (val) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', minimumFractionDigits: 0 }).format(val);

const updateFilters = debounce(() => {
    router.get(route('financial.reports'), filters.value, { preserveState: true, replace: true });
}, 300);

watch(filters, updateFilters, { deep: true });

const switchTab = (tab) => {
    filters.value.tab = tab;
};
</script>

<template>
    <Head title="Financial Reports" />

    <MainLayout title="Financial Intelligence">
        <div class="space-y-8 pb-20">
            <!-- Header & Period Selector -->
            <div class="flex flex-col md:flex-row md:items-center justify-between gap-6">
                <div>
                    <h2 class="text-xl font-black text-zinc-900 dark:text-white flex items-center gap-2">
                    <BarChart3 class="text-red-600" />
                    Financial Reports
                </h2>
                    <p class="text-zinc-500">Official Profit & Loss and Balance Sheet analysis</p>
                </div>

                <div class="flex items-center gap-4 bg-white dark:bg-zinc-900 p-2 rounded-2xl border border-zinc-200 dark:border-zinc-800 shadow-sm">
                    <div class="flex items-center gap-2 px-3 border-r border-zinc-100 dark:border-zinc-800">
                        <Calendar :size="16" class="text-zinc-400" />
                        <input v-model="filters.start_date" type="date" class="bg-transparent border-none text-xs font-bold focus:ring-0">
                    </div>
                    <div class="flex items-center gap-2 px-3">
                        <input v-model="filters.end_date" type="date" class="bg-transparent border-none text-xs font-bold focus:ring-0">
                    </div>
                </div>
            </div>

            <!-- Tab Switcher -->
            <div class="flex bg-zinc-100 dark:bg-zinc-950 p-1.5 rounded-2xl w-fit">
                <button @click="switchTab('pl')" 
                        :class="['px-6 py-2.5 rounded-xl text-xs font-black uppercase tracking-widest transition-all', 
                                 filters.tab === 'pl' ? 'bg-white dark:bg-zinc-800 text-indigo-600 shadow-sm' : 'text-zinc-500 hover:text-zinc-900 dark:hover:text-zinc-300']">
                    Profit & Loss
                </button>
                <button @click="switchTab('bs')" 
                        :class="['px-6 py-2.5 rounded-xl text-xs font-black uppercase tracking-widest transition-all', 
                                 filters.tab === 'bs' ? 'bg-white dark:bg-zinc-800 text-indigo-600 shadow-sm' : 'text-zinc-500 hover:text-zinc-900 dark:hover:text-zinc-300']">
                    Balance Sheet
                </button>
            </div>

            <!-- Profit & Loss Content -->
            <div v-if="filters.tab === 'pl'" class="space-y-8 animate-in fade-in slide-in-from-bottom-2 duration-500">
                <!-- Summary KPI -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div class="bg-indigo-600 text-white p-6 rounded-3xl shadow-xl shadow-indigo-600/20 relative overflow-hidden group">
                        <div class="text-[10px] font-black uppercase tracking-[0.2em] opacity-80 mb-2">Total Operating Revenue</div>
                        <div class="text-3xl font-black">{{ formatCurrency(data.totalRevenue) }}</div>
                        <TrendingUp class="absolute -right-4 -bottom-4 size-32 opacity-10 group-hover:scale-110 transition-transform" />
                    </div>
                    <div class="bg-white dark:bg-zinc-900 p-6 rounded-3xl border border-zinc-200 dark:border-zinc-800 shadow-sm">
                        <div class="text-[10px] font-black text-zinc-400 uppercase tracking-[0.2em] mb-2">Total Operating Expenses</div>
                        <div class="text-3xl font-black text-zinc-900 dark:text-white text-red-500">{{ formatCurrency(data.totalExpense) }}</div>
                    </div>
                    <div class="bg-emerald-500 text-white p-6 rounded-3xl shadow-xl shadow-emerald-600/20 relative overflow-hidden group">
                        <div class="text-[10px] font-black uppercase tracking-[0.2em] opacity-80 mb-2">Net Period Profit</div>
                        <div class="text-3xl font-black">{{ formatCurrency(data.netProfit) }}</div>
                        <TrendingUp class="absolute -right-4 -bottom-4 size-32 opacity-10 group-hover:scale-110 transition-transform" />
                    </div>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                    <!-- Revenue Breakdown -->
                    <div class="bg-white dark:bg-zinc-900 rounded-3xl border border-zinc-200 dark:border-zinc-800 shadow-sm overflow-hidden">
                        <div class="px-8 py-6 border-b border-zinc-100 dark:border-zinc-800 flex items-center justify-between">
                            <h3 class="font-black uppercase tracking-widest text-sm text-zinc-900 dark:text-white">Revenue Accounts</h3>
                            <ArrowUpRight class="text-emerald-500" :size="20" />
                        </div>
                        <div class="p-8 space-y-4">
                            <div v-for="acc in data.revenues" :key="acc.code" class="flex justify-between items-center group">
                                <div>
                                    <div class="text-sm font-bold text-zinc-900 dark:text-white">{{ acc.name }}</div>
                                    <div class="text-[10px] text-zinc-400 font-mono">{{ acc.code }}</div>
                                </div>
                                <div class="text-sm font-black text-emerald-600 dark:text-emerald-400">{{ formatCurrency(acc.balance) }}</div>
                            </div>
                        </div>
                    </div>

                    <!-- Expense Breakdown -->
                    <div class="bg-white dark:bg-zinc-900 rounded-3xl border border-zinc-200 dark:border-zinc-800 shadow-sm overflow-hidden">
                        <div class="px-8 py-6 border-b border-zinc-100 dark:border-zinc-800 flex items-center justify-between">
                            <h3 class="font-black uppercase tracking-widest text-sm text-zinc-900 dark:text-white">Expense Accounts</h3>
                            <ArrowDownRight class="text-red-500" :size="20" />
                        </div>
                        <div class="p-8 space-y-4">
                            <div v-for="acc in data.expenses" :key="acc.code" class="flex justify-between items-center group">
                                <div>
                                    <div class="text-sm font-bold text-zinc-900 dark:text-white">{{ acc.name }}</div>
                                    <div class="text-[10px] text-zinc-400 font-mono">{{ acc.code }}</div>
                                </div>
                                <div class="text-sm font-black text-red-600 dark:text-red-400">{{ formatCurrency(acc.balance) }}</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Balance Sheet Content -->
            <div v-if="filters.tab === 'bs'" class="space-y-8 animate-in fade-in slide-in-from-bottom-2 duration-500">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <!-- Assets -->
                    <div class="space-y-4">
                        <div class="flex items-start justify-between mb-4">
                        <div class="w-12 h-12 bg-red-50 dark:bg-red-900/20 rounded-xl flex items-center justify-center text-red-600 dark:text-red-400 font-bold text-lg">
                            <TrendingUp :size="24" />
                        </div>
                            <h3 class="font-black uppercase tracking-widest text-sm">Tangible Assets</h3>
                        </div>
                        <div v-for="acc in data.assets" :key="acc.code" class="p-5 bg-white dark:bg-zinc-900 rounded-2xl border border-zinc-200 dark:border-zinc-800 hover:shadow-lg transition-all group">
                            <div class="text-[10px] font-mono text-zinc-400 mb-1">{{ acc.code }}</div>
                            <div class="text-sm font-bold text-zinc-900 dark:text-white mb-2">{{ acc.name }}</div>
                            <div class="text-lg font-black text-red-600 dark:text-red-400">{{ formatCurrency(acc.balance) }}</div>
                        </div>
                    </div>

                    <!-- Liabilities -->
                     <div class="space-y-4">
                        <div class="flex items-center gap-3 mb-6">
                            <button class="bg-red-600 hover:bg-red-700 text-white px-6 h-11 rounded-xl flex items-center gap-2 font-bold shadow-lg shadow-red-600/20 transition-all">
                    <Download :size="18" />
                    Export Report
                </button>            <h3 class="font-black uppercase tracking-widest text-sm">Liabilities</h3>
                        </div>
                        <div v-for="acc in data.liabilities" :key="acc.code" class="p-5 bg-white dark:bg-zinc-900 rounded-2xl border border-zinc-200 dark:border-zinc-800 hover:shadow-lg transition-all">
                            <div class="text-[10px] font-mono text-zinc-400 mb-1">{{ acc.code }}</div>
                            <div class="text-sm font-bold text-zinc-900 dark:text-white mb-2">{{ acc.name }}</div>
                            <div class="text-lg font-black text-red-600 dark:text-red-400">{{ formatCurrency(acc.balance) }}</div>
                        </div>
                    </div>

                    <!-- Equity -->
                     <div class="space-y-4">
                        <div class="flex items-start justify-between mb-4">
                        <div class="w-12 h-12 bg-red-50 dark:bg-red-900/20 rounded-xl flex items-center justify-center text-red-600 dark:text-red-400 font-bold text-lg">
                            <DollarSign :size="24" />
                        </div>
                            <h3 class="font-black uppercase tracking-widest text-sm">Owner Equity</h3>
                        </div>
                        <div v-for="acc in data.equity" :key="acc.code" class="p-5 bg-white dark:bg-zinc-900 rounded-2xl border border-zinc-200 dark:border-zinc-800 hover:shadow-lg transition-all">
                            <div class="text-[10px] font-mono text-zinc-400 mb-1">{{ acc.code }}</div>
                            <div class="text-sm font-bold text-zinc-900 dark:text-white mb-2">{{ acc.name }}</div>
                            <div class="text-lg font-black text-red-600 dark:text-red-400">{{ formatCurrency(acc.balance) }}</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </MainLayout>
</template>
