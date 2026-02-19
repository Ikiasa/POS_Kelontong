<script setup>
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
    data: Object
});

const chartData = computed(() => {
    const labels = Object.keys(props.data);
    const datasets = [
        {
            label: 'Total Sales (IDR)',
            backgroundColor: 'rgba(79, 70, 229, 0.1)', // #4f46e5 (Indigo 600)
            borderColor: '#4f46e5', // #4f46e5
            fill: true,
            data: Object.values(props.data),
            tension: 0.4,
            pointRadius: 4,
            pointHoverRadius: 6,
        }
    ];
    return { labels, datasets };
});

const chartOptions = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
        legend: {
            display: false
        }
    },
    scales: {
        y: {
            beginAtZero: true,
            grid: {
                display: false
            }
        },
        x: {
            grid: {
                display: false
            }
        }
    }
};
</script>

<template>
    <div class="h-[300px] w-full">
        <Line :data="chartData" :options="chartOptions" />
    </div>
</template>
