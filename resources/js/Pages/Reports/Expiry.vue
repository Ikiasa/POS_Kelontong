<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head, router } from '@inertiajs/vue3';
import { ref, watch } from 'vue';
import { Search, AlertTriangle, Calendar, Package, AlertCircle, CheckCircle } from 'lucide-vue-next';
import Input from '@/Components/UI/Input.vue';
import Button from '@/Components/UI/Button.vue';
import debounce from 'lodash/debounce';

const props = defineProps({
    batches: Object,
    days: [String, Number],
    search: String,
    totalBatches: Number,
    expiredCount: Number,
    nearExpiryCount: Number,
});

const search = ref(props.search || '');
const days = ref(props.days || 30);

const updateSearch = debounce((value) => {
    router.get(route('reports.expiry'), { search: value, days: days.value }, { preserveState: true, replace: true });
}, 300);

watch(search, (value) => {
    updateSearch(value);
});

watch(days, (value) => {
    router.get(route('reports.expiry'), { search: search.value, days: value }, { preserveState: true, replace: true });
});

const formatDate = (dateString) => {
    if (!dateString) return 'Tanpa Expired';
    return new Date(dateString).toLocaleDateString('id-ID', { year: 'numeric', month: 'long', day: 'numeric' });
};

const getDaysRemaining = (dateString) => {
    if (!dateString) return null;
    const today = new Date();
    const expiry = new Date(dateString);
    const diffTime = expiry - today;
    return Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
};

const getStatusColor = (days) => {
    if (days < 0) return 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400';
    if (days <= 7) return 'bg-orange-100 text-orange-700 dark:bg-orange-900/30 dark:text-orange-400';
    if (days <= 30) return 'bg-yellow-100 text-yellow-700 dark:bg-yellow-900/30 dark:text-yellow-400';
    return 'bg-green-100 text-green-700 dark:bg-green-900/30 dark:text-green-400';
};

const getStatusLabel = (dateString) => {
    const remaining = getDaysRemaining(dateString);
    if (remaining === null) return 'Tanpa Expired';
    if (remaining < 0) return 'Kadaluarsa';
    if (remaining <= 30) return 'Hampir Expired';
    return 'Aman';
};
</script>

