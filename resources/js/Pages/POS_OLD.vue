<script setup>
import PosLayout from '@/Layouts/PosLayout.vue';
import { Head } from '@inertiajs/vue3';
import { ref, computed, nextTick } from 'vue';
import { useCartStore } from '@/Stores/cartStore';
import Button from '@/Components/UI/Button.vue';
import Input from '@/Components/UI/Input.vue';
import { Search, ShoppingCart, Zap, Trash2 } from 'lucide-vue-next';
import PaymentModal from '@/Components/POS/PaymentModal.vue';
import { onMounted, onUnmounted, watch } from 'vue';
import { router } from '@inertiajs/vue3';

const props = defineProps({
    products: Array,
    categories: Array,
});

const cartStore = useCartStore();
const searchQuery = ref('');
const searchInputRef = ref(null);
const selectedCategory = ref('all');
const showPaymentModal = ref(false);
const searchDebounceTimer = ref(null);
const debouncedSearchQuery = ref('');

const isProcessing = ref(false);

// Debounce search query
watch(searchQuery, (newVal) => {
    if (searchDebounceTimer.value) {
        clearTimeout(searchDebounceTimer.value);
    }
    searchDebounceTimer.value = setTimeout(() => {
        debouncedSearchQuery.value = newVal;
    }, 300);
});

const handlePaymentSuccess = (data) => {
    alert(`Transaction successful! Invoice: ${data.invoice_number}`);
    cartStore.clear();
    // Force a fresh reload of props to ensure stock is updated
    router.reload({ 
        only: ['products'], 
        preserveState: false,
        onStart: () => isProcessing.value = true,
        onFinish: () => isProcessing.value = false
    });
};

const openPayment = () => {
    if (cartStore.items.length === 0 || isProcessing.value) return;
    showPaymentModal.value = true;
};

const handleKeyDown = (e) => {
    // F8 - Open payment
    if (e.key === 'F8') {
        e.preventDefault();
        openPayment();
    }
    // F2 - Focus search
    if (e.key === 'F2') {
        e.preventDefault();
        searchInputRef.value?.focus();
    }
    // ESC - Clear cart
    if (e.key === 'Escape' && cartStore.count > 0) {
        e.preventDefault();
        if (confirm(`Clear cart with ${cartStore.count} items?`)) {
            cartStore.clear();
        }
    }
    // Enter - Add first product from search results
    if (e.key === 'Enter' && document.activeElement === searchInputRef.value && filteredProducts.value.length > 0) {
        e.preventDefault();
        const firstProduct = filteredProducts.value[0];
        if (getEffectiveStock(firstProduct) > 0) {
            cartStore.add(firstProduct);
            searchQuery.value = ''; // Clear search after adding
        }
    }
};

onMounted(() => {
    window.addEventListener('keydown', handleKeyDown);
    window.addEventListener('open-payment', openPayment);
    // Autofocus search on mount
    nextTick(() => {
        searchInputRef.value?.focus();
    });
});

onUnmounted(() => {
    window.removeEventListener('keydown', handleKeyDown);
    window.removeEventListener('open-payment', openPayment);
});

const getEffectiveStock = (product) => {
    const itemInCart = cartStore.items.find(i => i.id === product.id);
    const quantityInCart = itemInCart ? itemInCart.quantity : 0;
    return product.stock - quantityInCart;
};

// Mock Data if empty (for dev)
const productsList = computed(() => props.products || [
    { id: 1, name: 'Sample Product 1', price: 15000, image: null, stock: 10, category_id: 1 },
    { id: 2, name: 'Sample Product 2', price: 25000, image: null, stock: 5, category_id: 1 },
    { id: 3, name: 'Sample Product 3', price: 5000, image: null, stock: 0, category_id: 2 },
]);

