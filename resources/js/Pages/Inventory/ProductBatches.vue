<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head, useForm, Link } from '@inertiajs/vue3';
import { ref, computed } from 'vue';
import { 
    Package, ArrowLeft, Plus, Calendar, AlertTriangle, 
    TrendingUp, AlertCircle, CheckCircle, Clock 
} from 'lucide-vue-next';
import Input from '@/Components/UI/Input.vue';
import Button from '@/Components/UI/Button.vue';
import Modal from '@/Components/UI/Modal.vue';

const props = defineProps({
    product: Object,
    batches: Array,
});

const showAddModal = ref(false);

const form = useForm({
    product_id: props.product.id,
    quantity: '',
    cost_price: props.product.cost_price || '',
    expiry_date: '',
});

const submitBatch = () => {
    form.post(route('batches.store'), {
        onSuccess: () => {
            showAddModal.value = false;
            form.reset('quantity', 'expiry_date');
        },
    });
};

const formatDate = (dateString) => {
    if (!dateString) return 'No Expiry';
    return new Date(dateString).toLocaleDateString('id-ID', { year: 'numeric', month: 'long', day: 'numeric' });
};

const getStatusColor = (batch) => {
    if (!batch.expiry_date) return 'bg-gray-100 text-gray-800 border-gray-200';
    const today = new Date();
    const expiry = new Date(batch.expiry_date);
    const diffTime = expiry - today;
    const days = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

    if (days < 0) return 'bg-red-100 text-red-800 border-red-200';
    if (days <= 30) return 'bg-yellow-100 text-yellow-800 border-yellow-200';
    return 'bg-green-100 text-green-800 border-green-200';
};

const getStatusLabel = (batch) => {
    if (!batch.expiry_date) return 'Good';
    const today = new Date();
    const expiry = new Date(batch.expiry_date);
    const diffTime = expiry - today;
    const days = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

    if (days < 0) return 'Expired';
    if (days <= 30) return 'Near Expiry';
    return 'Good';
};

// Computed Metrics
const totalStock = computed(() => {
    return props.batches.reduce((sum, batch) => sum + batch.current_quantity, 0);
});

const activeBatchesCount = computed(() => {
    return props.batches.filter(b => b.current_quantity > 0).length;
});

const riskCount = computed(() => {
    return props.batches.filter(b => {
        if (!b.expiry_date || b.current_quantity === 0) return false;
        const days = Math.ceil((new Date(b.expiry_date) - new Date()) / (1000 * 60 * 60 * 24));
        return days <= 30; // Expired or Near Expiry
    }).length;
});
</script>