<template>
    <Head title="Monitoring Kadaluarsa" />

    <MainLayout title="Monitoring Kadaluarsa">
        <div class="space-y-6">
            <!-- Header & Controls -->
            <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                <div>
                   <!-- Title handled by MainLayout -->
                   <p class="text-sm text-gray-500 dark:text-gray-400">Pantau stok yang sudah atau hampir kadaluarsa.</p>
                </div>
                
                <div class="flex flex-col sm:flex-row gap-3">
                    <!-- Search -->
                    <div class="relative">
                        <Input v-model="search" placeholder="Cari batch atau produk..." :icon="Search" class="min-w-[240px]" />
                    </div>

                    <!-- Days Filter -->
                    <div class="flex items-center gap-2 bg-white dark:bg-zinc-900 border border-gray-200 dark:border-zinc-800 rounded-lg px-3 py-2 shadow-sm">
                        <span class="text-sm text-gray-500 whitespace-nowrap">Kadaluarsa dalam:</span>
                        <select v-model="days" class="border-none p-0 text-sm font-medium text-gray-900 dark:text-white focus:ring-0 cursor-pointer bg-transparent">
                            <option value="7">7 Hari</option>
                            <option value="14">14 Hari</option>
                            <option value="30">30 Hari</option>
                            <option value="60">60 Hari</option>
                            <option value="90">90 Hari</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Summary Cards -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Expired -->
                <div class="bg-white dark:bg-zinc-900 p-6 rounded-2xl border border-gray-100 dark:border-zinc-800 shadow-sm relative overflow-hidden group hover:border-red-200 transition-colors">
                    <div class="absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition-opacity">
                        <AlertCircle class="w-16 h-16 text-red-600" />
                    </div>
                    <div class="flex items-center gap-2 mb-2">
                        <div class="p-2 bg-red-50 dark:bg-red-900/20 rounded-lg text-red-600 dark:text-red-400">
                             <AlertCircle :size="20" />
                        </div>
                        <h3 class="text-gray-500 dark:text-gray-400 text-sm font-medium">Stok Kadaluarsa</h3>
                    </div>
                    <div class="text-3xl font-bold text-red-600 dark:text-red-400">{{ expiredCount }}</div>
                    <p class="text-gray-400 text-xs mt-1">Batch lewat tanggal kadaluarsa</p>
                </div>

                <!-- Near Expiry -->
                <div class="bg-white dark:bg-zinc-900 p-6 rounded-2xl border border-gray-100 dark:border-zinc-800 shadow-sm relative overflow-hidden group hover:border-yellow-200 transition-colors">
                    <div class="absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition-opacity">
                        <AlertTriangle class="w-16 h-16 text-yellow-600" />
                    </div>
                    <div class="flex items-center gap-2 mb-2">
                         <div class="p-2 bg-yellow-50 dark:bg-yellow-900/20 rounded-lg text-yellow-600 dark:text-yellow-400">
                             <AlertTriangle :size="20" />
                        </div>
                        <h3 class="text-gray-500 dark:text-gray-400 text-sm font-medium">Hampir Kadaluarsa ({{ days }} Hari)</h3>
                    </div>
                    <div class="text-3xl font-bold text-yellow-600 dark:text-yellow-400">{{ nearExpiryCount }}</div>
                    <p class="text-gray-400 text-xs mt-1">Batch segera kadaluarsa</p>
                </div>

                <!-- Total -->
                <div class="bg-white dark:bg-zinc-900 p-6 rounded-2xl border border-gray-100 dark:border-zinc-800 shadow-sm relative overflow-hidden group hover:border-indigo-200 transition-colors">
                     <div class="absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition-opacity">
                        <Package class="w-16 h-16 text-indigo-600" />
                    </div>
                    <div class="flex items-center gap-2 mb-2">
                        <div class="p-2 bg-indigo-50 dark:bg-indigo-900/20 rounded-lg text-indigo-600 dark:text-indigo-400">
                             <Package :size="20" />
                        </div>
                        <h3 class="text-gray-500 dark:text-gray-400 text-sm font-medium">Total Batch Aktif</h3>
                    </div>
                    <div class="text-3xl font-bold text-zinc-900 dark:text-white">{{ totalBatches }}</div>
                    <p class="text-gray-400 text-xs mt-1">Total semua batch dalam stok</p>
                </div>
            </div>

            <!-- Table -->
            <div class="bg-white dark:bg-zinc-900 rounded-2xl shadow-sm border border-gray-200 dark:border-zinc-800 overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-sm text-left">
                        <thead class="bg-gray-50 dark:bg-zinc-800/50 text-gray-500 font-medium border-b border-gray-200 dark:border-zinc-800">
                            <tr>
                                <th class="px-6 py-4">Produk</th>
                                <th class="px-6 py-4">Nomor Batch</th>
                                <th class="px-6 py-4 text-right">Jumlah</th>
                                <th class="px-6 py-4">Tanggal Kadaluarsa</th>
                                <th class="px-6 py-4 text-center">Status</th>
                                <th class="px-6 py-4 text-right">Aksi</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-100 dark:divide-zinc-800">
                            <tr v-if="batches.data.length === 0">
                                <td colspan="6" class="px-6 py-12 text-center text-gray-400">
                                    <Package class="w-12 h-12 mx-auto mb-3 opacity-20" />
                                    <p>Tidak ada batch yang kadaluarsa dalam {{ days }} hari.</p>
                                </td>
                            </tr>
                            <tr v-for="batch in batches.data" :key="batch.id" class="hover:bg-gray-50 dark:hover:bg-zinc-800/50 transition-colors">
                                <td class="px-6 py-4 font-medium text-gray-900 dark:text-white">
                                    <a :href="route('products.batches.index', batch.product_id)" class="hover:text-indigo-600 hover:underline">
                                        {{ batch.product?.name || 'Produk Tidak Diketahui' }}
                                    </a>
                                </td>
                                <td class="px-6 py-4 font-mono text-xs text-gray-600 dark:text-gray-400">
                                    {{ batch.batch_number }}
                                </td>
                                <td class="px-6 py-4 text-right">
                                     <span class="font-bold text-gray-900 dark:text-white">{{ batch.current_quantity }}</span>
                                </td>
                                <td class="px-6 py-4">
                                    <div class="flex items-center gap-2 text-gray-700 dark:text-gray-300">
                                        <div class="flex flex-col">
                                            <span class="font-medium">{{ formatDate(batch.expiry_date) }}</span>
                                            <span v-if="batch.expiry_date" class="text-xs text-gray-400">
                                                {{ new Date(batch.expiry_date).toLocaleDateString() === new Date().toLocaleDateString() ? 'Hari Ini' : '' }}
                                            </span>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-4 text-center">
                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-bold border" :class="getStatusColor(batch.expiry_date)">
                                        {{ getStatusLabel(batch.expiry_date) }}
                                    </span>
                                </td>
                                <td class="px-6 py-4 text-right">
                                    <a :href="route('products.batches.index', batch.product_id)" class="text-indigo-600 hover:text-indigo-900 text-xs font-medium inline-flex items-center">
                                        Kelola
                                        <svg class="w-3 h-3 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg>
                                    </a>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                 <!-- Pagination -->
                <div v-if="batches.links && batches.links.length > 3" class="px-6 py-4 border-t border-zinc-100 dark:border-zinc-800 flex justify-between items-center">
                    <div class="text-xs text-zinc-500">
                        Menampilkan {{ batches.from }} sampai {{ batches.to }} dari {{ batches.total }} hasil
                    </div>
                    <div class="flex gap-2">
                        <button v-for="(link, key) in batches.links" :key="key"
                                @click="link.url && router.visit(link.url)"
                                v-html="link.label"
                                :disabled="!link.url"
                                class="px-3 py-1 text-xs rounded-lg border transition-all"
                                :class="link.active 
                                    ? 'bg-indigo-600 border-indigo-600 text-white font-bold' 
                                    : 'border-zinc-200 dark:border-zinc-800 text-zinc-600 dark:text-zinc-400 hover:bg-zinc-50 dark:hover:bg-zinc-800 disabled:opacity-30'">
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </MainLayout>
</template>
