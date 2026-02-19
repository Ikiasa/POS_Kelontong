<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head, Link, router } from '@inertiajs/vue3';
import { ref, watch } from 'vue';
import { 
    Package, Search, Plus, Edit2, Trash2, 
    Filter, ChevronRight, Tag, Barcode,
    AlertCircle, Image as ImageIcon
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

const deleteProduct = (id) => {
    if (confirm('Are you sure you want to delete this product?')) {
        router.delete(route('products.destroy', id));
    }
};
</script>

<template>
    <Head title="Products" />

    <MainLayout title="Inventory Master">
        <div class="space-y-6">
            <!-- Header & Search -->
            <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div class="flex flex-1 gap-3 max-w-2xl">
                    <div class="relative flex-1">
                        <Search class="absolute left-3 top-1/2 -translate-y-1/2 text-zinc-400" :size="18" />
                        <input v-model="search" type="text" placeholder="Search products..."
                           class="w-full pl-10 h-11 bg-zinc-50 dark:bg-zinc-950 border-zinc-200 dark:border-zinc-800 rounded-lg focus:ring-2 focus:ring-red-500 text-sm">
                    </div>
                    <select v-model="categoryFilter" 
                            class="h-11 px-4 bg-white dark:bg-zinc-900 border-zinc-200 dark:border-zinc-800 rounded-xl text-sm focus:ring-2 focus:ring-red-500 min-w-[150px]">
                        <option value="">All Categories</option>
                        <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
                    </select>
                </div>
                <Link :href="route('products.create')" 
                        class="bg-red-600 hover:bg-red-700 text-white px-6 h-11 rounded-xl flex items-center gap-2 font-bold shadow-lg shadow-red-600/20 transition-all">
                    <Plus :size="20" />
                    New Product
                </Link>
            </div>

            <!-- Product Table -->
            <div class="bg-white dark:bg-zinc-900 rounded-2xl border border-zinc-200 dark:border-zinc-800 overflow-hidden shadow-sm">
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-zinc-50 dark:bg-zinc-950/50 border-b border-zinc-200 dark:border-zinc-800">
                                <th class="px-6 py-4 text-xs font-bold text-zinc-400 uppercase tracking-widest">Image</th>
                                <th class="px-6 py-4 text-xs font-bold text-zinc-400 uppercase tracking-widest">Product Info</th>
                                <th class="px-6 py-4 text-xs font-bold text-zinc-400 uppercase tracking-widest">Category</th>
                                <th class="px-6 py-4 text-xs font-bold text-zinc-400 uppercase tracking-widest text-right">Selling Price</th>
                                <th class="px-6 py-4 text-xs font-bold text-zinc-400 uppercase tracking-widest text-right">Stock</th>
                                <th class="px-6 py-4 text-xs font-bold text-zinc-400 uppercase tracking-widest text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-zinc-100 dark:divide-zinc-800/50">
                            <tr v-for="p in products.data" :key="p.id" class="hover:bg-zinc-50/50 dark:hover:bg-zinc-800/30 transition-colors group">
                                <td class="px-6 py-4">
                                    <div class="w-12 h-12 bg-zinc-100 dark:bg-zinc-800 rounded-lg overflow-hidden border border-zinc-200 dark:border-zinc-700">
                                        <img v-if="p.image" :src="`/storage/${p.image}`" :alt="p.name" class="w-full h-full object-cover">
                                        <div v-else class="w-full h-full flex items-center justify-center text-zinc-400">
                                            <ImageIcon :size="20" />
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-4">
                                    <div class="flex items-center gap-4">
                                        <div>
                                            <div class="font-bold text-zinc-900 dark:text-white leading-tight mb-1">{{ p.name }}</div>
                                            <div class="flex items-center gap-2 text-[10px] font-mono text-zinc-400 uppercase tracking-wider">
                                                <Barcode :size="10" /> {{ p.barcode || 'NO-BARCODE' }}
                                            </div>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-4">
                                    <span class="px-2.5 py-1 rounded-lg bg-zinc-100 dark:bg-zinc-800 text-zinc-600 dark:text-zinc-400 text-[10px] font-bold uppercase tracking-wider">
                                        {{ p.category?.name || 'Uncategorized' }}
                                    </span>
                                </td>
                                <td class="px-6 py-4 text-right">
                                    <div class="font-bold text-zinc-900 dark:text-white">{{ formatCurrency(p.price) }}</div>
                                    <div class="text-[10px] text-zinc-400 uppercase">Cost: {{ formatCurrency(p.cost_price) }}</div>
                                </td>
                                <td class="px-6 py-4 text-right">
                                    <div class="font-black" :class="p.stock <= 10 ? 'text-red-500' : 'text-zinc-900 dark:text-white'">
                                        {{ p.stock }}
                                    </div>
                                    <div v-if="p.stock <= 10" class="text-[10px] text-red-400 font-bold uppercase animate-pulse">Low Stock</div>
                                </td>
                                <td class="px-6 py-4">
                                    <div class="flex items-center justify-center gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
                                        <a :href="route('products.batches.index', p.id)" class="p-2 text-zinc-400 hover:text-green-600 hover:bg-green-50 dark:hover:bg-green-900/20 rounded-lg transition-colors" title="Manage Batches">
                                            <Package :size="16" />
                                        </a>
                                        <Link :href="route('products.edit', p.id)" class="p-2 text-zinc-400 hover:text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition-colors">
                                            <Edit2 :size="16" />
                                        </Link>
                                        <button @click="deleteProduct(p.id)" class="p-2 text-zinc-400 hover:text-red-500 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition-colors">
                                            <Trash2 :size="16" />
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <tr v-if="products.data.length === 0">
                                <td colspan="6" class="px-6 py-20 text-center">
                                    <div class="max-w-xs mx-auto space-y-3 font-medium text-zinc-400">
                                        <Package :size="48" class="mx-auto opacity-20" />
                                        <p>No products found matching your criteria.</p>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div v-if="products.links.length > 3" class="px-6 py-4 border-t border-zinc-100 dark:border-zinc-800 flex justify-between items-center">
                    <div class="text-xs text-zinc-500">
                        Showing {{ products.from }} to {{ products.to }} of {{ products.total }} products
                    </div>
                    <div class="flex gap-2">
                        <button v-for="link in products.links" :key="link.label"
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
