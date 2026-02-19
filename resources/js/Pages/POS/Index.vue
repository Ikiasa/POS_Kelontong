<script setup>
import { Head, usePage } from '@inertiajs/vue3';
import { ref, computed, onMounted, onUnmounted } from 'vue';
import axios from 'axios';
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
    X,
    Wifi,
    WifiOff
} from 'lucide-vue-next';
import CheckoutModal from '@/Components/POS/CheckoutModal.vue';
import { offlineSync } from '@/Services/OfflineSyncService';

const props = defineProps({
    products: Array,
    categories: Array,
    customers: Array,
    currentShift: Object,
    pendingTransactions: Array,
});

const page = usePage();
const store = usePosStore();
const showCheckout = ref(false);
const barcodeInput = ref(null);
const currentUser = computed(() => page.props.auth?.user || { name: 'Cashier' });
const currentDate = ref(new Date().toLocaleDateString('id-ID', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }));

// Shift State
const showShiftModal = ref(!props.currentShift);
const openingBalance = ref(0);
const cashRecorded = ref(0);
const showCloseShiftModal = ref(false);

// Offline State
const isOffline = ref(!navigator.onLine);
const validationCode = ref('');
const useOfflineOpen = ref(false);

window.addEventListener('online', () => isOffline.value = false);
window.addEventListener('offline', () => isOffline.value = true);

const openShift = async () => {
    try {
        await axios.post(route('shifts.open'), { 
            opening_balance: openingBalance.value,
            validation_code: validationCode.value,
            is_offline: useOfflineOpen.value
        });
        window.location.reload();
    } catch (e) { alert(e.response?.data?.message || 'Gagal membuka shift'); }
};

const closeShift = async () => {
    try {
        await axios.post(route('shifts.close'), { cash_recorded: cashRecorded.value });
        window.location.reload();
    } catch (e) { alert('Gagal menutup shift'); }
};

// Pending Transaction State
const showPendingList = ref(false);
const parkSale = async () => {
    if (store.cart.length === 0) return;
    try {
        await axios.post(route('pending.store'), { 
            cart: store.cart, 
            total: store.total,
            customer_id: selectedCustomer.value?.id 
        });
        store.clearCart();
        window.location.reload(); // Refresh to get updated pending list
    } catch (e) { 
        console.error('Park Sale Failed:', e);
        const serverMsg = e.response?.data?.message || '';
        alert('Gagal parkir transaksi: ' + serverMsg); 
    }
};

const recallSale = async (id) => {
    try {
        const res = await axios.get(route('pending.recall', id));
        const pending = res.data.data;
        const cartData = Array.isArray(pending.cart_data) ? pending.cart_data : (pending.cart_data.items || []);
        
        store.clearCart();
        cartData.forEach(item => {
            const quantity = item.qty || item.quantity || 1;
            store.addToCart(item, quantity);
        });
        
        showPendingList.value = false;
        await axios.delete(route('pending.destroy', id));
    } catch (e) { 
        console.error('Recall Failed:', e);
        const serverMsg = e.response?.data?.message || '';
        alert('Gagal memanggil transaksi: ' + serverMsg); 
    }
};

// Price Checker Mode
const isPriceChecker = ref(false);
const lastScannedProduct = ref(null);
const togglePriceChecker = () => {
    isPriceChecker.value = !isPriceChecker.value;
    lastScannedProduct.value = null;
    focusInput();
};

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

const syncStatus = ref('idle'); // 'idle' | 'syncing'

onMounted(async () => {
    focusInput();
    window.addEventListener('keydown', handleGlobalKeydown);
    
    // Initialize Offline Sync
    if (props.products) {
        await offlineSync.cacheProducts(props.products);
    }
    
    // Start background sync on mount
    syncStatus.value = 'syncing';
    await offlineSync.syncPendingTransactions();
    syncStatus.value = 'idle';

    // Listen for reconnection
    window.addEventListener('online', async () => {
        syncStatus.value = 'syncing';
        await offlineSync.syncPendingTransactions();
        syncStatus.value = 'idle';
    });
});

onUnmounted(() => {
    window.removeEventListener('keydown', handleGlobalKeydown);
});

const handleGlobalKeydown = (e) => {
    // Prevent default for all POS function keys
    if (['F1', 'F2', 'F3', 'F4', 'F7', 'F8', 'F9', 'F12'].includes(e.key)) {
        e.preventDefault();
    }

    if (e.key === 'F1') store.clearCart();
    if (e.key === 'F2') focusInput();
    if (e.key === 'F9') parkSale();
    if (e.key === 'F4') showPendingList.value = true;
    if (e.key === 'F7') togglePriceChecker();
    if (e.key === 'F8') showCloseShiftModal.value = true;
    if (e.key === 'F12') {
        if (store.cart.length > 0) showCheckout.value = true;
    }

    if (e.key === 'Escape') {
        if (showCheckout.value) showCheckout.value = false;
        if (showPendingList.value) showPendingList.value = false;
        if (showCloseShiftModal.value) showCloseShiftModal.value = false;
    }
};

