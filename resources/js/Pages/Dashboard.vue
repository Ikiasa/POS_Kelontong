<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head } from '@inertiajs/vue3';
import { 
    TrendingUp, 
    Package, 
    Users, 
    Database, 
    Activity,
    Sparkles
} from 'lucide-vue-next';
import HealthWidget from '@/Components/Dashboard/HealthWidget.vue';
import LeakWarningPanel from '@/Components/Dashboard/LeakWarningPanel.vue';
import AlertCenter from '@/Components/Dashboard/AlertCenter.vue';
import SalesChart from '@/Components/Dashboard/SalesChart.vue';
import ExpiryPanel from '@/Components/Assistant/ExpiryPanel.vue';
import { onMounted, onUnmounted, ref } from 'vue';
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
    stockData: Object,
    pricingData: Object,
    alerts: Array
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
const liveTransactionCount = ref(0); // Initialize default, will be updated by poll
const liveAlerts = ref(props.alerts);

let pollingInterval = null;

onMounted(() => {
    // Poll every 3 seconds for near real-time feel
    pollingInterval = setInterval(async () => {
        try {
            const response = await axios.get(route('dashboard.live'));
            liveTodaySales.value = response.data.todaySales;
            liveTransactionCount.value = response.data.todayTransactionCount;
            
            // Merge or replace alerts as needed
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
</script>

<template>
    <Head title="Dashboard" />

    <MainLayout title="Overview">
        <div class="space-y-8">


            <!-- Top Metrics Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                <!-- Penjualan Hari Ini -->
                <div class="bg-white dark:bg-zinc-900 p-6 rounded-2xl border border-gray-100 dark:border-zinc-800 shadow-sm hover:shadow-md transition-all group">
                    <div class="flex items-center justify-between mb-4">
                        <div class="w-12 h-12 bg-brand-50 dark:bg-brand-900/20 rounded-xl flex items-center justify-center text-brand-600 dark:text-brand-400 group-hover:scale-110 transition-transform">
                            <TrendingUp :size="24" />
                        </div>
                        <span class="text-xs font-bold text-green-600 bg-green-50 dark:bg-green-900/20 px-2 py-1 rounded-full border border-green-100 dark:border-green-900/30 flex items-center gap-1">
                            <Activity :size="10" /> {{ liveTransactionCount }} Trx
                        </span>
                    </div>
                    <h3 class="text-zinc-500 text-sm font-semibold tracking-wide uppercase">Penjualan Hari Ini</h3>
                    <p class="text-3xl font-black text-zinc-900 dark:text-zinc-200 mt-1 tracking-tight">{{ formatCurrency(liveTodaySales || 0) }}</p>
                </div>

                <!-- Produk Aktif -->
                <div class="bg-white dark:bg-zinc-900 p-6 rounded-2xl border border-gray-100 dark:border-zinc-800 shadow-sm hover:shadow-md transition-all group">
                    <div class="flex items-center justify-between mb-4">
                        <div class="w-12 h-12 bg-emerald-50 dark:bg-emerald-900/20 rounded-xl flex items-center justify-center text-emerald-600 dark:text-emerald-400 group-hover:scale-110 transition-transform">
                            <Package :size="24" />
                        </div>
                    </div>
                    <h3 class="text-zinc-500 text-sm font-semibold tracking-wide uppercase">Produk Aktif</h3>
                    <p class="text-3xl font-black text-zinc-900 dark:text-zinc-200 mt-1 tracking-tight">{{ totalProducts || 0 }}</p>
                </div>

                <!-- Total Pelanggan -->
                <div class="bg-white dark:bg-zinc-900 p-6 rounded-2xl border border-gray-100 dark:border-zinc-800 shadow-sm hover:shadow-md transition-all group">
                    <div class="flex items-center justify-between mb-4">
                        <div class="w-12 h-12 bg-amber-50 dark:bg-amber-900/20 rounded-xl flex items-center justify-center text-amber-600 dark:text-amber-400 group-hover:scale-110 transition-transform">
                            <Users :size="24" />
                        </div>
                    </div>
                    <h3 class="text-zinc-500 text-sm font-semibold tracking-wide uppercase">Total Pelanggan</h3>
                    <p class="text-3xl font-black text-zinc-900 dark:text-zinc-200 mt-1 tracking-tight">{{ totalCustomers || 0 }}</p>
                </div>

                <!-- System Status -->
                <div class="bg-white dark:bg-zinc-900 p-6 rounded-2xl border border-gray-100 dark:border-zinc-800 shadow-sm hover:shadow-md transition-all group">
                    <div class="flex items-center justify-between mb-4">
                        <div class="w-12 h-12 bg-blue-50 dark:bg-blue-900/20 rounded-xl flex items-center justify-center text-blue-600 dark:text-blue-400 group-hover:scale-110 transition-transform">
                            <Database :size="24" />
                        </div>
                        <span class="text-xs font-bold text-zinc-500 bg-zinc-100 dark:bg-zinc-800 px-2 py-1 rounded-full uppercase tracking-wider">System</span>
                    </div>
                    <h3 class="text-zinc-500 text-sm font-semibold tracking-wide uppercase">Backup Data</h3>
                    <p class="text-3xl font-black text-zinc-900 dark:text-zinc-200 mt-1 tracking-tight">{{ backupCount || 0 }} <span class="text-sm font-medium text-zinc-400">Aman</span></p>
                </div>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                <!-- Main Content Area (Charts & Analytics) -->
                <div class="lg:col-span-2 space-y-8">
                    <!-- Sales Chart -->
                    <div class="bg-white dark:bg-zinc-900 p-6 rounded-2xl border border-gray-100 dark:border-zinc-800 shadow-sm">
                        <div class="flex items-center justify-between mb-8">
                            <div>
                                <h3 class="text-xl font-bold text-zinc-900 dark:text-zinc-200 tracking-tight">Tren Penjualan</h3>
                                <p class="text-sm text-zinc-500 font-medium">Analisis pendapatan 30 hari terakhir</p>
                            </div>

                            <div class="flex items-center gap-2 text-xs font-bold text-brand-600 bg-brand-50 dark:bg-brand-900/20 px-3 py-1.5 rounded-lg border border-brand-100 dark:border-brand-900/30">
                                <Activity :size="14" />
                                LIVE ANALYTICS
                            </div>
                        </div>
                        <SalesChart :data="salesHistory" />
                    </div>

                    <!-- Top Selling Products -->
                    <div class="bg-white dark:bg-zinc-900 p-6 rounded-2xl border border-gray-100 dark:border-zinc-800 shadow-sm">
                        <h3 class="text-xl font-bold text-zinc-900 dark:text-zinc-200 mb-6 tracking-tight">Produk Terlaris</h3>
                        <div class="space-y-4">
                            <div v-for="(product, index) in topProducts" :key="product.id" class="flex items-center justify-between p-4 rounded-xl bg-gray-50 dark:bg-zinc-800/50 border border-transparent hover:border-gray-200 dark:hover:border-zinc-700 transition-colors group">
                                <div class="flex items-center gap-4">
                                    <div class="w-12 h-12 rounded-xl bg-white dark:bg-zinc-900 border border-gray-200 dark:border-zinc-700 flex items-center justify-center text-zinc-700 dark:text-zinc-300 font-bold shadow-sm group-hover:scale-105 transition-transform">
                                        <span v-if="index < 3" class="text-lg" :class="index === 0 ? 'text-yellow-500' : (index === 1 ? 'text-gray-400' : 'text-orange-700')">#{{ index + 1 }}</span>
                                        <span v-else class="text-sm text-zinc-400">{{ index + 1 }}</span>
                                    </div>
                                    <div>
                                        <p class="font-bold text-sm text-zinc-900 dark:text-zinc-200 transform group-hover:translate-x-1 transition-transform">{{ product.name }}</p>
                                        <p class="text-xs text-zinc-500 font-medium mt-0.5">{{ product.total_sold }} PCS Terjual</p>
                                    </div>
                                </div>
                                <div class="text-right">
                                    <p class="font-bold text-sm text-zinc-900 dark:text-zinc-200">{{ formatCurrency(product.revenue) }}</p>
                                    <p class="text-[10px] text-zinc-400 uppercase font-bold tracking-wider">Pendapatan</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Business Health Score -->
                    <HealthWidget v-if="healthScore" :healthScore="healthScore" />
                    <div v-else class="p-8 text-center border-2 border-dashed border-gray-200 dark:border-zinc-800 rounded-2xl text-gray-400 font-medium">
                        Health Score Pending...
                    </div>
                </div>

                <!-- Right Sidebar (Alerts & Intelligence) -->
                <div class="space-y-8">
                    <!-- AI Insights Snippet (Redesigned) -->
                    <div v-if="aiInsights && aiInsights.length > 0" class="bg-gradient-to-br from-white to-indigo-50 dark:from-zinc-900 dark:to-zinc-900/50 border border-indigo-100 dark:border-zinc-800 p-6 rounded-2xl shadow-sm relative overflow-hidden group hover:shadow-md transition-all">
                        <div class="absolute top-0 right-0 p-4 opacity-10">
                            <Sparkles :size="80" class="text-indigo-600" />
                        </div>
                        <h3 class="font-bold mb-3 flex items-center gap-2 text-lg relative z-10 text-indigo-900">
                            <Sparkles :size="20" class="text-indigo-600 animate-pulse" />
                            <span>AI Insight</span>
                        </h3>
                        <p class="text-sm font-medium text-slate-600 leading-relaxed relative z-10">{{ aiInsights[0].content }}</p>
                        
                        <button class="mt-4 px-4 py-2 bg-white hover:bg-indigo-50 text-indigo-700 border border-indigo-200 rounded-lg text-xs font-bold transition-colors relative z-10 shadow-sm">
                            View All Insights
                        </button>
                    </div>

                    <!-- System Alerts -->
                    <AlertCenter :alerts="liveAlerts" />

                    <!-- Expiry Monitor -->
                    <ExpiryPanel />

                    <!-- Profit Leak Risk -->
                    <LeakWarningPanel v-if="riskScore" :riskScore="riskScore" />
                </div>
            </div>
        </div>
    </MainLayout>
</template>
