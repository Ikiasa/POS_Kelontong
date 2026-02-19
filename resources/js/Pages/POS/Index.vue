<script setup>
import { Head, usePage } from '@inertiajs/vue3';
import { ref, computed, onMounted, onUnmounted } from 'vue';
import { usePosStore } from '@/Stores/posStore';
import { 
    Search, 
    ShoppingCart, 
    Trash2, 
    Plus, 
    Minus, 
    CreditCard,
    Package,
    Menu,
    User,
    Monitor,
    Printer,
    Scan,
    X
} from 'lucide-vue-next';
import CheckoutModal from '@/Components/POS/CheckoutModal.vue';

const props = defineProps({
    products: Array,
    products: Array,
    categories: Array,
    customers: Array,
});

const page = usePage();
const store = usePosStore();
const showCheckout = ref(false);
const barcodeInput = ref(null);
const currentUser = computed(() => page.props.auth?.user || { name: 'Cashier' });
const currentDate = ref(new Date().toLocaleDateString('id-ID', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }));

// Loyalty & Customer State
const selectedCustomer = ref(null);
const customerSearch = ref('');
const showCustomerModal = ref(false);

const filteredCustomers = computed(() => {
    if (!customerSearch.value) return props.customers;
    const q = customerSearch.value.toLowerCase();
    return props.customers.filter(c => c.name.toLowerCase().includes(q) || c.phone.includes(q));
});

const selectCustomer = (customer) => {
    selectedCustomer.value = customer;
    store.setCustomer(customer); // Need to update store to handle this
    showCustomerModal.value = false;
};

const redeemPoints = ref(false); // Toggle
const pointsToRedeem = computed(() => {
    if (!selectedCustomer.value || !redeemPoints.value) return 0;
    // Simple logic: Max 50% of transaction or all points
    const maxValue = store.total * 0.5;
    const maxPoints = Math.floor(maxValue / 50);
    return Math.min(selectedCustomer.value.points_balance, maxPoints);
});

const discountFromPoints = computed(() => pointsToRedeem.value * 50);

// Focus barcode input on mount and keep focus
const focusInput = () => {
    if (barcodeInput.value) barcodeInput.value.focus();
};

onMounted(() => {
    focusInput();
    window.addEventListener('keydown', handleGlobalKeydown);
});

onUnmounted(() => {
    window.removeEventListener('keydown', handleGlobalKeydown);
});

const handleGlobalKeydown = (e) => {
    // F12 for Payment
    if (e.key === 'F12') {
        e.preventDefault();
        if (store.cart.length > 0) showCheckout.value = true;
    }
    // F2 for Search (Focus input)
    if (e.key === 'F2') {
        e.preventDefault();
        focusInput();
    }
    // ESC to clear
    if (e.key === 'Escape') {
        if (showCheckout.value) showCheckout.value = false;
        // Optional: clear cart confirm?
    }
};

const handleSearch = () => {
    if (!store.searchQuery) return;
    
    // Direct match check from local props first for speed
    // Ideally this connects to backend if list is huge, but we have props.products
    const query = store.searchQuery.toLowerCase();
    const exactMatch = props.products.find(p => p.barcode === query);
    
    if (exactMatch) {
        store.addToCart(exactMatch);
        store.searchQuery = ''; // Clear after scan
    } else {
        // If not exact match, keep query for filter/modal (not fully implemented in this single view yet, assume scan-heavy)
        // For now, we rely on the computed `filteredProducts` if we wanted a search modal.
        // But the reference UI implies "Scan & Go". 
        // Let's look for name match if not barcode
        const nameMatch = props.products.find(p => p.name.toLowerCase().includes(query));
        if (nameMatch) {
             store.addToCart(nameMatch);
             store.searchQuery = '';
        }
    }
};

const formatCurrency = (value) => {
    return new Intl.NumberFormat('id-ID', {
        style: 'currency',
        currency: 'IDR',
        minimumFractionDigits: 0
    }).format(value);
};

const functionKeys = [
    { key: 'F1', label: 'NEW', action: () => store.clearCart() },
    { key: 'F2', label: 'SEARCH', action: focusInput },
    { key: 'F3', label: 'QTY', action: () => {} },
    { key: 'F4', label: 'PRICE', action: () => {} },
    { key: 'F5', label: 'MEMBER', action: () => {} },
    { key: 'F6', label: 'DISC', action: () => {} },
    { key: 'F7', label: 'VOID', action: () => {} },
    { key: 'F12', label: 'BAYAR', action: () => showCheckout.value = true, primary: true },
];
</script>

