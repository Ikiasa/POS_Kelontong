<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head, useForm, router } from '@inertiajs/vue3';
import { ref, onMounted } from 'vue';
import { 
    ShoppingCart, Plus, Trash2, Search, 
    Calendar, FileText, ChevronLeft, Save 
} from 'lucide-vue-next';
import axios from 'axios';
import debounce from 'lodash/debounce';

const props = defineProps({
    po: Object,
    suppliers: Array,
    po_number: String
});

const isEditing = ref(!!props.po);

const form = useForm({
    supplier_id: props.po?.supplier_id ?? '',
    po_number: props.po?.po_number ?? props.po_number,
    status: props.po?.status ?? 'draft',
    ordered_at: props.po?.ordered_at?.split('T')[0] ?? new Date().toISOString().split('T')[0],
    expected_at: props.po?.expected_at?.split('T')[0] ?? '',
    notes: props.po?.notes ?? '',
    items: props.po?.items?.map(i => ({
        product_id: i.product_id,
        product_name: i.product.name,
        quantity: i.quantity,
        unit_cost: i.unit_cost,
        total_cost: i.total_cost
    })) ?? [{ product_id: '', product_name: '', quantity: 1, unit_cost: 0, total_cost: 0 }]
});

const searchResults = ref([]);
const activeSearchIndex = ref(null);

const searchProducts = debounce(async (query, index) => {
    if (query.length < 2) {
        searchResults.value = [];
        return;
    }
    activeSearchIndex.value = index;
    const response = await axios.get(route('purchase-orders.search-products'), { params: { query } });
    searchResults.value = response.data;
}, 300);

const selectProduct = (product, index) => {
    form.items[index].product_id = product.id;
    form.items[index].product_name = product.name;
    form.items[index].unit_cost = product.cost_price;
    calculateRowTotal(index);
    searchResults.value = [];
    activeSearchIndex.value = null;
};

const calculateRowTotal = (index) => {
    form.items[index].total_cost = form.items[index].quantity * form.items[index].unit_cost;
};

const addItem = () => {
    form.items.push({ product_id: '', product_name: '', quantity: 1, unit_cost: 0, total_cost: 0 });
};

const removeItem = (index) => {
    if (form.items.length > 1) {
        form.items.splice(index, 1);
    }
};

const submit = () => {
    if (isEditing.value) {
        form.put(route('purchase-orders.update', props.po.id));
    } else {
        form.post(route('purchase-orders.store'));
    }
};

const formatCurrency = (val) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', minimumFractionDigits: 0 }).format(val);
</script>

