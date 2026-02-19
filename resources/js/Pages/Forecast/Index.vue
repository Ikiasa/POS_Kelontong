<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head } from '@inertiajs/vue3';
import { Sparkles, TrendingUp, TrendingDown, Minus } from 'lucide-vue-next';
import { computed } from 'vue';
import { Line } from 'vue-chartjs';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend,
  Filler
} from 'chart.js';

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend,
  Filler
);

const props = defineProps({
    forecast: Object
});

const trendIcon = computed(() => {
    if (props.forecast.prediction.trend === 'up') return TrendingUp;
    if (props.forecast.prediction.trend === 'down') return TrendingDown;
    return Minus;
});

const trendColor = computed(() => {
    if (props.forecast.prediction.trend === 'up') return 'text-emerald-500';
    if (props.forecast.prediction.trend === 'down') return 'text-red-500';
    return 'text-gray-500';
});

const trendText = computed(() => {
    if (props.forecast.prediction.trend === 'up') return 'Meningkat';
    if (props.forecast.prediction.trend === 'down') return 'Menurun';
    return 'Stabil';
});

const chartData = computed(() => {
    const historyLabels = props.forecast.history.labels;
    const historyData = props.forecast.history.data;
    
    // Add prediction point
    const labels = [...historyLabels, 'Bulan Depan'];
    const data = [...historyData, props.forecast.prediction.next_month];

    return {
        labels: labels,
        datasets: [
            {
                label: 'Penjualan Historis',
                backgroundColor: 'rgba(79, 70, 229, 0.1)', // Brand-600
                borderColor: '#4f46e5',
                pointBackgroundColor: '#4f46e5',
                borderWidth: 2,
                fill: true,
                data: [...historyData, null], // Only history
                tension: 0.4
            },
            {
                label: 'Prediksi AI',
                backgroundColor: 'rgba(245, 158, 11, 0.1)', // Amber-500
                borderColor: '#f59e0b',
                pointBackgroundColor: '#f59e0b',
                borderDash: [5, 5],
                borderWidth: 2,
                fill: false,
                data: Array(historyData.length).fill(null).concat([props.forecast.prediction.next_month]),
                tension: 0.4
            }
        ]
    };
});

const chartOptions = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
        legend: {
            display: true,
            labels: { color: '#9ca3af' }
        },
        tooltip: {
            mode: 'index',
            intersect: false,
            backgroundColor: '#1f2937',
            titleColor: '#f3f4f6',
            bodyColor: '#d1d5db',
            borderColor: '#374151',
            borderWidth: 1
        }
    },
    scales: {
        y: {
            beginAtZero: true,
            grid: { color: '#374151' }, // Darker grid
            ticks: { color: '#9ca3af' }
        },
        x: {
            grid: { display: false },
            ticks: { color: '#9ca3af' }
        }
    }
};

const formatCurrency = (value) => {
    return new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR' }).format(value);
};
</script>

<template>
    <Head title="AI Forecast" />

    <MainLayout title="Prediksi Penjualan AI">
        <div class="space-y-6">
            <!-- Header Insight -->
            <div class="bg-white dark:bg-zinc-900 rounded-2xl p-6 border border-gray-100 dark:border-zinc-800 shadow-sm relative overflow-hidden">
                <div class="absolute top-0 right-0 p-8 opacity-5">
                    <Sparkles :size="120" />
                </div>
                
                <div class="relative z-10 flex flex-col md:flex-row items-start md:items-center justify-between gap-6">
                    <div>
                        <div class="flex items-center gap-2 mb-2">
                            <span class="bg-brand-50 dark:bg-brand-900/30 text-brand-600 dark:text-brand-400 text-xs font-bold px-2.5 py-0.5 rounded-full uppercase tracking-wide">
                                AI Powered
                            </span>
                            <span class="text-xs text-gray-500">Model: Simple Moving Average</span>
                        </div>
                        <h2 class="text-3xl font-black text-gray-900 dark:text-zinc-200 mb-1">
                            {{ formatCurrency(forecast.prediction.next_month) }}
                        </h2>
                        <p class="text-gray-500 dark:text-gray-400 text-sm">
                            Estimasi penjualan bulan depan
                        </p>
                    </div>

                    <div class="flex items-center gap-4 bg-gray-50 dark:bg-zinc-900/50 p-4 rounded-xl border border-gray-100 dark:border-zinc-700/50">
                        <div :class="`p-3 rounded-lg ${forecast.prediction.trend === 'up' ? 'bg-emerald-50 dark:bg-emerald-900/20' : 'bg-red-50 dark:bg-red-900/20'}`">
                            <component :is="trendIcon" :class="trendColor" :size="24" />
                        </div>
                        <div>
                            <p class="text-xs text-gray-500 uppercase font-bold tracking-wider">Tren</p>
                            <p :class="`text-lg font-bold ${trendColor}`">
                                {{ trendText }}
                                <span class="text-xs ml-1 opacity-75">({{ Math.abs(forecast.prediction.growth_rate).toFixed(1) }}%)</span>
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Chart Section -->
            <div class="bg-white dark:bg-zinc-800 rounded-2xl p-6 border border-gray-100 dark:border-zinc-800 shadow-sm">
                <div class="flex items-center justify-between mb-6">
                    <h3 class="text-lg font-bold text-gray-900 dark:text-white">Trend Penjualan & Prediksi</h3>
                </div>
                <div class="h-[400px]">
                    <Line :data="chartData" :options="chartOptions" />
                </div>
            </div>

            <!-- Explanation -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                 <div class="bg-white dark:bg-zinc-800 rounded-2xl p-6 border border-gray-100 dark:border-zinc-800 shadow-sm">
                    <h3 class="font-bold text-gray-900 dark:text-white mb-3 flex items-center gap-2">
                        <Sparkles class="text-amber-500" :size="18" />
                        Rekomendasi Tindakan
                    </h3>
                    <p class="text-sm text-gray-600 dark:text-gray-400 leading-relaxed">
                        Berdasarkan tren prediksi 
                        <span :class="`font-bold ${trendColor}`">{{ trendText.toLowerCase() }}</span>, 
                        disarankan untuk {{ forecast.prediction.trend === 'up' ? 'menyiapkan stok lebih banyak pada produk best-seller' : 'mengurangi stok barang yang perputarannya lambat dan membuat promo bundle' }}.
                    </p>
                </div>
            </div>
        </div>
    </MainLayout>
</template>
