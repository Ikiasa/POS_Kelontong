<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import DataTable from '@/Components/Common/DataTable.vue';
import ApprovalModal from '@/Components/Common/ApprovalModal.vue';
import { Head, Link, router } from '@inertiajs/vue3';
import { ref, watch } from 'vue';
import { 
    Package, Plus, Edit2, Trash2, 
    Barcode, Image as ImageIcon,
    Filter
} from 'lucide-vue-next';
import debounce from 'lodash/debounce';

const props = defineProps({
    products: Object,
    filters: Object,
    categories: Array
});

const search = ref(props.filters.search || '');
const categoryFilter = ref(props.filters.category || '');

const performSearch = debounce(() => {
    router.get(route('products.index'), { 
        search: search.value, 
        category: categoryFilter.value 
    }, { 
        preserveState: true, 
        replace: true 
    });
}, 300);

watch([search, categoryFilter], () => performSearch());

const formatCurrency = (val) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', minimumFractionDigits: 0 }).format(val);

const showApproval = ref(false);
const pendingProduct = ref(null);

const confirmDelete = (product) => {
    pendingProduct.value = product;
    showApproval.value = true;
};

const handleApproved = () => {
    if (pendingProduct.value) {
        router.delete(route('products.destroy', pendingProduct.value.id));
        showApproval.value = false;
        pendingProduct.value = null;
    }
};

const columns = [
    { key: 'image', label: 'Identity', width: '80px', sortable: false },
    { key: 'name', label: 'Product Concept', sortable: true },
    { key: 'category', label: 'Domain', sortable: true },
    { key: 'price', label: 'Market Value', align: 'right', sortable: true },
    { key: 'stock', label: 'Available Units', align: 'right', sortable: true }
];

const handleRowDelete = (item) => confirmDelete(item);
const handleRowEdit = (item) => router.visit(route('products.edit', item.id));

</script>

<template>
    <Head title="Inventory Registry" />

    <MainLayout title="Master Ledger">
        <template #header-actions>
            <Link :href="route('products.create')" 
                  class="bg-brand-600 hover:bg-brand-700 text-white px-8 h-12 rounded-2xl flex items-center justify-center gap-3 font-black shadow-premium transition-all active:scale-95 uppercase tracking-widest text-[10px] italic">
                <Plus :size="18" stroke-width="3" />
                INITIATE PRODUCT
            </Link>
        </template>

        <div class="space-y-8 animate-in fade-in duration-500">
            
            <!-- Standardized Maison DataTable Implementation -->
            <DataTable 
                :columns="columns" 
                :items="products.data" 
                title="Product Catalog"
                subtitle="Consolidated Operational Asset Registry"
                searchPlaceholder="Analyze SKU, Name, or RFID..."
                @edit="handleRowEdit"
                @delete="handleRowDelete"
            >
                <!-- ... existing slots ... -->
                <template #header-actions>
                    <div class="flex items-center gap-2">
                         <select v-model="categoryFilter" 
                                class="h-11 px-6 bg-white dark:bg-dark-bg border border-surface-200 dark:border-dark-border rounded-xl text-[10px] font-black uppercase tracking-widest focus:ring-8 focus:ring-brand-500/10 focus:border-brand-600 transition-all outline-none cursor-pointer">
                            <option value="">Global Domain</option>
                            <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
                        </select>
                    </div>
                </template>

                <template #col-image="{ item }">
                    <div class="w-14 h-14 bg-surface-50 dark:bg-dark-bg/40 rounded-2xl overflow-hidden border border-surface-200 dark:border-dark-border group-hover:border-brand-500/30 transition-all">
                        <img v-if="item.image" :src="`/storage/${item.image}`" :alt="item.name" class="w-full h-full object-cover mix-blend-multiply dark:mix-blend-normal">
                        <div v-else class="w-full h-full flex items-center justify-center text-slate-300 dark:text-zinc-700">
                            <ImageIcon :size="20" />
                        </div>
                    </div>
                </template>

                <template #col-name="{ item }">
                    <div class="flex flex-col gap-1">
                        <span class="text-sm font-black text-slate-900 dark:text-zinc-100 italic tracking-tight uppercase font-serif">{{ item.name }}</span>
                        <div class="flex items-center gap-2">
                             <span class="text-[9px] font-black text-brand-600 dark:text-brand-400 bg-brand-50 dark:bg-brand-900/20 px-1.5 py-0.5 rounded tracking-widest uppercase">
                                {{ item.barcode || 'NO-REF' }}
                             </span>
                        </div>
                    </div>
                </template>

                <template #col-category="{ item }">
                    <span class="text-[10px] font-black text-slate-400 dark:text-zinc-500 uppercase tracking-widest bg-surface-50 dark:bg-dark-bg/40 px-3 py-1.5 rounded-full border border-surface-100 dark:border-dark-border">
                        {{ item.category?.name || 'GENERIC' }}
                    </span>
                </template>

                <template #col-price="{ item }">
                    <div class="flex flex-col items-end gap-0.5">
                        <span class="text-base font-black text-slate-900 dark:text-zinc-100 tabular-nums italic">{{ formatCurrency(item.price) }}</span>
                        <span class="text-[9px] font-bold text-slate-400 uppercase tracking-widest">Target Margin: {{ Math.round(((item.price - item.cost_price) / item.price) * 100) }}%</span>
                    </div>
                </template>

                <template #col-stock="{ item }">
                    <div class="flex flex-col items-end gap-1">
                        <div class="flex items-center gap-2">
                             <div v-if="item.stock <= 10" class="w-1.5 h-1.5 rounded-full bg-red-500 animate-pulse"></div>
                             <span class="text-xl font-black italic tabular-nums" :class="item.stock <= 10 ? 'text-red-500 font-black' : 'text-slate-900 dark:text-zinc-100 font-serif'">
                                {{ item.stock }}
                             </span>
                        </div>
                        <span v-if="item.stock <= 10" class="text-[9px] font-black text-red-400 uppercase tracking-widest">Replenishment Priority: High</span>
                        <span v-else class="text-[9px] font-bold text-emerald-500 uppercase tracking-widest">Inventory Healthy</span>
                    </div>
                </template>

                <template #actions-prefix="{ item }">
                     <a :href="route('products.batches.index', item.id)" class="p-2 text-slate-400 hover:text-emerald-600 hover:bg-emerald-50 dark:hover:bg-emerald-900/20 rounded-lg transition-colors" title="Audit Batches">
                        <Package :size="16" />
                    </a>
                </template>
            </DataTable>

        </div>

        <!-- Security Gateway -->
        <ApprovalModal 
            :show="showApproval" 
            title="Destructive Action Protocol"
            message="Managerial override is required to purge this product entity from the master registry."
            @close="showApproval = false"
            @approved="handleApproved"
        />
    </MainLayout>
</template>