<template>
    <Head :title="isEditing ? 'Edit Purchase Order' : 'New Purchase Order'" />

    <MainLayout :title="isEditing ? 'Edit Purchase Order' : 'Create Purchase Order'">
        <form @submit.prevent="submit" class="space-y-6 pb-20">
            <!-- Top Actions -->
            <div class="flex items-center justify-between">
                <button type="button" @click="router.visit(route('purchase-orders.index'))" 
                        class="flex items-center gap-2 text-zinc-500 hover:text-zinc-900 dark:hover:text-white transition-colors">
                    <ChevronLeft :size="18" />
                    Back to List
                </button>
                <div class="flex items-center gap-3">
                    <span class="text-sm text-zinc-500 font-medium">Status:</span>
                    <select v-model="form.status" 
                            class="bg-zinc-100 dark:bg-zinc-800 border-none rounded-lg text-sm font-bold h-10 px-4 focus:ring-2 focus:ring-red-500">
                        <option value="draft">Draft</option>
                        <option value="ordered">Ordered</option>
                        <option value="received">Received</option>
                        <option value="cancelled">Cancelled</option>
                    </select>
                    <button type="submit" :disabled="form.processing || form.items.length === 0"
                        class="bg-red-600 hover:bg-red-700 text-white px-8 h-12 rounded-xl flex items-center gap-2 font-bold shadow-lg shadow-red-600/20 transition-all disabled:opacity-50 ml-auto">
                        <Save :size="18" />
                        Submit Purchase Order
                    </button>
                </div>
            </div>

            <!-- Main Form Card -->
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                <!-- Order Info -->
                <div class="lg:col-span-2 space-y-6">
                    <div class="bg-white dark:bg-zinc-900 rounded-xl border border-zinc-200 dark:border-zinc-800 p-6 shadow-sm">
                        <h3 class="text-sm font-black uppercase tracking-widest text-zinc-400 mb-6 flex items-center gap-2">
                            <ShoppingCart :size="16" />
                            General Information
                        </h3>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div class="space-y-2">
                                <label class="text-[10px] font-black text-zinc-400 uppercase tracking-widest">Supplier</label>
                                <select v-model="form.supplier_id" required
                                        class="w-full h-11 bg-zinc-50 dark:bg-zinc-950 border-zinc-200 dark:border-zinc-800 rounded-lg focus:ring-2 focus:ring-red-500 text-sm">
                                    <option value="" disabled>Select Supplier</option>
                                    <option v-for="supplier in suppliers" :key="supplier.id" :value="supplier.id">{{ supplier.name }}</option>
                                </select>
                            </div>
                            <div class="space-y-2">
                                <label class="text-xs font-bold text-zinc-500 uppercase">PO Number</label>
                                <input v-model="form.po_number" type="text" readonly
                                       class="w-full h-11 bg-zinc-100 dark:bg-zinc-800 border-zinc-200 dark:border-zinc-800 rounded-lg text-zinc-500 font-mono">
                            </div>
                            <div class="space-y-2">
                                <label class="text-xs font-bold text-zinc-500 uppercase">Order Date</label>
                                <input v-model="form.ordered_at" type="date" required
                                       class="w-full h-11 bg-zinc-50 dark:bg-zinc-950 border-zinc-200 dark:border-zinc-800 rounded-lg focus:ring-2 focus:ring-red-500">
                            </div>
                            <div class="space-y-2">
                                <label class="text-[10px] font-black text-zinc-400 uppercase tracking-widest">Expected Date</label>
                                <input v-model="form.expected_at" type="date"
                                       class="w-full h-11 bg-zinc-50 dark:bg-zinc-950 border-zinc-200 dark:border-zinc-800 rounded-lg focus:ring-2 focus:ring-red-500 text-sm">
                            </div>
                        </div>
                    </div>

                    <!-- Items Section -->
                    <div class="bg-white dark:bg-zinc-900 rounded-xl border border-zinc-200 dark:border-zinc-800 p-6 shadow-sm">
                        <div class="flex items-center justify-between mb-6">
                            <h2 class="text-xl font-black text-zinc-900 dark:text-white flex items-center gap-2">
                                <ShoppingCart class="text-red-600" />
                                Create Purchase Order
                            </h2>
                            <button type="button" @click="addItem" class="text-xs font-bold text-red-600 hover:text-red-700 flex items-center gap-1">
                                <Plus :size="14" />
                                Add Item
                            </button>
                        </div>

                        <div class="space-y-4">
                            <div v-for="(item, index) in form.items" :key="index" class="relative group grid grid-cols-12 gap-3 items-end border-b border-zinc-100 dark:border-zinc-800 pb-4">
                                <div class="col-span-12 md:col-span-5 space-y-1">
                                    <label class="text-[10px] uppercase font-bold text-zinc-400">Product</label>
                                    <div class="relative max-w-md">
                                        <Search class="absolute left-3 top-1/2 -translate-y-1/2 text-zinc-400" :size="18" />
                                        <input v-model="item.product_name" type="text" placeholder="Search product..."
                                               @input="searchProducts($event.target.value, index)"
                                               class="w-full pl-10 h-11 bg-zinc-50 dark:bg-zinc-950 border-zinc-200 dark:border-zinc-800 rounded-lg focus:ring-2 focus:ring-red-500 text-sm">
                                    </div>
                                    
                                    <!-- Search Results Dropdown -->
                                    <div v-if="activeSearchIndex === index && searchResults.length > 0" 
                                         class="absolute z-20 w-full mt-1 bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-lg shadow-xl max-h-60 overflow-y-auto">
                                        <button v-for="p in searchResults" :key="p.id" type="button"
                                                @click="selectProduct(p, index)"
                                                class="w-full px-4 py-2 text-left text-sm hover:bg-zinc-50 dark:hover:bg-zinc-800 flex flex-col">
                                            <span class="font-bold border-zinc-900 dark:text-white">{{ p.name }}</span>
                                            <span class="text-xs text-zinc-500">{{ p.barcode || 'No barcode' }} • {{ formatCurrency(p.cost_price) }}</span>
                                        </button>
                                    </div>
                                </div>
                                <div class="col-span-4 md:col-span-2 space-y-1">
                                    <label class="text-[10px] uppercase font-bold text-zinc-400">Qty</label>
                                    <input v-model.number="item.quantity" type="number" min="1" @input="calculateRowTotal(index)"
                                           class="w-full h-10 px-3 text-sm bg-zinc-50 dark:bg-zinc-950 border-zinc-200 dark:border-zinc-800 rounded-lg">
                                </div>
                                <div class="col-span-4 md:col-span-2 space-y-1">
                                    <label class="text-[10px] uppercase font-bold text-zinc-400">Unit Cost</label>
                                    <input v-model.number="item.unit_cost" type="number" step="0.01" @input="calculateRowTotal(index)"
                                           class="w-full h-10 px-3 text-sm bg-zinc-50 dark:bg-zinc-950 border-zinc-200 dark:border-zinc-800 rounded-lg">
                                </div>
                                <div class="col-span-3 md:col-span-2 space-y-1">
                                    <label class="text-[10px] uppercase font-bold text-zinc-400">Total</label>
                                    <div class="h-10 flex items-center font-mono font-bold text-sm text-zinc-600 dark:text-zinc-400">
                                        {{ formatCurrency(item.total_cost) }}
                                    </div>
                                </div>
                                <div class="col-span-1 flex justify-center pb-2">
                                    <button type="button" @click="removeItem(index)" class="text-zinc-300 hover:text-red-500 transition-colors">
                                        <Trash2 :size="16" />
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Summary & Notes -->
                <div class="space-y-6">
                    <!-- Total Card -->
                    <div class="bg-red-600 rounded-xl p-6 text-white shadow-lg shadow-red-600/20">
                        <div class="text-xs font-bold uppercase tracking-widest opacity-75 mb-1">Total Order Amount</div>
                        <div class="text-3xl font-black">{{ formatCurrency(form.items.reduce((sum, i) => sum + i.total_cost, 0)) }}</div>
                        <div class="mt-4 pt-4 border-t border-white/10 text-xs opacity-75">
                            Estimated total based on current unit costs.
                        </div>
                    </div>

                    <!-- Notes -->
                    <div class="bg-white dark:bg-zinc-900 rounded-xl border border-zinc-200 dark:border-zinc-800 p-6 shadow-sm">
                        <h3 class="text-sm font-black uppercase tracking-widest text-zinc-400 mb-4 flex items-center gap-2">
                            <FileText :size="16" />
                            Internal Notes
                        </h3>
                        <textarea v-model="form.notes" rows="4" placeholder="Add any special instructions or notes..."
                                  class="w-full bg-zinc-50 dark:bg-zinc-950 border-zinc-200 dark:border-zinc-800 rounded-lg text-sm p-3 focus:ring-2 focus:ring-red-500"></textarea>
                    </div>
                </div>
            </div>
        </form>
    </MainLayout>
</template>