// Filter Logic (using debounced search)
const filteredProducts = computed(() => {
    return productsList.value.filter(p => {
        const matchesSearch = p.name.toLowerCase().includes(debouncedSearchQuery.value.toLowerCase());
        const matchesCategory = selectedCategory.value === 'all' || p.category_id === selectedCategory.value;
        return matchesSearch && matchesCategory;
    });
});

const formatPrice = (value) => {
    return new Intl.NumberFormat('id-ID', {
        style: 'currency',
        currency: 'IDR',
        minimumFractionDigits: 0
    }).format(value);
};
</script>

<template>
    <Head title="POS System" />

    <PosLayout>
        <!-- Product Grid Slot -->
        <template #grid>
            <!-- Search Bar moved to Layout -->
             <div class="mb-6 flex gap-4">
                <Input 
                    ref="searchInputRef"
                    v-model="searchQuery" 
                    placeholder="Search products or scan barcode... (F2)" 
                    :icon="Search"
                    class="flex-1"
                    autofocus
                />
                <div class="flex gap-2">
                    <Button 
                        v-for="cat in categories" 
                        :key="cat.id"
                        variant="secondary"
                        size="sm"
                        @click="selectedCategory = cat.id"
                        :class="{'!bg-zinc-900 !text-white ring-2 ring-zinc-900 ring-offset-2 dark:ring-offset-black': selectedCategory === cat.id}"
                    >
                        {{ cat.name }}
                    </Button>
                     <Button 
                        variant="secondary"
                        size="sm"
                        @click="selectedCategory = 'all'"
                        :class="{'!bg-zinc-900 !text-white': selectedCategory === 'all'}"
                    >
                        All
                    </Button>
                </div>
            </div>

            <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-4 pb-20 relative">
                <!-- Processing Overlay -->
                <div v-if="isProcessing" class="absolute inset-0 z-50 bg-white/50 dark:bg-zinc-900/50 backdrop-blur-sm flex items-center justify-center rounded-2xl">
                    <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-indigo-600"></div>
                </div>

                <div v-for="product in filteredProducts" :key="product.id" 
                     @click="getEffectiveStock(product) > 0 && cartStore.add(product)"
                     class="bg-white dark:bg-zinc-900 rounded-2xl border-2 border-gray-200 dark:border-zinc-800 overflow-hidden cursor-pointer group hover:border-indigo-500 hover:shadow-lg hover:shadow-indigo-500/20 dark:hover:border-indigo-500 transition-all flex flex-col h-full transform active:scale-[0.97] duration-150"
                     :class="{'opacity-50 grayscale cursor-not-allowed hover:shadow-none hover:scale-100': getEffectiveStock(product) <= 0}">
                    
                    <!-- Image Area -->
                    <div class="aspect-[4/3] bg-gray-50 dark:bg-zinc-950 relative flex items-center justify-center p-6">
                        <img v-if="product.image" :src="product.image" class="max-w-full max-h-full object-contain group-hover:scale-105 transition-transform duration-200">
                        <span v-else class="text-4xl opacity-30">&#128230;</span>
                        
                        <!-- Stock Badge -->
                        <div v-if="getEffectiveStock(product) <= 5" 
                             class="absolute top-3 right-3 px-2.5 py-1.5 text-xs font-bold rounded-lg border shadow-sm"
                             :class="getEffectiveStock(product) <= 0 ? 'bg-zinc-100 dark:bg-zinc-800 text-zinc-500 border-zinc-200' : 'bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 border-red-100 dark:border-red-500/20'">
                            {{ getEffectiveStock(product) <= 0 ? 'Out of Stock' : getEffectiveStock(product) + ' Left' }}
                        </div>
                    </div>

                    <!-- Content -->
                    <div class="p-4 flex-1 flex flex-col justify-between border-t-2 border-gray-100 dark:border-zinc-800 bg-white dark:bg-zinc-900 group-hover:bg-indigo-50/50 dark:group-hover:bg-indigo-950/20 transition-colors">
                        <h3 class="font-bold text-sm text-zinc-800 dark:text-zinc-100 line-clamp-2 leading-snug min-h-[2.5em] mb-2">
                            {{ product.name }}
                        </h3>
                        <div class="mt-auto">
                             <p class="text-zinc-900 dark:text-white font-black text-xl leading-none">
                                {{ formatPrice(product.price).replace('Rp', '').trim() }}
                            </p>
                            <p class="text-xs text-zinc-400 mt-1">{{ formatPrice(product.price) }}</p>
                        </div>
                    </div>
                </div>
            </div>
        </template>

        <!-- Cart Slot -->
        <template #cart>
            <div v-if="cartStore.items.length === 0" class="h-full flex flex-col items-center justify-center text-zinc-400 space-y-2 opacity-50">
                <span class="text-4xl">🛒</span>
                <p class="text-sm">Cart is empty</p>
            </div>

            <div v-for="(item, index) in cartStore.items" :key="item.id" 
                 class="bg-white dark:bg-zinc-900 rounded-xl p-3 border border-gray-200 dark:border-zinc-800 flex gap-3 group hover:border-indigo-500/30 transition-colors shadow-sm relative">
                
                <!-- Thumb -->
                <div class="w-12 h-12 rounded-lg bg-gray-50 dark:bg-zinc-950 shrink-0 border border-gray-100 dark:border-zinc-800 overflow-hidden flex items-center justify-center">
                    <img v-if="item.image" :src="item.image" class="w-full h-full object-cover">
                    <span v-else class="text-xs opacity-50">📦</span>
                </div>

                <div class="flex-1 min-w-0">
                    <h3 class="font-bold text-zinc-900 dark:text-white text-sm leading-tight">{{ item.name }}</h3>
                    <p class="text-xs text-zinc-500 mt-1">{{ formatPrice(item.price) }} × {{ item.quantity }}</p>
                </div>

                <div class="text-right shrink-0 flex flex-col items-end gap-2">
                     <p class="font-black text-zinc-900 dark:text-white text-base">{{ formatPrice(item.price * item.quantity) }}</p>
                     <div class="flex items-center gap-1">
                        <button @click="cartStore.updateQuantity(item.id, item.quantity - 1)" class="min-w-[44px] min-h-[44px] flex items-center justify-center hover:bg-gray-100 dark:hover:bg-zinc-800 rounded-lg text-zinc-500 hover:text-red-500 font-bold transition-colors active:scale-95">−</button>
                        <input 
                            type="number" 
                            :value="item.quantity" 
                            @input="e => cartStore.updateQuantity(item.id, parseInt(e.target.value) || 1)"
                            class="w-14 h-11 text-center font-bold bg-gray-50 dark:bg-zinc-950 border border-gray-200 dark:border-zinc-800 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none"
                            min="1"
                            :max="item.stock"
                        />
                        <button @click="cartStore.add(item)" class="min-w-[44px] min-h-[44px] flex items-center justify-center hover:bg-gray-100 dark:hover:bg-zinc-800 rounded-lg text-zinc-500 hover:text-green-500 font-bold transition-colors active:scale-95">+</button>
                        <button @click="cartStore.remove(item.id)" class="min-w-[44px] min-h-[44px] flex items-center justify-center hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg text-zinc-400 hover:text-red-500 transition-colors active:scale-95 ml-1">
                            <Trash2 :size="18" />
                        </button>
                     </div>
                </div>
            </div>
        </template>
        
        
        <!-- Pass totals to layout if needed via slots or store access in layout -->
    </PosLayout>

    <PaymentModal 
        v-if="showPaymentModal"
        :show="showPaymentModal"
        :items="cartStore.items"
        :subtotal="cartStore.subtotal"
        :tax="cartStore.tax"
        :total="cartStore.total"
        :discount="cartStore.discountAmount"
        :customer="cartStore.customer"
        @close="showPaymentModal = false"
        @success="handlePaymentSuccess"
    />
</template>
