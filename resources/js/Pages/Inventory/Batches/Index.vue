<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head, useForm } from '@inertiajs/vue3';
import { Box, Search, ArrowLeft, Package, Plus, Save, X } from 'lucide-vue-next';
import { Link } from '@inertiajs/vue3';
import { ref, watch } from 'vue';
import Modal from '@/Components/UI/Modal.vue';

const props = defineProps({
    product: {
        type: Object,
        default: null
    },
    products: {
        type: Array, 
        default: () => []
    }
});

const showAddModal = ref(false);

const form = useForm({
    product_id: props.product?.id || '',
    quantity: 1,
    cost_price: 0,
    expiry_date: '',
});

// Update form product_id if prop changes or is initially set
watch(() => props.product, (newVal) => {
    if (newVal) {
        form.product_id = newVal.id;
    }
}, { immediate: true });

const openModal = () => {
    showAddModal.value = true;
};

const closeModal = () => {
    showAddModal.value = false;
    form.reset();
    if (props.product) {
        form.product_id = props.product.id;
    }
};

const submit = () => {
    form.post(route('batches.store'), {
        onSuccess: () => {
            closeModal();
        }
    });
};
</script>

<template>
    <Head title="Manajemen Batch" />

    <MainLayout title="Manajemen Batch">
        <div class="flex items-center justify-between mb-6">
            <div class="flex items-center gap-4">
                <Link :href="route('products.index')" class="p-2 hover:bg-zinc-100 dark:hover:bg-zinc-800 rounded-lg transition-colors">
                    <ArrowLeft :size="20" class="text-zinc-500" />
                </Link>
                <div>
                    <h2 class="text-xl font-black text-zinc-900 dark:text-white flex items-center gap-2">
                        <Package class="text-brand-600" />
                        Manajemen Batch: {{ product ? product.name : 'Semua Barang' }}
                    </h2>
                    <p class="text-sm text-zinc-500">Kelola tanggal kedaluwarsa dan stok batch</p>
                </div>
            </div>
            <button @click="openModal()" 
                    class="bg-brand-600 hover:bg-brand-700 text-white px-6 h-11 rounded-xl flex items-center gap-2 font-bold shadow-lg shadow-brand-600/20 transition-all">
                <Plus :size="18" />
                Tambah Batch
            </button>
        </div>

        <div class="bg-white dark:bg-zinc-800 rounded-xl border border-gray-100 dark:border-zinc-800 p-8 text-center">
            <div class="w-16 h-16 bg-brand-50 dark:bg-brand-900/20 rounded-full flex items-center justify-center mx-auto mb-4">
                <Box class="text-brand-600 dark:text-brand-400" :size="32" />
            </div>
            <h2 class="text-xl font-bold text-zinc-900 dark:text-white mb-2">Manajemen Batch</h2>
            <p class="text-zinc-500 max-w-md mx-auto">
                Modul ini sedang dimigrasikan ke sistem baru.
                Anda masih dapat mengakses tampilan lama jika diperlukan, atau cek kembali nanti untuk implementasi penuh.
            </p>
        </div>

        <!-- Add Batch Modal -->
        <Modal :show="showAddModal" @close="closeModal">
            <div class="p-6">
                <div class="flex items-center justify-between mb-6">
                    <h3 class="text-lg font-black text-zinc-900 dark:text-white flex items-center gap-2">
                        <Plus class="text-brand-600" :size="20" />
                        Terima Batch Baru
                    </h3>
                    <button @click="closeModal" class="text-zinc-400 hover:text-zinc-600 dark:hover:text-zinc-300">
                        <X :size="20" />
                    </button>
                </div>

                <form @submit.prevent="submit" class="space-y-5">
                    <!-- Product Selection -->
                    <div v-if="!product">
                        <label class="block text-xs font-bold text-zinc-500 uppercase mb-1.5 tracking-wider">Produk</label>
                        <div class="relative">
                            <select v-model="form.product_id" class="w-full rounded-xl border-gray-200 dark:border-zinc-700 bg-gray-50 dark:bg-zinc-800 focus:ring-2 focus:ring-brand-500 focus:border-brand-500 transition-all font-medium py-2.5">
                                <option value="" disabled>Pilih Produk</option>
                                <option v-for="p in products" :key="p.id" :value="p.id">{{ p.name }}</option>
                            </select>
                            <div class="absolute inset-y-0 right-4 flex items-center pointer-events-none text-zinc-500">
                                <Package :size="16" />
                            </div>
                        </div>
                        <p v-if="form.errors.product_id" class="text-red-500 text-xs mt-1 font-bold">{{ form.errors.product_id }}</p>
                    </div>

                    <!-- Quantity & Cost Grid -->
                    <div class="grid grid-cols-2 gap-5">
                        <div class="space-y-1.5">
                            <label class="block text-xs font-bold text-zinc-500 uppercase tracking-wider">Jumlah (Qty)</label>
                            <div class="relative">
                                <input 
                                    v-model="form.quantity" 
                                    type="number" 
                                    min="1" 
                                    placeholder="0"
                                    class="w-full rounded-xl border-gray-200 dark:border-zinc-700 bg-gray-50 dark:bg-zinc-800 focus:ring-2 focus:ring-brand-500 focus:border-brand-500 font-bold py-2.5 text-zinc-900 dark:text-white transition-all pl-4" 
                                />
                            </div>
                            <p v-if="form.errors.quantity" class="text-red-500 text-xs mt-1 font-bold">{{ form.errors.quantity }}</p>
                        </div>
                        
                        <div class="space-y-1.5">
                            <label class="block text-xs font-bold text-zinc-500 uppercase tracking-wider">Harga Beli (Per Unit)</label>
                            <div class="relative">
                                <span class="absolute left-4 top-1/2 -translate-y-1/2 text-zinc-400 font-bold select-none pointer-events-none">Rp</span>
                                <input 
                                    v-model="form.cost_price" 
                                    type="number" 
                                    min="0" 
                                    placeholder="0"
                                    class="w-full pl-12 rounded-xl border-gray-200 dark:border-zinc-700 bg-gray-50 dark:bg-zinc-800 focus:ring-2 focus:ring-brand-500 focus:border-brand-500 font-bold py-2.5 text-zinc-900 dark:text-white transition-all" 
                                />
                            </div>
                            <p v-if="form.errors.cost_price" class="text-red-500 text-xs mt-1 font-bold">{{ form.errors.cost_price }}</p>
                        </div>
                    </div>

                    <!-- Expiry Date -->
                    <div class="space-y-1.5 container-class">
                        <label class="block text-xs font-bold text-zinc-500 uppercase tracking-wider">Tanggal Kedaluwarsa (Opsional)</label>
                        <input 
                            v-model="form.expiry_date" 
                            type="date" 
                            class="w-full rounded-xl border-gray-200 dark:border-zinc-700 bg-gray-50 dark:bg-zinc-800 focus:ring-2 focus:ring-brand-500 focus:border-brand-500 font-bold py-2.5 text-zinc-900 dark:text-white transition-all uppercase" 
                        />
                         <p v-if="form.errors.expiry_date" class="text-red-500 text-xs mt-1 font-bold">{{ form.errors.expiry_date }}</p>
                    </div>

                    <!-- Actions -->
                    <div class="pt-6 border-t border-gray-100 dark:border-zinc-800 flex justify-end gap-3">
                        <button type="button" @click="closeModal" class="px-5 py-2.5 text-zinc-600 dark:text-zinc-400 font-bold hover:bg-zinc-100 dark:hover:bg-zinc-800 rounded-xl transition-colors">
                            Batal
                        </button>
                        <button type="submit" :disabled="form.processing" class="bg-brand-600 hover:bg-brand-700 text-white px-6 py-2.5 rounded-xl font-bold shadow-lg shadow-brand-600/20 hover:shadow-brand-600/30 transform active:scale-95 transition-all flex items-center gap-2">
                            <Save :size="18" />
                            <span v-if="form.processing">Menyimpan...</span>
                            <span v-else>Simpan Batch</span>
                        </button>
                    </div>
                </form>
            </div>
        </Modal>
    </MainLayout>
</template>
