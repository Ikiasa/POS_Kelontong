<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head } from '@inertiajs/vue3';
import { 
    TrendingUp, 
    Package, 
    Users, 
    Database, 
    Sparkles,
    ShieldAlert,
    BarChartHorizontal,
    Activity,
    ArrowUpRight,
    ArrowDownRight,
    Clock,
    DollarSign,
    Percent,
    AlertCircle
} from 'lucide-vue-next';
import HealthWidget from '@/Components/Dashboard/HealthWidget.vue';
import LeakWarningPanel from '@/Components/Dashboard/LeakWarningPanel.vue';
import AlertCenter from '@/Components/Dashboard/AlertCenter.vue';
import SalesChart from '@/Components/Dashboard/SalesChart.vue';
import ExpiryPanel from '@/Components/Assistant/ExpiryPanel.vue';
import { onMounted, onUnmounted, ref, computed } from 'vue';
import axios from 'axios';

const props = defineProps({
    totalProducts: Number,
    totalCustomers: Number,
    todaySales: Number,
    thisMonthSales: Number,
    pendingAlerts: Array,
    backupCount: Number,
    salesHistory: Object,
    topProducts: Array,
    healthScore: Object,
    riskScore: Object,
    recommendations: Array,
    cashflowProjections: Object,
    employeeRisks: Array,
    aiInsights: Array,
    pricingData: Object,
    alerts: Array,
    consolidatedData: Object,
    marginAlerts: Array
});

const formatCurrency = (value) => {
    return new Intl.NumberFormat('id-ID', {
        style: 'currency',
        currency: 'IDR',
        minimumFractionDigits: 0
    }).format(value);
};

// Reactive state for live updates
const liveTodaySales = ref(props.todaySales);
const liveTransactionCount = ref(0); 
const liveAlerts = ref(props.alerts);

let pollingInterval = null;

onMounted(() => {
    pollingInterval = setInterval(async () => {
        try {
            const response = await axios.get(route('dashboard.live'));
            liveTodaySales.value = response.data.todaySales;
            liveTransactionCount.value = response.data.todayTransactionCount;
            if (response.data.alerts && response.data.alerts.length > 0) {
                 liveAlerts.value = response.data.alerts;
            }
        } catch (error) {
            console.error('Failed to fetch live metrics', error);
        }
    }, 3000);
});

onUnmounted(() => {
    if (pollingInterval) clearInterval(pollingInterval);
});

// Mocking some enterprise metrics that might not be in props yet for UX demonstration
const netProfit = computed(() => liveTodaySales.value * 0.28); // 28% margin mock
const averageMargin = ref(32.4);
const riskyStockCount = ref(12);

</script>

