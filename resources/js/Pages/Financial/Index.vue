<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head, router } from '@inertiajs/vue3';
import { 
    Wallet, TrendingUp, AlertCircle, 
    Calendar, CheckCircle2, ArrowRight,
    PieChart, DollarSign
} from 'lucide-vue-next';

const props = defineProps({
    overdueInstallments: Array,
    agingReport: Object,
    budgetStatus: Array
});

const formatCurrency = (val) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', minimumFractionDigits: 0 }).format(val);
</script>

<template>
    <Head title="Financial Insights" />

    <MainLayout title="Financial Control Center">
        <div class="space-y-6">
            <!-- Top Stats -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                <div class="bg-white dark:bg-zinc-900 p-6 rounded-2xl border border-zinc-200 dark:border-zinc-800 shadow-sm">
                    <div class="flex items-start justify-between mb-4">
                        <div class="w-12 h-12 bg-red-50 dark:bg-red-900/20 rounded-xl flex items-center justify-center text-red-600 dark:text-red-400 font-bold text-lg">
                            <Wallet :size="24" />
                        </div>
                    </div>
                    <div class="text-xs font-bold text-zinc-500 uppercase tracking-widest mb-1">Overdue Claims</div>
                    <div class="text-2xl font-black text-zinc-900 dark:text-white">{{ overdueInstallments.length }} Pending</div>
                </div>
                <!-- ... other stats can be added -->
            </div>

            <h2 class="text-xl font-black text-zinc-900 dark:text-white flex items-center gap-2">
                <LayoutDashboard class="text-red-600" />
                Financial Dashboard
            </h2>

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                <!-- Aging Report -->
                <div class="lg:col-span-2 space-y-6">
                    <div class="bg-white dark:bg-zinc-900 rounded-2xl border border-zinc-200 dark:border-zinc-800 p-6 shadow-sm">
                        <h3 class="font-black text-xs uppercase tracking-widest text-zinc-400 mb-6 flex items-center gap-2">
                            <Calendar :size="16" />
                            Receivables Aging Report
                        </h3>
                        <div class="grid grid-cols-2 md:grid-cols-4 gap-6">
                            <div v-for="(amount, period) in agingReport" :key="period" class="space-y-2">
                                <div class="text-[10px] font-bold text-zinc-500 uppercase tracking-wider">{{ period.replace(/_/g, ' ') }}</div>
                                <div class="text-lg font-bold text-zinc-900 dark:text-white">{{ formatCurrency(amount) }}</div>
                                <div class="w-full bg-zinc-100 dark:bg-zinc-800 rounded-full h-2 mt-4">
                                    <div class="bg-red-600 h-2 rounded-full" :style="{ width: '60%' }"></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Budget Tracking -->
                    <div class="bg-white dark:bg-zinc-900 rounded-2xl border border-zinc-200 dark:border-zinc-800 p-6 shadow-sm">
                        <h3 class="font-black text-xs uppercase tracking-widest text-zinc-400 mb-6 flex items-center gap-2">
                            <PieChart :size="16" />
                            Opex Budget Tracking
                        </h3>
                        <div class="space-y-4">
                            <div v-for="b in budgetStatus" :key="b.category" class="space-y-2">
                                <div class="flex justify-between text-sm">
                                    <span class="font-bold text-zinc-900 dark:text-white mb-1">{{ b.category }}</span>
                                    <span class="text-zinc-500">{{ formatCurrency(b.spent) }} / {{ formatCurrency(b.budget) }}</span>
                                </div>
                                <div class="h-2 bg-zinc-100 dark:bg-zinc-800 rounded-full overflow-hidden">
                                    <div class="h-full transition-all duration-1000" 
                                         :class="b.p >= 90 ? 'bg-red-500' : (b.p >= 75 ? 'bg-amber-500' : 'bg-emerald-500')"
                                         :style="{ width: b.p + '%' }"></div>
                                </div>
                                <div class="flex justify-between text-[10px] font-bold uppercase tracking-widest">
                                    <span :class="b.p >= 90 ? 'text-red-500' : 'text-zinc-400'">{{ b.p }}% Utilized</span>
                                    <span class="text-zinc-400">Remaining: {{ formatCurrency(b.remaining) }}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Overdue Installments / Action List -->
                <div class="space-y-6">
                    <div class="bg-white dark:bg-zinc-900 rounded-2xl border border-zinc-200 dark:border-zinc-800 p-6 shadow-sm">
                        <h3 class="font-black text-xs uppercase tracking-widest text-zinc-400 mb-6 flex items-center gap-2">
                            <TrendingUp :size="16" />
                            Critical Actions
                        </h3>
                        <div class="space-y-4">
                            <div v-for="inst in overdueInstallments" :key="inst.id" class="p-4 bg-red-50/50 dark:bg-red-900/10 rounded-xl border border-red-100 dark:border-red-900/20">
                                <div class="flex justify-between items-start mb-2">
                                    <div class="font-bold text-zinc-900 dark:text-white text-sm">#{{ inst.id }} - Overdue Installment</div>
                                    <span class="text-[10px] bg-red-100 dark:bg-red-900/40 text-red-600 px-2 py-0.5 rounded font-bold uppercase">CRITICAL</span>
                                </div>
                                <div class="text-xs text-zinc-500 mb-3 leading-relaxed">
                                    Payment of <span class="font-bold text-zinc-900 dark:text-zinc-300">{{ formatCurrency(inst.amount) }}</span> was expected on {{ new Date(inst.due_date).toLocaleDateString() }}.
                                </div>
                                <button class="w-full h-9 bg-white dark:bg-zinc-800 border border-red-200 dark:border-red-900/30 text-red-600 rounded-lg text-xs font-bold hover:bg-red-50 transition-colors flex items-center justify-center gap-2">
                                    Record Payment <ArrowRight :size="14" />
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </MainLayout>
</template>