<template>
    <Head :title="`${product.name} - Batches`" />

    <MainLayout :title="product.name">
        <div class="space-y-6">
            <!-- Header -->
            <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                <div>
                    <Link :href="route('products.index')" class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200 flex items-center gap-2 text-sm font-medium transition-colors mb-1">
                        <ArrowLeft class="w-4 h-4" />
                        Kembali ke Produk
                    </Link>
                    <p class="text-sm text-gray-500 dark:text-gray-400">Kelola batch inventaris dan tanggal kedaluwarsa.</p>
                </div>
                
                <Button @click="showAddModal = true" class="flex items-center gap-2">
                    <Plus class="w-4 h-4" />
                    Tambah Batch Baru
                </Button>
            </div>

            <!-- Summary Cards -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <!-- Total Stock -->
                <div class="bg-white dark:bg-zinc-900 p-6 rounded-2xl border border-gray-100 dark:border-zinc-800 shadow-sm relative overflow-hidden">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-gray-500 dark:text-gray-400 text-sm font-medium">Total Stok</h3>
                        <div class="p-2 bg-blue-50 dark:bg-blue-900/20 rounded-lg text-blue-600 dark:text-blue-400">
                             <Package :size="20" />
                        </div>
                    </div>
                    <div class="text-3xl font-bold text-gray-900 dark:text-white">{{ totalStock }}</div>
                    <p class="text-gray-400 text-xs mt-1">Di semua batch</p>
                </div>

                <!-- Active Batches -->
                <div class="bg-white dark:bg-zinc-900 p-6 rounded-2xl border border-gray-100 dark:border-zinc-800 shadow-sm relative overflow-hidden">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-gray-500 dark:text-gray-400 text-sm font-medium">Batch Aktif</h3>
                        <div class="p-2 bg-green-50 dark:bg-green-900/20 rounded-lg text-green-600 dark:text-green-400">
                             <CheckCircle :size="20" />
                        </div>
                    </div>
                    <div class="text-3xl font-bold text-gray-900 dark:text-white">{{ activeBatchesCount }}</div>
                    <p class="text-gray-400 text-xs mt-1">Dengan stok positif</p>
                </div>

                <!-- At Risk -->
                <div class="bg-white dark:bg-zinc-900 p-6 rounded-2xl border border-gray-100 dark:border-zinc-800 shadow-sm relative overflow-hidden">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-gray-500 dark:text-gray-400 text-sm font-medium">Kedaluwarsa / Berisiko</h3>
                        <div class="p-2 bg-red-50 dark:bg-red-900/20 rounded-lg text-red-600 dark:text-red-400">
                             <AlertTriangle :size="20" />
                        </div>
                    </div>
                    <div class="text-3xl font-bold text-gray-900 dark:text-white">{{ riskCount }}</div>
                    <p class="text-gray-400 text-xs mt-1">Perlu tindakan</p>
                </div>
            </div>

            <!-- Batches Table -->
            <div class="bg-white dark:bg-zinc-900 rounded-2xl shadow-sm border border-gray-200 dark:border-zinc-800 overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-sm text-left">
                        <thead class="bg-gray-50 dark:bg-zinc-800/50 text-gray-500 font-medium border-b border-gray-200 dark:border-zinc-800">
                            <tr>
                                <th class="px-6 py-4">Nomor Batch</th>
                                <th class="px-6 py-4">Tanggal Diterima</th>
                                <th class="px-6 py-4">Tanggal Kedaluwarsa</th>
                                <th class="px-6 py-4 text-right">Qty Awal</th>
                                <th class="px-6 py-4 text-right">Qty Saat Ini</th>
                                <th class="px-6 py-4 text-center">Status</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-100 dark:divide-zinc-800">
                            <tr v-if="batches.length === 0">
                                <td colspan="6" class="px-6 py-12 text-center text-gray-400">
                                    <Package class="w-12 h-12 mx-auto mb-3 opacity-20" />
                                    <p>Tidak ada batch ditemukan untuk produk ini.</p>
                                    <button @click="showAddModal = true" class="text-indigo-600 hover:text-indigo-500 font-medium hover:underline mt-2">
                                        Buat batch pertama
                                    </button>
                                </td>
                            </tr>
                            <tr v-for="batch in batches" :key="batch.id" class="hover:bg-gray-50 dark:hover:bg-zinc-800/50 transition-colors">
                                <td class="px-6 py-4 font-mono text-xs text-gray-600 dark:text-gray-400">
                                    {{ batch.batch_number }}
                                </td>
                                <td class="px-6 py-4 text-gray-500 dark:text-gray-400">
                                    {{ new Date(batch.received_at).toLocaleDateString('id-ID', {day: 'numeric', month: 'short', year: 'numeric'}) }}
                                </td>
                                <td class="px-6 py-4">
                                    <div class="flex items-center gap-2 text-gray-700 dark:text-gray-300">
                                        {{ formatDate(batch.expiry_date) }}
                                    </div>
                                </td>
                                <td class="px-6 py-4 text-right text-gray-500 dark:text-gray-400">
                                    {{ batch.initial_quantity }}
                                </td>
                                <td class="px-6 py-4 text-right font-medium text-gray-900 dark:text-white">
                                    {{ batch.current_quantity }}
                                </td>
                                <td class="px-6 py-4 text-center">
                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-bold border" :class="getStatusColor(batch)">
                                        {{ getStatusLabel(batch) }}
                                    </span>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Add Batch Modal -->
        <Modal :show="showAddModal" @close="showAddModal = false">
            <div class="p-6">
                <h2 class="text-lg font-bold text-gray-900 dark:text-white mb-4">Terima Batch Baru</h2>
                
                <form @submit.prevent="submitBatch" class="space-y-4">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Jumlah</label>
                        <Input type="number" v-model="form.quantity" required min="1" placeholder="cth: 100" />
                        <p v-if="form.errors.quantity" class="text-xs text-red-500 mt-1">{{ form.errors.quantity }}</p>
                    </div>

                    <div>
                         <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Harga Beli (Per Unit)</label>
                         <Input type="number" v-model="form.cost_price" required min="0" placeholder="cth: 5000" />
                         <p v-if="form.errors.cost_price" class="text-xs text-red-500 mt-1">{{ form.errors.cost_price }}</p>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Tanggal Kedaluwarsa</label>
                        <Input type="date" v-model="form.expiry_date" />
                        <p class="text-xs text-gray-500 mt-1">Kosongkan jika tidak mudah rusak.</p>
                         <p v-if="form.errors.expiry_date" class="text-xs text-red-500 mt-1">{{ form.errors.expiry_date }}</p>
                    </div>

                    <div class="mt-6 flex justify-end gap-3">
                        <Button type="button" variant="secondary" @click="showAddModal = false">Batal</Button>
                        <Button type="submit" :disabled="form.processing">Simpan Batch</Button>
                    </div>
                </form>
            </div>
        </Modal>
    </MainLayout>
</template>