<template>
    <Head title="Enterprise Dashboard" />

    <MainLayout title="Enterprise Overview">
        <div class="space-y-10 pb-12">
            
            <!-- SECTION 1: KPI POWER ROW -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                <!-- Revenue Today -->
                <div class="premium-card p-6 border-l-4 border-l-brand-600 transition-all hover:-translate-y-1">
                    <div class="flex items-center justify-between mb-2">
                        <span class="text-[10px] font-black uppercase tracking-widest text-slate-400 dark:text-zinc-500">Gross Revenue Today</span>
                        <div class="w-8 h-8 rounded-lg bg-brand-50 dark:bg-brand-900/20 flex items-center justify-center text-brand-600">
                            <DollarSign :size="16" />
                        </div>
                    </div>
                    <div class="flex items-baseline gap-2">
                        <h2 class="text-3xl font-black tracking-tight text-slate-900 dark:text-zinc-100 italic">
                            {{ formatCurrency(liveTodaySales || 0) }}
                        </h2>
                    </div>
                    <div class="mt-4 flex items-center gap-2 text-xs font-bold text-emerald-600">
                        <ArrowUpRight :size="14" />
                        <span>+12.5% vs yesterday</span>
                    </div>
                </div>

                <!-- Net Profit Estimate -->
                <div class="premium-card p-6 border-l-4 border-l-emerald-500 transition-all hover:-translate-y-1">
                    <div class="flex items-center justify-between mb-2">
                        <span class="text-[10px] font-black uppercase tracking-widest text-slate-400 dark:text-zinc-500">Net Profit Estimate</span>
                        <div class="w-8 h-8 rounded-lg bg-emerald-50 dark:bg-emerald-900/20 flex items-center justify-center text-emerald-600">
                            <TrendingUp :size="16" />
                        </div>
                    </div>
                    <h2 class="text-3xl font-black tracking-tight text-slate-900 dark:text-zinc-100 italic">
                        {{ formatCurrency(netProfit) }}
                    </h2>
                    <div class="mt-4 flex items-center gap-2 text-xs font-bold text-emerald-600">
                        <Activity :size="14" />
                        <span>Healthy Performance</span>
                    </div>
                </div>

                <!-- Average Margin -->
                <div class="premium-card p-6 border-l-4 border-l-amber-500 transition-all hover:-translate-y-1">
                    <div class="flex items-center justify-between mb-2">
                        <span class="text-[10px] font-black uppercase tracking-widest text-slate-400 dark:text-zinc-500">Average Store Margin</span>
                        <div class="w-8 h-8 rounded-lg bg-amber-50 dark:bg-amber-900/20 flex items-center justify-center text-amber-600">
                            <Percent :size="16" />
                        </div>
                    </div>
                    <h2 class="text-3xl font-black tracking-tight text-slate-900 dark:text-zinc-100 italic">
                        {{ averageMargin }}%
                    </h2>
                    <div class="mt-4 flex items-center gap-2 text-xs font-bold text-slate-600 dark:text-zinc-400">
                        <span class="bg-amber-100 dark:bg-amber-900/40 px-1.5 py-0.5 rounded text-[10px] text-amber-700">TARGET: 30%</span>
                    </div>
                </div>

                <!-- Inventory Risk -->
                <div class="premium-card p-6 border-l-4 border-l-red-500 transition-all hover:-translate-y-1">
                    <div class="flex items-center justify-between mb-2">
                        <span class="text-[10px] font-black uppercase tracking-widest text-slate-400 dark:text-zinc-500">Critically Low Stock</span>
                        <div class="w-8 h-8 rounded-lg bg-red-50 dark:bg-red-900/20 flex items-center justify-center text-red-600">
                            <AlertCircle :size="16" />
                        </div>
                    </div>
                    <h2 class="text-3xl font-black tracking-tight text-slate-900 dark:text-zinc-100 italic">
                        {{ riskyStockCount }} <span class="text-sm font-medium not-italic text-red-400">SKUs</span>
                    </h2>
                    <div class="mt-4 flex items-center gap-2 text-xs font-bold text-red-600">
                        <Clock :size="14" />
                        <span>Action Required NOW</span>
                    </div>
                </div>
            </div>

            <!-- SECTION 2: CHARTS & OPERATIONAL TIMELINE -->
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
                
                <!-- Main Analytics (Left 8 Columns) -->
                <div class="lg:col-span-8 space-y-8">
                    <!-- Sales Trend Card -->
                    <div class="premium-card p-8">
                        <div class="flex items-center justify-between mb-10">
                            <div>
                                <h3 class="text-xl font-black tracking-tight text-slate-900 dark:text-zinc-100">Revenue Stream Analysis</h3>
                                <p class="text-xs font-bold text-slate-400 uppercase tracking-widest mt-1">Snapshot: Last 30 Operating Days</p>
                            </div>
                            <div class="flex items-center gap-3">
                                <div class="flex items-center gap-1.5">
                                    <div class="w-3 h-3 rounded-full bg-brand-600"></div>
                                    <span class="text-[10px] font-bold text-slate-500">Gross Sales</span>
                                </div>
                                <div class="w-px h-4 bg-slate-200 dark:bg-dark-border mx-2"></div>
                                <button class="px-3 py-1.5 rounded-lg bg-surface-100 dark:bg-dark-surface border border-surface-200 dark:border-dark-border text-[10px] font-black hover:bg-white transition-all">
                                    EXPORT PDF
                                </button>
                            </div>
                        </div>
                        <SalesChart :data="salesHistory" />
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                        <!-- Top Selling Products -->
                        <div class="premium-card p-6">
                            <h3 class="text-sm font-black text-slate-900 dark:text-zinc-100 mb-6 uppercase tracking-wider flex items-center gap-2">
                                <Package :size="16" class="text-brand-500" />
                                Velocity Leaders
                            </h3>
                            <div class="space-y-2">
                                <div v-for="(product, index) in topProducts" :key="product.id" class="flex items-center justify-between p-3 rounded-xl hover:bg-surface-50 dark:hover:bg-zinc-800/50 transition-colors group cursor-default">
                                    <div class="flex items-center gap-3">
                                        <div class="w-8 h-8 rounded-lg bg-slate-100 dark:bg-dark-surface flex items-center justify-center text-[10px] font-black text-slate-400 group-hover:text-brand-500 transition-colors">
                                            0{{ index + 1 }}
                                        </div>
                                        <div class="flex flex-col">
                                            <span class="text-sm font-bold text-slate-800 dark:text-zinc-200">{{ product.name }}</span>
                                            <span class="text-[10px] text-slate-400">{{ product.total_sold }} units sold</span>
                                        </div>
                                    </div>
                                    <div class="text-right">
                                        <div class="text-[10px] font-black text-emerald-600">+{{ Math.floor(Math.random() * 20) + 5 }}%</div>
                                        <div class="text-xs font-bold text-slate-600 dark:text-zinc-400">{{ formatCurrency(product.revenue) }}</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Business Health Context -->
                        <div class="space-y-8">
                            <HealthWidget v-if="healthScore" :healthScore="healthScore" />
                            <div v-if="riskScore" class="premium-card p-6 bg-red-50/10 border-red-100 dark:bg-red-950/10 dark:border-red-900/30">
                                <LeakWarningPanel :riskScore="riskScore" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Operational Timeline & Intelligence (Right 4 Columns) -->
                <div class="lg:col-span-4 space-y-8">
                    
                    <!-- AI Insight Premium Token -->
                    <div v-if="aiInsights && aiInsights.length > 0" class="premium-card p-6 bg-gradient-to-br from-brand-600 to-indigo-700 text-white relative overflow-hidden group">
                        <Sparkles :size="80" class="absolute -right-4 -bottom-4 text-white/10 group-hover:scale-125 group-hover:-rotate-12 transition-transform duration-700" />
                        <div class="flex items-center gap-2 mb-4">
                            <div class="p-1.5 rounded-lg bg-white/20 backdrop-blur-md">
                                <Sparkles :size="16" />
                            </div>
                            <span class="text-[10px] font-black uppercase tracking-widest opacity-80">Strategic Intelligence</span>
                        </div>
                        <p class="text-sm font-medium leading-relaxed italic border-l-2 border-white/30 pl-4">
                            "{{ aiInsights[0].content }}"
                        </p>
                        <button class="mt-6 w-full py-2.5 rounded-xl bg-white/10 hover:bg-white/20 backdrop-blur-md border border-white/20 text-xs font-black transition-all">
                            DEEP DIVE REPORT
                        </button>
                    </div>

                    <!-- Live Activity Timeline -->
                    <div class="premium-card p-6">
                        <div class="flex items-center justify-between mb-6">
                            <h3 class="text-sm font-black text-slate-900 dark:text-zinc-100 uppercase tracking-wider flex items-center gap-2">
                                <Clock :size="16" class="text-slate-400" />
                                Branch Pulse
                            </h3>
                            <div class="flex items-center gap-1.5">
                                <div class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></div>
                                <span class="text-[10px] font-black text-emerald-500">LIVE</span>
                            </div>
                        </div>
                        
                        <div class="space-y-6 relative before:absolute before:left-3.5 before:top-2 before:bottom-2 before:w-px before:bg-slate-100 dark:before:bg-dark-border">
                            <div v-for="(alert, i) in liveAlerts.slice(0, 5)" :key="i" class="relative pl-8 group">
                                <div class="absolute left-0 top-1.5 w-7 h-7 rounded-full bg-white dark:bg-dark-surface border border-slate-200 dark:border-dark-border flex items-center justify-center z-10 group-hover:border-brand-500 transition-colors shadow-sm">
                                    <div class="w-1.5 h-1.5 rounded-full" :class="alert.priority === 'high' ? 'bg-red-500' : 'bg-brand-500'"></div>
                                </div>
                                <div class="flex flex-col">
                                    <span class="text-xs font-bold text-slate-800 dark:text-zinc-200">{{ alert.title || alert.message }}</span>
                                    <div class="flex items-center gap-2 mt-1">
                                        <span class="text-[10px] text-slate-400 font-medium">Branch #{{ user?.store_id || 1 }}</span>
                                        <span class="text-[8px] px-1.5 py-0.5 rounded bg-slate-100 dark:bg-dark-surface text-slate-500 font-black">2m ago</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <button class="mt-8 w-full py-3 text-[10px] font-black text-slate-400 hover:text-brand-600 border-t border-slate-100 dark:border-dark-border transition-colors">
                            VIEW FULL LOGS
                        </button>
                    </div>

                    <!-- Enterprise Group Performance -->
                    <div v-if="consolidatedData && consolidatedData.branches" class="premium-card p-6">
                         <div class="flex items-center justify-between mb-6">
                            <h3 class="text-sm font-black text-slate-900 dark:text-zinc-100 uppercase tracking-wider flex items-center gap-2">
                                <BarChartHorizontal :size="16" class="text-slate-400" />
                                HQ Group Profit
                            </h3>
                        </div>
                        <div class="p-4 bg-emerald-50/50 dark:bg-emerald-950/20 rounded-2xl border border-emerald-100 dark:border-emerald-900/30 mb-4">
                            <span class="text-[10px] font-black text-emerald-700 dark:text-emerald-400 uppercase tracking-widest">Net Unified Earnings</span>
                            <div class="text-2xl font-black text-emerald-900 dark:text-emerald-100 mt-1 italic">{{ formatCurrency(consolidatedData.net_group_performance) }}</div>
                        </div>
                        <div class="space-y-3 px-1">
                            <div class="flex justify-between items-center text-xs">
                                <span class="font-bold text-slate-500">Gross Sales</span>
                                <span class="font-black text-slate-800 dark:text-zinc-300">{{ formatCurrency(consolidatedData.gross_group_sales) }}</span>
                            </div>
                            <div class="flex justify-between items-center text-xs">
                                <span class="font-bold text-red-500">Eliminations</span>
                                <span class="font-black text-red-600">-{{ formatCurrency(consolidatedData.internal_elimination) }}</span>
                            </div>
                        </div>
                    </div>

                    <!-- Margin Guardian Panel -->
                    <div v-if="marginAlerts && marginAlerts.length > 0" class="premium-card p-6 border-t-4 border-t-red-600">
                        <AlertCenter :alerts="liveAlerts" />
                    </div>
                </div>
            </div>
        </div>
    </MainLayout>
</template>

<style scoped>
@keyframes pulse-soft {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.7; }
}
.animate-pulse-soft {
    animation: pulse-soft 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}
</style>