const handleSearch = () => {
    if (!store.searchQuery) return;
    
    const query = store.searchQuery.toLowerCase();
    
    // Fresh Food / Weighted Barcode Check (Prefix 22)
    if (query.startsWith('22') && query.length === 13) {
        const productCode = query.substring(2, 7);
        const weight = parseInt(query.substring(7, 12)) / 1000;
        const product = props.products.find(p => p.barcode === productCode || p.id == productCode);
        if (product) {
            store.addToCart(product, weight);
            store.searchQuery = '';
            return;
        }
    }

    const exactMatch = props.products.find(p => p.barcode === query);
    if (exactMatch) {
        if (isPriceChecker.value) {
            lastScannedProduct.value = exactMatch;
            store.searchQuery = '';
            // Auto hide after 5 seconds
            setTimeout(() => { if (lastScannedProduct.value?.id === exactMatch.id) lastScannedProduct.value = null; }, 5000);
            return;
        }
        store.addToCart(exactMatch);
        store.searchQuery = '';
    } else {
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
    { key: 'F9', label: 'PARK', action: parkSale },
    { key: 'F4', label: 'RECALL', action: () => showPendingList.value = true },
    { key: 'F7', label: 'KIOSK', action: togglePriceChecker },
    { key: 'F8', label: 'OUT', action: () => showCloseShiftModal.value = true },
    { key: 'F12', label: 'BAYAR', action: () => showCheckout.value = true, primary: true },
];
</script>

<template>
    <Head title="Enterprise POS Terminal" />

    <div class="h-screen w-full flex flex-col bg-surface-50 dark:bg-dark-bg font-sans overflow-hidden select-none transition-colors duration-300">
        
        <!-- MODERN ENTERPRISE HEADER -->
        <header class="h-16 bg-dark-surface text-white flex items-center justify-between px-6 shadow-soft z-30 shrink-0 border-b border-dark-border">
            <div class="flex items-center gap-6">
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 bg-brand-600 text-white rounded-xl flex items-center justify-center shadow-lg ring-1 ring-white/20">
                        <Monitor :size="22" stroke-width="2.5" />
                    </div>
                    <div class="flex flex-col leading-none">
                        <span class="font-black text-lg tracking-tighter uppercase italic font-serif">Kelontong<span class="text-brand-400">POS</span></span>
                        <span class="text-[9px] font-black uppercase tracking-[0.2em] text-surface-500">Enterprise v2.5</span>
                    </div>
                </div>

                <div class="h-8 w-px bg-dark-border hidden md:block"></div>

                <!-- Live Connection & Sync Status -->
                <div class="hidden sm:flex items-center gap-4">
                    <div class="flex items-center gap-2 px-3 py-1.5 rounded-lg bg-black/20 border border-dark-border">
                        <div class="w-2 h-2 rounded-full" :class="!isOffline ? 'bg-emerald-500 animate-pulse' : 'bg-amber-500'"></div>
                        <span class="text-[10px] font-black tracking-widest uppercase" :class="!isOffline ? 'text-emerald-400' : 'text-amber-400'">
                            {{ !isOffline ? 'LIVE CONNECTED' : 'OFFLINE MODE' }}
                        </span>
                    </div>
                    
                    <div v-if="syncStatus === 'syncing'" class="flex items-center gap-2 text-brand-400">
                        <Activity :size="14" class="animate-spin" />
                        <span class="text-[10px] font-black uppercase tracking-widest">DRY-SYNCING...</span>
                    </div>
                </div>
            </div>
            
            <div class="flex items-center gap-6">
                <!-- Customer Context Chip -->
                <button @click="showCustomerModal = !showCustomerModal" 
                        class="flex items-center gap-3 bg-surface-900/50 hover:bg-surface-900 px-4 py-2 rounded-xl border border-dark-border transition-all active:scale-95 group relative">
                    <div class="w-7 h-7 rounded-lg bg-brand-600/20 flex items-center justify-center text-brand-400">
                        <User :size="16" />
                    </div>
                    <div class="flex flex-col items-start leading-none min-w-[100px]">
                        <span class="text-xs font-black tracking-tight group-hover:text-brand-300 transition-colors uppercase font-serif italic">
                            {{ selectedCustomer ? selectedCustomer.name : 'PUBLIC GUEST' }}
                        </span>
                        <span v-if="selectedCustomer" class="text-[9px] text-surface-500 font-bold mt-0.5">
                            LOYALTY ENABLED • {{ selectedCustomer.points_balance }} PTS
                        </span>
                        <span v-else class="text-[9px] text-surface-500 font-bold mt-0.5">WALK-IN CUSTOMER</span>
                    </div>

                    <!-- Customer Dropdown (Enterprise Style) -->
                    <div v-if="showCustomerModal" class="absolute top-full right-0 mt-3 w-80 bg-white dark:bg-dark-surface text-slate-900 dark:text-zinc-200 rounded-2xl shadow-premium border border-surface-100 dark:border-dark-border p-4 z-50 animate-in fade-in slide-in-from-top-2 duration-200">
                        <div class="relative mb-3">
                            <input v-model="customerSearch" placeholder="Search customer (Name/Phone)..." 
                                   class="w-full pl-8 pr-4 py-2 text-xs bg-surface-50 dark:bg-dark-bg border border-surface-200 dark:border-dark-border rounded-lg focus:ring-2 focus:ring-brand-500 outline-none" autofocus />
                            <Search class="absolute left-2.5 top-1/2 -translate-y-1/2 text-slate-400" :size="14" />
                        </div>
                        <div class="max-h-60 overflow-y-auto custom-scrollbar space-y-1">
                            <div @click="selectCustomer(null)" class="p-2 hover:bg-surface-100 dark:hover:bg-zinc-800 rounded-lg cursor-pointer text-xs font-black text-slate-400 uppercase tracking-widest text-center border border-dashed border-surface-200 dark:border-dark-border mb-2">
                                Clear / Guest Mode
                            </div>
                            <div v-for="c in filteredCustomers" :key="c.id" @click="selectCustomer(c)" class="p-3 hover:bg-brand-50 dark:hover:bg-brand-900/20 rounded-xl cursor-pointer transition-colors border border-transparent hover:border-brand-200 dark:hover:border-brand-800">
                                <div class="flex justify-between items-center">
                                    <span class="text-sm font-bold">{{ c.name }}</span>
                                    <span class="text-[10px] font-black text-brand-500">{{ c.phone }}</span>
                                </div>
                                <div class="text-[10px] text-slate-400 mt-1">ID: #{{ c.id }} • Balance: {{ c.points_balance }} pts</div>
                            </div>
                        </div>
                    </div>
                </button>

                <div class="h-8 w-px bg-dark-border"></div>

                <!-- Clock & User -->
                <div class="flex items-center gap-4">
                    <div class="text-right hidden lg:block">
                        <div class="text-xs font-black text-white px-2 py-0.5 bg-brand-600 rounded-md shadow-sm italic">{{ currentDate }}</div>
                        <div class="text-[9px] font-bold text-surface-500 uppercase tracking-[0.2em] mt-1 text-center">Operational Shift A</div>
                    </div>
                </div>
            </div>
        </header>

        <!-- MAIN CONTENT CONSOLE -->
        <div class="flex-1 flex flex-col min-h-0 bg-white dark:bg-dark-bg">
            
            <!-- HIGH-VELOCITY INPUT & FINANCIAL HERO -->
            <div class="px-8 py-6 bg-white dark:bg-zinc-900 flex items-center justify-between gap-10 shadow-soft border-b border-surface-100 dark:border-dark-border z-20 shrink-0">
                
                <!-- TERMINAL INPUT SECTOR -->
                <div class="flex-1 max-w-2xl relative group">
                    <div class="absolute left-0 -top-6 flex items-center gap-2">
                        <span class="text-[10px] font-black text-slate-400 dark:text-zinc-500 uppercase tracking-widest pl-1">Command Terminal (F2)</span>
                        <div class="flex items-center gap-1">
                            <div class="w-1.5 h-1.5 rounded-full bg-brand-500 animate-pulse"></div>
                            <span class="text-[8px] font-bold text-brand-500">READY</span>
                        </div>
                    </div>
                    
                    <div class="relative">
                        <input 
                            ref="barcodeInput"
                            v-model="store.searchQuery"
                            @keydown.enter="handleSearch"
                            type="text" 
                            class="w-full h-16 pl-14 pr-12 bg-surface-50 dark:bg-dark-surface text-slate-900 dark:text-zinc-100 text-xl font-black tracking-tight border-2 border-surface-200 dark:border-dark-border rounded-2xl focus:ring-8 focus:ring-brand-500/10 focus:border-brand-600 focus:outline-none uppercase transition-all shadow-inner placeholder-slate-300 dark:placeholder-zinc-700"
                            placeholder="SCAN CODE OR SEARCH PRODUCT..."
                        />
                        <div class="absolute left-5 top-1/2 -translate-y-1/2 text-slate-400 dark:text-zinc-500">
                            <Scan :size="24" stroke-width="2.5" />
                        </div>
                        <div v-if="store.searchQuery" @click="store.searchQuery = ''; focusInput()" class="absolute right-5 top-1/2 -translate-y-1/2 cursor-pointer text-slate-300 hover:text-slate-600 dark:hover:text-zinc-300 transition-colors">
                            <X :size="20" stroke-width="3" />
                        </div>
                    </div>

                    <!-- Input Helpers -->
                    <div class="absolute right-4 -bottom-6 flex gap-3 text-[9px] font-black text-slate-400 uppercase tracking-wider opacity-0 group-hover:opacity-100 transition-opacity">
                         <span>[ESC] CLEAR</span>
                         <span>[ENTER] SUBMIT</span>
                    </div>
                </div>

                <!-- FINANCIAL COMMAND CENTER -->
                <div class="flex items-center justify-end gap-10 flex-1">
                    
                    <!-- Performance Metrics Grid -->
                    <div class="grid grid-cols-2 gap-8 text-right hidden xl:grid">
                        <div class="flex flex-col justify-center">
                            <span class="text-[10px] font-black text-slate-400 dark:text-zinc-500 uppercase tracking-[0.2em] mb-1">Subtotal</span>
                            <span class="text-xl font-black text-slate-900 dark:text-zinc-200 tracking-tighter">{{ formatCurrency(store.subtotal) }}</span>
                        </div>
                        <div class="flex flex-col justify-center">
                            <span class="text-[10px] font-black text-slate-400 dark:text-zinc-500 uppercase tracking-[0.2em] mb-1">Deduction</span>
                            <span class="text-xl font-black text-red-600 tracking-tighter">- {{ formatCurrency(discountFromPoints) }}</span>
                        </div>
                    </div>

                    <div class="h-14 w-px bg-slate-100 dark:bg-dark-border hidden lg:block"></div>

                    <!-- THE TOTAL HERO -->
                    <div class="flex flex-col items-end justify-center min-w-[220px] transition-all transform hover:scale-105">
                        <span class="text-[10px] font-black text-brand-600 uppercase tracking-[0.3em] mb-1">Amount Due</span>
                        <div class="relative leading-none flex items-baseline gap-2">
                             <span class="text-6xl font-black tracking-tighter text-slate-900 dark:text-zinc-100 tabular-nums italic">
                                {{ formatCurrency(store.total - discountFromPoints).replace('Rp', '').trim() }}
                            </span>
                            <span class="text-lg font-black text-slate-400 italic">IDR</span>
                        </div>
                    </div>

                    <!-- TRIGGER CHECKOUT -->
                    <button 
                        @click="showCheckout = true"
                        class="h-16 px-10 bg-brand-600 hover:bg-brand-700 text-white rounded-2xl shadow-premium hover:shadow-lg active:scale-95 transition-all flex items-center gap-4 group border-b-4 border-brand-800"
                    >
                        <CreditCard :size="28" class="group-hover:-rotate-12 transition-transform" />
                        <div class="flex flex-col items-start leading-none">
                            <span class="text-xl font-black tracking-tight">COLLECT</span>
                            <span class="text-[10px] font-black opacity-60 flex items-center gap-1">
                                <span class="bg-black/20 px-1 rounded">F12</span>
                            </span>
                        </div>
                    </button>
                </div>
             </div>

            <!-- ENTERPRISE TRANSACTION LEDGER -->
            <div class="flex-1 overflow-auto bg-surface-50 dark:bg-dark-bg/50 custom-scrollbar">
                <table class="w-full text-left border-collapse min-w-[1000px]">
                    <thead class="bg-white dark:bg-zinc-900 text-slate-400 dark:text-zinc-500 text-[10px] font-black uppercase tracking-[0.2em] sticky top-0 z-10 shadow-sm border-b border-surface-100 dark:border-dark-border">
                        <tr>
                            <th class="py-5 px-6 w-16 text-center">#</th>
                            <th class="py-5 px-6 w-48">Identifier</th>
                            <th class="py-5 px-6">Product Nomenclature</th>
                            <th class="py-5 px-6 w-36 text-center">Quantity</th>
                            <th class="py-5 px-6 w-40 text-right">Unit Price</th>
                            <th class="py-5 px-6 w-44 text-right">Line Total</th>
                            <th class="py-5 px-6 w-20 text-center"></th>
                        </tr>
                    </thead>
                    <tbody class="text-sm bg-white dark:bg-dark-bg divide-y divide-surface-100 dark:divide-dark-border">
                         <tr v-if="store.cart.length === 0">
                            <td colspan="7" class="h-[50vh] text-center">
                                <div class="flex flex-col items-center justify-center h-full opacity-20">
                                    <Scan :size="120" stroke-width="0.5" class="mb-6 text-slate-300 dark:text-zinc-400" />
                                    <span class="text-2xl font-black tracking-tightest uppercase italic">Console Awaiting Input</span>
                                    <span class="text-xs font-bold mt-2">SYSTEM READY • 128-BIT SECURE</span>
                                </div>
                            </td>
                        </tr>
                        <tr 
                            v-for="(item, index) in store.cart" 
                            :key="item.id"
                            class="hover:bg-brand-50/30 dark:hover:bg-brand-900/5 transition-all group"
                        >
                            <td class="py-5 px-6 text-center">
                                <span class="text-[10px] font-black text-slate-300 dark:text-zinc-700">0{{ index + 1 }}</span>
                            </td>
                            <td class="py-5 px-6 font-black text-[11px] text-zinc-500 dark:text-zinc-500">
                                <div class="px-2 py-1 bg-surface-50 dark:bg-dark-surface rounded-md border border-surface-200 dark:border-dark-border inline-block tracking-widest">
                                    {{ item.barcode || item.id }}
                                </div>
                            </td>
                            <td class="py-5 px-6">
                                <div class="flex flex-col">
                                    <span class="font-black text-slate-800 dark:text-zinc-200 text-base tracking-tight">{{ item.name }}</span>
                                    <div class="flex items-center gap-2 mt-1">
                                         <span class="text-[9px] font-black uppercase text-brand-500 bg-brand-50 dark:bg-brand-900/20 px-1.5 py-0.5 rounded">Category #{{ item.category_id || 'STD' }}</span>
                                         <!-- Margin Indicator Mock (Real intelligence) -->
                                         <span v-if="item.price < (item.buy_price * 1.1)" class="text-[9px] font-black text-red-500 flex items-center gap-1">
                                             <AlertCircle :size="10" /> CRITICAL MARGIN
                                         </span>
                                         <span v-else class="text-[9px] font-black text-emerald-500 flex items-center gap-1">
                                             <Activity :size="10" /> HEALTHY MARGIN
                                         </span>
                                    </div>
                                </div>
                            </td>
                            <td class="py-5 px-6">
                                <div class="flex items-center justify-center p-1 bg-surface-50 dark:bg-dark-surface rounded-xl border border-surface-200 dark:border-dark-border w-28 mx-auto shadow-inner">
                                    <button @click="store.updateQty(item.id, item.qty - 1)" class="w-8 h-8 flex items-center justify-center hover:bg-white dark:hover:bg-zinc-800 text-slate-400 font-black rounded-lg transition-all active:scale-90">-</button>
                                    <input 
                                        type="number" 
                                        v-model.number="item.qty"
                                        @change="store.updateQty(item.id, item.qty)"
                                        class="w-10 text-center border-none bg-transparent p-0 focus:ring-0 font-black text-slate-800 dark:text-zinc-100 text-sm tabular-nums" 
                                        min="1"
                                    />
                                    <button @click="store.updateQty(item.id, item.qty + 1)" class="w-8 h-8 flex items-center justify-center hover:bg-white dark:hover:bg-zinc-800 text-slate-400 font-black rounded-lg transition-all active:scale-90">+</button>
                                </div>
                            </td>
                            <td class="py-5 px-6 text-right font-bold text-slate-600 dark:text-zinc-400 tabular-nums">{{ formatCurrency(item.price) }}</td>
                            <td class="py-5 px-6 text-right font-black text-slate-900 dark:text-zinc-100 text-base tabular-nums italic">{{ formatCurrency(item.price * item.qty) }}</td>
                            <td class="py-5 px-6 text-center">
                                <button @click="store.removeFromCart(item.id)" class="w-8 h-8 flex items-center justify-center rounded-xl text-red-500 hover:text-white hover:bg-red-500 transition-all opacity-0 group-hover:opacity-100 shadow-sm">
                                    <Trash2 :size="14" />
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- PREMIUM CONSOLE FUNCTION BUTTONS -->
            <div class="h-16 bg-white dark:bg-zinc-900 border-t border-surface-100 dark:border-dark-border flex items-center px-6 gap-4 overflow-x-auto shadow-premium z-20 transition-colors">
                <button 
                    v-for="func in functionKeys" 
                    :key="func.key"
                    @click="func.action"
                    class="flex items-center gap-3 px-6 py-2.5 rounded-xl text-[10px] font-black uppercase tracking-widest border transition-all active:scale-95 group"
                    :class="func.primary 
                        ? 'bg-brand-600 text-white border-brand-700 hover:bg-brand-700 shadow-premium' 
                        : 'bg-surface-50 dark:bg-dark-surface text-slate-600 dark:text-zinc-400 border-surface-200 dark:border-dark-border hover:bg-white dark:hover:bg-zinc-800'"
                >
                    <span class="opacity-40 group-hover:opacity-100 transition-opacity">{{ func.key }}</span>
                    <span>{{ func.label }}</span>
                </button>
            </div>
        </div>

        <!-- ENTERPRISE STATUS BAR -->
        <footer class="h-10 bg-dark-bg text-white flex items-center justify-between px-6 shrink-0 text-[9px] font-black uppercase tracking-widest border-t border-dark-border">
            <div class="flex gap-8">
                 <div class="flex items-center gap-2 opacity-40 hover:opacity-100 transition-opacity cursor-default">
                    <div class="w-1.5 h-1.5 rounded-full bg-emerald-500"></div>
                    <span>Pole Display: ACTIVE</span>
                </div>
                <div class="flex items-center gap-2 opacity-40 hover:opacity-100 transition-opacity cursor-default">
                    <div class="w-1.5 h-1.5 rounded-full bg-emerald-500"></div>
                    <span>Printer: RTS (Ready to Send)</span>
                </div>
                 <div class="flex items-center gap-2 text-emerald-500">
                    <div class="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></div>
                    <span>Scanner: OPTIMIZED</span>
                </div>
            </div>

            <div class="flex items-center gap-8 text-zinc-500 font-bold">
                <span>SES_ID: {{ currentShift?.id || 'GLOBAL_ROOT' }}</span>
                <span class="text-zinc-700">|</span>
                <span class="text-brand-500">SECURE_NODE_01</span>
                <span class="text-zinc-700">|</span>
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

        <!-- SHIFT START OVERLAY -->
        <div v-if="showShiftModal" class="fixed inset-0 z-[200] bg-surface-900/60 backdrop-blur-xl flex items-center justify-center p-4 animate-in fade-in duration-300">
            <div class="bg-white dark:bg-dark-surface rounded-[40px] w-full max-w-sm overflow-hidden flex flex-col animate-in zoom-in-95 duration-300 relative border border-brand-500/10 shadow-premium">
                
                <!-- Strategic Header -->
                <div class="p-10 text-center space-y-4">
                    <div class="w-20 h-20 mx-auto bg-brand-50 dark:bg-brand-900/10 rounded-[24px] flex items-center justify-center text-brand-600 relative overflow-hidden group">
                        <Monitor :size="40" stroke-width="2.5" class="relative z-10 transition-transform group-hover:scale-110" />
                        <div class="absolute inset-0 bg-brand-600/5 animate-pulse"></div>
                    </div>
                    
                    <div class="space-y-1">
                        <h2 class="text-2xl font-black text-slate-900 dark:text-zinc-100 tracking-tighter uppercase font-serif italic">Buka Shift Baru</h2>
                        <p class="text-[10px] font-black text-slate-400 dark:text-surface-500 uppercase tracking-widest leading-relaxed px-4">
                            Masukkan saldo awal kasir (untuk kembalian) untuk memulai transaksi hari ini.
                        </p>
                    </div>
                </div>

                <div class="px-10 pb-10 space-y-8">
                    <div class="space-y-2">
                        <label class="text-[9px] font-black text-slate-400 uppercase tracking-[0.2em] pl-1">Saldo Awal (Modal Tunai)</label>
                        <div class="relative">
                            <input v-model="openingBalance" type="number" 
                                   class="w-full h-20 text-4xl font-black text-center bg-surface-50 dark:bg-dark-bg/40 border-2 border-surface-100 dark:border-dark-border rounded-2xl focus:ring-8 focus:ring-brand-500/10 focus:border-brand-600 outline-none transition-all tabular-nums italic" />
                            <div class="absolute left-6 top-1/2 -translate-y-1/2 text-xl font-black text-slate-300">Rp</div>
                        </div>
                    </div>

                    <!-- Offline Open Toggle -->
                    <div v-if="isOffline" class="p-5 bg-amber-50 dark:bg-amber-950/20 rounded-2xl border border-amber-100 dark:border-amber-900/30">
                        <div class="flex items-center justify-between mb-3">
                             <span class="text-[10px] font-black text-amber-600 uppercase tracking-widest">MODE OFFLINE TERDETEKSI</span>
                             <input type="checkbox" v-model="useOfflineOpen" class="w-4 h-4 rounded border-amber-300 text-amber-600 focus:ring-amber-500" />
                        </div>
                        <div v-if="useOfflineOpen" class="space-y-3 animate-in fade-in slide-in-from-top-2">
                             <label class="text-[9px] font-black text-amber-500 uppercase tracking-widest pl-1">Kode Validasi Pusat</label>
                             <input v-model="validationCode" type="text" class="w-full h-12 text-lg font-black text-center bg-white dark:bg-dark-bg border border-amber-200 dark:border-amber-900/40 rounded-xl focus:ring-4 focus:ring-amber-500/10 focus:border-amber-500 outline-none uppercase tracking-[0.3em]" placeholder="ABCDEF" />
                        </div>
                    </div>

                    <button @click="openShift" class="h-16 w-full bg-slate-900 dark:bg-zinc-800 text-white rounded-2xl font-black text-sm uppercase tracking-widest hover:bg-black transition-all shadow-xl active:scale-95 flex items-center justify-center gap-3 group">
                        <span>MULAI KASIR OPERASIONAL</span>
                        <ChevronRight :size="18" class="group-hover:translate-x-1 transition-transform" />
                    </button>
                </div>
            </div>
        </div>

        <!-- CLOSE SHIFT MODAL -->
        <div v-if="showCloseShiftModal" class="fixed inset-0 z-[200] bg-surface-900/60 backdrop-blur-xl flex items-center justify-center p-4 animate-in fade-in duration-300">
            <div class="bg-white dark:bg-dark-surface rounded-[40px] w-full max-w-sm overflow-hidden flex flex-col animate-in zoom-in-95 duration-300 relative border border-brand-500/10 shadow-premium">
                <div class="p-10 text-center space-y-4">
                     <div class="w-20 h-20 mx-auto bg-red-50 dark:bg-red-900/10 rounded-[24px] flex items-center justify-center text-red-600">
                        <LogOut :size="40" stroke-width="2.5" />
                    </div>
                    <div class="space-y-1">
                        <h2 class="text-2xl font-black text-slate-900 dark:text-zinc-100 tracking-tighter uppercase font-serif italic">Tutup Shift & Setoran</h2>
                        <p class="text-[10px] font-black text-slate-400 dark:text-surface-500 uppercase tracking-widest">Finalisasi rekonsiliasi kas harian.</p>
                    </div>
                </div>

                <div class="px-10 pb-10 space-y-6">
                    <div class="p-5 bg-surface-50 dark:bg-dark-bg/40 rounded-2xl border border-surface-100 dark:border-dark-border">
                        <div class="text-[9px] font-black text-surface-500 uppercase tracking-widest mb-1">Total Transaksi (Sistem)</div>
                        <div class="text-2xl font-black text-slate-900 dark:text-zinc-100 italic tabular-nums">{{ formatCurrency(store.subtotal) }}</div>
                    </div>
                    
                    <div class="space-y-2">
                        <label class="text-[9px] font-black text-slate-400 uppercase tracking-[0.2em] pl-1">Hitung Tunai di Laci</label>
                        <input v-model="cashRecorded" type="number" class="w-full h-16 text-3xl font-black text-center bg-surface-50 dark:bg-dark-bg/40 border-2 border-surface-100 dark:border-dark-border rounded-2xl focus:ring-8 focus:ring-brand-500/10 focus:border-brand-600 outline-none italic tabular-nums" />
                    </div>

                    <div class="flex flex-col gap-3">
                        <button @click="closeShift" class="h-16 bg-red-600 text-white rounded-2xl font-black text-sm uppercase tracking-widest hover:bg-red-700 shadow-lg transition-all active:scale-95 flex items-center justify-center gap-2">
                             KONFIRMASI PENUTUPAN
                        </button>
                        <button @click="showCloseShiftModal = false" class="h-12 font-black text-slate-400 hover:text-slate-600 uppercase text-[10px] tracking-widest transition-colors">
                            KEMBALI KE TERMINAL
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- PENDING TRANSACTIONS LIST -->
        <div v-if="showPendingList" class="fixed inset-0 z-[100] bg-surface-900/40 backdrop-blur-sm flex justify-end">
            <div class="bg-white dark:bg-dark-surface w-full max-w-md h-full flex flex-col shadow-2xl animate-in slide-in-from-right duration-300 border-l border-dark-border">
                <div class="h-20 px-8 border-b border-surface-100 dark:border-dark-border flex items-center justify-between">
                    <h2 class="text-xl font-black tracking-tight uppercase font-serif italic text-slate-900 dark:text-zinc-100">Transaksi Terparkir</h2>
                    <button @click="showPendingList = false" class="w-10 h-10 rounded-xl bg-surface-50 dark:bg-dark-bg flex items-center justify-center text-slate-400 hover:text-slate-900 dark:hover:text-zinc-100 transition-colors">
                        <X :size="20" stroke-width="3" />
                    </button>
                </div>
                <div class="flex-1 overflow-auto p-8 space-y-4 custom-scrollbar">
                    <div v-if="pendingTransactions.length === 0" class="flex flex-col items-center justify-center h-40 opacity-20">
                         <ClipboardList :size="48" stroke-width="1.5" />
                         <span class="text-sm font-black uppercase mt-4">Queue Empty</span>
                    </div>
                    <div v-for="pt in pendingTransactions" :key="pt.id" @click="recallSale(pt.id)" class="p-5 rounded-2xl bg-white dark:bg-zinc-900 border border-surface-100 dark:border-dark-border hover:border-brand-500 dark:hover:border-brand-800 transition-all cursor-pointer group shadow-sm hover:shadow-md">
                        <div class="flex justify-between items-start mb-2">
                            <span class="text-[10px] font-black text-surface-400 uppercase tracking-widest">ID #{{ pt.id }}</span>
                            <span class="text-lg font-black text-brand-600 italic tabular-nums">{{ formatCurrency(pt.total) }}</span>
                        </div>
                        <div class="flex items-center gap-3 text-xs text-slate-500">
                             <div class="flex items-center gap-1 font-bold">
                                <Package :size="12" /> {{ pt.cart_data.length }} Items
                             </div>
                             <div class="w-1 h-1 rounded-full bg-surface-200"></div>
                             <div class="flex items-center gap-1">
                                <Clock :size="12" /> {{ new Date(pt.created_at).toLocaleTimeString() }}
                             </div>
                        </div>
                        <div class="mt-4 pt-4 border-t border-surface-50 dark:border-dark-border flex items-center justify-between">
                             <span class="text-[9px] font-black text-brand-500 uppercase tracking-widest opacity-0 group-hover:opacity-100 transition-opacity">Recall Transaction →</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- PRICE CHECKER (KIOSK) OVERLAY -->
        <div v-if="isPriceChecker" class="fixed inset-0 z-[150] bg-zinc-950 flex flex-col items-center justify-center p-12 text-center text-white">
            <button @click="togglePriceChecker" class="absolute top-10 right-10 w-16 h-16 bg-zinc-800 rounded-full flex items-center justify-center hover:bg-zinc-700 transition-colors">
                <X :size="32" />
            </button>
            <div class="mb-12 animate-pulse">
                <Scan :size="120" stroke-width="1" class="text-brand-500 mx-auto mb-6" />
                <h1 class="text-5xl font-black tracking-tightest">SILAKAN SCAN BARCODE</h1>
                <p class="text-2xl text-zinc-500 mt-4">Untuk mengetahui informasi harga dan promo terbaru</p>
            </div>

            <!-- Result Display -->
            <div v-if="lastScannedProduct" class="bg-zinc-900 border-2 border-brand-500/50 rounded-[48px] p-16 w-full max-w-4xl animate-in zoom-in duration-300">
                <div class="flex items-center gap-16 text-left">
                    <img v-if="lastScannedProduct.image" :src="lastScannedProduct.image" class="w-64 h-64 object-cover rounded-3xl bg-white" />
                    <div v-else class="w-64 h-64 bg-zinc-800 rounded-3xl flex items-center justify-center text-zinc-600">
                        <Package :size="80" />
                    </div>
                    <div class="flex-1 space-y-6">
                        <h2 class="text-6xl font-black leading-tight">{{ lastScannedProduct.name }}</h2>
                        <div class="flex items-baseline gap-4">
                            <span class="text-8xl font-black text-brand-500">{{ formatCurrency(lastScannedProduct.price).replace('Rp', '').trim() }}</span>
                            <span class="text-4xl font-bold text-zinc-600">Rp</span>
                        </div>
                        <div class="flex items-center gap-4">
                            <span class="px-6 py-2 bg-brand-500 text-white rounded-full text-2xl font-bold uppercase">{{ lastScannedProduct.category?.name || 'UMUM' }}</span>
                            <span v-if="lastScannedProduct.stock > 0" class="text-green-500 text-2xl font-bold">STOK TERSEDIA</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Transparent hidden input for barcode -->
            <input 
                ref="barcodeInput"
                v-model="store.searchQuery"
                @keydown.enter="handleSearch"
                class="opacity-0 absolute inset-0 cursor-default"
                autofocus
            />
        </div>
    </div>
</template>

<style scoped>
/* Custom Scrollbar for Table */
::-webkit-scrollbar {
    width: 6px;
    height: 6px;
}
::-webkit-scrollbar-track {
    background: transparent; 
}
::-webkit-scrollbar-thumb {
    background-color: var(--color-surface-200);
    border-radius: 9999px;
}
.dark ::-webkit-scrollbar-thumb {
    background-color: var(--color-dark-border);
}
::-webkit-scrollbar-thumb:hover {
    background-color: var(--color-surface-300);
}
.dark ::-webkit-scrollbar-thumb:hover {
    background-color: var(--color-surface-800);
}
</style>