<template>
    <Head title="POS Terminal" />

    <div class="h-screen w-full flex flex-col bg-gray-100 font-sans overflow-hidden select-none">
        
        <!-- TOP HEADER (Brand/Dark Theme) -->
        <header class="h-14 bg-dark-bg text-white flex items-center justify-between px-4 shadow-md z-20 shrink-0">
            <div class="flex items-center gap-4">
                <div class="flex items-center gap-2 font-black text-xl tracking-tighter">
                    <div class="w-8 h-8 bg-brand-600 text-white rounded-md flex items-center justify-center shadow-sm">
                        <Monitor :size="20" stroke-width="3" />
                    </div>
                    <span>Kelontong<span class="font-light">POS</span></span>
                </div>
            </div>
            
            <div class="flex items-center gap-8 text-sm font-medium">
                <!-- Customer Selector In Header -->
                 <div class="relative group">
                    <button @click="showCustomerModal = !showCustomerModal" class="flex items-center gap-2 bg-zinc-800 hover:bg-zinc-700 px-3 py-1.5 rounded border border-zinc-700 transition-colors">
                        <User :size="16" class="text-brand-400" />
                        <span class="font-bold max-w-[100px] truncate">{{ selectedCustomer ? selectedCustomer.name : 'GUEST' }}</span>
                        <div v-if="selectedCustomer" class="bg-brand-600 text-[10px] px-1 rounded text-white">{{ selectedCustomer.points_balance }} pts</div>
                    </button>
                    
                    <!-- Dropdown/Modal (Simplified absolute for now) -->
                    <div v-if="showCustomerModal" class="absolute top-full right-0 mt-2 w-72 bg-white text-zinc-900 rounded-lg shadow-xl border border-zinc-200 p-2 z-50">
                        <input v-model="customerSearch" placeholder="Cari Pelanggan..." class="w-full px-3 py-2 text-sm border rounded mb-2" autofocus />
                        <div class="max-h-60 overflow-y-auto space-y-1">
                            <div @click="selectCustomer(null)" class="p-2 hover:bg-gray-100 rounded cursor-pointer text-sm font-bold text-gray-500">GUEST (No Loyalty)</div>
                            <div v-for="c in filteredCustomers" :key="c.id" @click="selectCustomer(c)" class="p-2 hover:bg-gray-100 rounded cursor-pointer text-sm flex justify-between">
                                <span>{{ c.name }}</span>
                                <span class="text-xs text-brand-600 font-bold max-w-[100px] text-right truncate">{{ c.phone }}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="flex flex-col items-center leading-none gap-0.5">
                    <span class="opacity-75 text-[10px] uppercase tracking-wider text-zinc-400">Station</span>
                    <span class="font-bold">CASHIER-01</span>
                </div>
                <div class="flex flex-col items-center leading-none gap-0.5">
                    <span class="opacity-75 text-[10px] uppercase tracking-wider text-zinc-400">Date</span>
                    <span class="font-bold">{{ currentDate }}</span>
                </div>
                 <div class="flex flex-col items-center leading-none gap-0.5">
                    <span class="opacity-75 text-[10px] uppercase tracking-wider text-zinc-400">Mode</span>
                    <span class="font-bold bg-zinc-800 border border-zinc-700 px-2 rounded text-xs">AUTO</span>
                </div>
                <div class="flex items-center gap-2 pl-4 border-l border-zinc-700">
                    <div class="w-8 h-8 rounded-full bg-zinc-800 border border-zinc-700 flex items-center justify-center">
                         <User :size="16" />
                    </div>
                    <div class="flex flex-col leading-none">
                        <span class="font-bold">{{ currentUser.name }}</span>
                        <span class="text-[10px] opacity-75 text-green-400">Online</span>
                    </div>
                </div>
            </div>
        </header>

        <!-- MAIN CONTENT -->
        <div class="flex-1 flex flex-col min-h-0 bg-white">
            
            <!-- TOP BAR (Inputs & Totals) -->
            <div class="px-6 py-4 bg-zinc-900 text-white shrink-0 flex items-center justify-between gap-6 shadow-xl z-20">
                <!-- Left: Input & Search -->
                <div class="flex-1 max-w-xl relative">
                    <div class="absolute left-0 -top-5 text-[10px] font-bold text-zinc-500 uppercase tracking-wider">Scan Item (F2)</div>
                    <div class="relative">
                        <input 
                            ref="barcodeInput"
                            v-model="store.searchQuery"
                            @keydown.enter="handleSearch"
                            type="text" 
                            class="w-full h-14 pl-12 pr-4 bg-zinc-800 text-white text-xl font-bold border-2 border-zinc-700 rounded-lg focus:ring-4 focus:ring-brand-900/50 focus:border-brand-600 focus:outline-none uppercase transition-all shadow-inner placeholder-zinc-600"
                            placeholder="SCAN BARCODE..."
                        />
                        <Search class="absolute left-4 top-1/2 -translate-y-1/2 text-zinc-500" :size="20" />
                        <div v-if="store.searchQuery" @click="store.searchQuery = ''; focusInput()" class="absolute right-4 top-1/2 -translate-y-1/2 cursor-pointer text-zinc-500 hover:text-white">
                            <X :size="16" />
                        </div>
                    </div>
                </div>

                <!-- Right: Financials -->
                <div class="flex items-center justify-end gap-8 flex-1">
                    <!-- Subtotal & Discount -->
                    <div class="flex gap-8 text-right hidden xl:flex">
                        <div class="flex flex-col justify-center">
                            <span class="text-[10px] font-bold text-zinc-500 uppercase tracking-widest mb-1">Subtotal</span>
                            <span class="text-lg font-semibold text-zinc-300 tracking-tight">{{ formatCurrency(store.subtotal) }}</span>
                        </div>
                        <div class="flex flex-col justify-center">
                            <span class="text-[10px] font-bold text-zinc-500 uppercase tracking-widest mb-1">Discount</span>
                            <span class="text-lg font-semibold text-danger tracking-tight">- {{ formatCurrency(discountFromPoints) }}</span>
                        </div>
                    </div>

                    <!-- Divider -->
                    <div class="h-12 w-px bg-zinc-700 hidden lg:block"></div>

                    <!-- Grand Total (Hero) -->
                    <div class="flex flex-col items-end justify-center min-w-[180px]">
                        <span class="text-[10px] font-bold text-zinc-400 uppercase tracking-widest mb-1">Grand Total</span>
                        <div class="relative leading-none flex items-baseline gap-1.5">
                             <span class="text-5xl font-extrabold tracking-tighter text-white tabular-nums">
                                {{ formatCurrency(store.total - discountFromPoints).replace('Rp', '').trim() }}
                            </span>
                            <span class="text-base font-medium text-zinc-500">Rp</span>
                        </div>
                    </div>

                    <!-- Pay Button -->
                    <button 
                        @click="showCheckout = true"
                        class="h-14 px-8 bg-gradient-to-br from-brand-600 to-brand-700 hover:from-brand-500 hover:to-brand-600 text-white rounded-lg shadow-lg shadow-brand-900/50 active:translate-y-0.5 transition-all flex items-center gap-3 group border border-brand-500/20"
                    >
                        <CreditCard :size="24" class="group-hover:scale-110 transition-transform" />
                        <div class="flex flex-col items-start leading-none">
                            <span class="text-lg font-black tracking-tight drop-shadow-sm">BAYAR</span>
                            <span class="text-[9px] bg-black/20 px-1.5 py-0.5 rounded font-bold opacity-80 group-hover:bg-black/30 shadow-inner">F12</span>
                        </div>
                    </button>
                </div>
             </div>

            <!-- TRANSACTION TABLE -->
            <div class="flex-1 overflow-auto bg-gray-100/50">
                <table class="w-full text-left border-collapse">
                    <thead class="bg-white text-gray-500 text-[11px] uppercase font-bold sticky top-0 z-10 shadow-sm border-b border-gray-200 tracking-wider">
                        <tr>
                            <th class="py-3 px-4 w-16 text-center bg-gray-50">No</th>
                            <th class="py-3 px-4 w-36 bg-gray-50">Kode Item</th>
                            <th class="py-3 px-4 bg-gray-50">Nama Item</th>
                            <th class="py-3 px-4 w-28 text-center bg-gray-50">Qty</th>
                            <th class="py-3 px-4 w-36 text-right bg-gray-50">Harga</th>
                            <th class="py-3 px-4 w-24 text-center bg-gray-50">Disc %</th>
                            <th class="py-3 px-4 w-40 text-right bg-gray-50">Subtotal</th>
                            <th class="py-3 px-4 w-16 text-center bg-gray-50"></th>
                        </tr>
                    </thead>
                    <tbody class="text-sm bg-white divide-y divide-gray-100">
                         <tr v-if="store.cart.length === 0">
                            <td colspan="8" class="h-64 text-center text-gray-400 italic">
                                <div class="flex flex-col items-center justify-center h-full opacity-50">
                                    <Package :size="48" class="mb-4 text-gray-300" />
                                    <span>Ready for transaction.. Scan item (F2) to start.</span>
                                </div>
                            </td>
                        </tr>
                        <tr 
                            v-for="(item, index) in store.cart" 
                            :key="item.id"
                            class="hover:bg-brand-50/50 transition-colors group"
                            :class="index % 2 === 0 ? 'bg-white' : 'bg-gray-50/30'"
                        >
                            <td class="py-3 px-4 text-center font-medium opacity-50">{{ index + 1 }}</td>
                            <td class="py-3 px-4 font-mono text-xs text-zinc-600 font-bold bg-zinc-50/50 rounded">{{ item.barcode || item.id }}</td>
                            <td class="py-3 px-4 font-bold text-gray-800">{{ item.name }}</td>
                            <td class="py-3 px-4 text-center">
                                <div class="inline-flex items-center border border-gray-200 rounded-lg bg-white shadow-sm">
                                    <button @click="store.updateQty(item.id, item.qty - 1)" class="w-8 h-8 flex items-center justify-center hover:bg-gray-100 text-gray-500 font-bold rounded-l-lg active:bg-gray-200">-</button>
                                    <input 
                                        type="number" 
                                        v-model.number="item.qty"
                                        @change="store.updateQty(item.id, item.qty)"
                                        class="w-12 text-center border-none p-0 focus:ring-0 font-bold text-gray-800 [-moz-appearance:_textfield] [&::-webkit-inner-spin-button]:m-0 [&::-webkit-inner-spin-button]:appearance-none" 
                                        min="1"
                                    />
                                    <button @click="store.updateQty(item.id, item.qty + 1)" class="w-8 h-8 flex items-center justify-center hover:bg-gray-100 text-gray-500 font-bold rounded-r-lg active:bg-gray-200">+</button>
                                </div>
                            </td>
                            <td class="py-3 px-4 text-right font-medium tabular-nums">{{ formatCurrency(item.price) }}</td>
                            <td class="py-3 px-4 text-center text-gray-400">-</td>
                            <td class="py-3 px-4 text-right font-bold text-gray-900 tabular-nums">{{ formatCurrency(item.price * item.qty) }}</td>
                            <td class="py-3 px-4 text-center">
                                <button @click="store.removeFromCart(item.id)" class="w-8 h-8 flex items-center justify-center rounded-full text-danger hover:text-white hover:bg-danger transition-all opacity-0 group-hover:opacity-100">
                                    <Trash2 :size="14" />
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- FOOTER INFO / FUNCTION KEYS (Cleaned up) -->
            <div class="h-14 bg-white border-t border-gray-200 flex items-center px-4 gap-3 overflow-x-auto shadow-[0_-4px_6px_-1px_rgba(0,0,0,0.05)] z-20">
                <button 
                    v-for="func in functionKeys" 
                    :key="func.key"
                    @click="func.action"
                    class="flex items-center gap-2 px-5 py-2 rounded-lg text-xs font-bold whitespace-nowrap border transition-all active:scale-95 shadow-sm"
                    :class="func.primary 
                        ? 'bg-brand-600 text-white border-brand-600 hover:bg-brand-700 hover:border-brand-700 shadow-md shadow-brand-200' 
                        : 'bg-white text-gray-600 border-gray-200 hover:bg-gray-50 hover:border-gray-300 hover:text-gray-900'"
                >
                    <span class="opacity-60 bg-black/5 px-1.5 py-0.5 rounded text-[10px]">{{ func.key }}</span>
                    <span>{{ func.label }}</span>
                </button>
            </div>
        </div>

        <!-- BOTTOM STATUS BAR (Minimal) -->
        <footer class="h-10 bg-zinc-900 text-white flex items-center justify-between px-4 shrink-0 text-[10px] font-medium tracking-wide">
            <!-- Hardware Status -->
            <div class="flex gap-6">
                 <div class="flex items-center gap-2 opacity-50">
                    <Monitor :size="14" />
                    <span>POLE DISPLAY</span>
                </div>
                <div class="flex items-center gap-2 opacity-50">
                    <Printer :size="14" />
                    <span>PRINTER OK</span>
                </div>
                 <div class="flex items-center gap-2 text-green-400">
                    <Scan :size="14" />
                     <span>SCANNER READY</span>
                </div>
            </div>

            <!-- Quick Info -->
            <div class="flex items-center gap-6 opacity-50">
                <span>VER 2.1.0</span>
                <span>LICENSE: PRO</span>
                <span>{{ currentDate }}</span>
            </div>
        </footer>

        <CheckoutModal 
            :show="showCheckout" 
            :subtotal="store.total"
            :discount="discountFromPoints"
            :grand-total="store.total - discountFromPoints"
            :customer="selectedCustomer"
            @close="showCheckout = false"
            @toggle-points="redeemPoints = !redeemPoints"
            :redeem-points="redeemPoints"
            :points-value="discountFromPoints"
        />
    </div>
</template>

<style scoped>
/* Custom Scrollbar for Table */
::-webkit-scrollbar {
    width: 8px;
    height: 8px;
}
::-webkit-scrollbar-track {
    background: #f1f1f1; 
}
::-webkit-scrollbar-thumb {
    background: #ccc; 
    border-radius: 4px;
}
::-webkit-scrollbar-thumb:hover {
    background: #aaa; 
}
</style>
