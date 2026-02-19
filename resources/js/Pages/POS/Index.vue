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
    } catch (e) { alert('Gagal parkir transaksi'); }
};

const recallSale = async (id) => {
    try {
        const res = await axios.get(route('pending.recall', id));
        store.clearCart();
        res.data.data.cart_data.forEach(item => store.addToCart(item, item.qty));
        showPendingList.value = false;
        // Optionally delete it from pending
        await axios.delete(route('pending.destroy', id));
    } catch (e) { alert('Gagal memanggil transaksi'); }
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
    { key: 'F3', label: 'PARK', action: parkSale },
    { key: 'F4', label: 'RECALL', action: () => showPendingList.value = true },
    { key: 'F7', label: 'KIOSK', action: togglePriceChecker },
    { key: 'F8', label: 'OUT', action: () => showCloseShiftModal.value = true },
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
                    <span class="opacity-75 text-[10px] uppercase tracking-wider text-zinc-400">Connection</span>
                    <div class="flex items-center gap-1.5 font-bold">
                        <Wifi v-if="!isOffline" :size="14" class="text-green-400" />
                        <WifiOff v-else :size="14" class="text-amber-500" />
                        <span :class="!isOffline ? 'text-white' : 'text-amber-500'">{{ !isOffline ? 'ONLINE' : 'OFFLINE' }}</span>
                    </div>
                </div>
                <div v-if="syncStatus === 'syncing'" class="flex items-center gap-2 bg-brand-600/20 px-3 py-1 rounded-full animate-pulse border border-brand-500/30">
                     <div class="w-1.5 h-1.5 bg-brand-400 rounded-full animate-ping"></div>
                     <span class="text-[10px] font-black uppercase tracking-widest text-brand-300">SYNCING DATA...</span>
                </div>
                <div class="flex flex-col items-center leading-none gap-0.5">
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
                            class="w-full h-14 pl-12 pr-4 bg-zinc-800 text-white text-lg font-semibold border-2 border-zinc-700 rounded-lg focus:ring-4 focus:ring-brand-900/50 focus:border-brand-600 focus:outline-none uppercase transition-all shadow-inner placeholder-zinc-600"
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

        <!-- SHIFT START OVERLAY -->
        <div v-if="showShiftModal" class="fixed inset-0 z-[100] bg-zinc-900 flex items-center justify-center p-4">
            <div class="bg-white rounded-[32px] w-full max-w-md p-10 shadow-2xl text-center space-y-6">
                <div class="w-20 h-20 bg-brand-100 text-brand-600 rounded-3xl flex items-center justify-center mx-auto mb-6">
                    <Monitor :size="40" stroke-width="2.5" />
                </div>
                <h2 class="text-3xl font-black text-zinc-900 tracking-tighter">Buka Shift Baru</h2>
                <p class="text-zinc-500">Masukkan saldo awal kasir (untuk kembalian) untuk memulai transaksi hari ini.</p>
                <div class="space-y-4">
                    <div class="text-left">
                        <label class="text-[10px] font-bold text-zinc-400 uppercase tracking-widest pl-1">Saldo Awal (Modal Tunai)</label>
                        <input v-model="openingBalance" type="number" class="w-full text-3xl font-bold p-4 border-2 border-zinc-100 rounded-2xl focus:border-brand-500 outline-none transition-all" />
                    </div>

                    <!-- Offline Open Toggle -->
                    <div v-if="isOffline" class="p-4 bg-amber-50 rounded-2xl border border-amber-200 text-left">
                        <div class="flex items-center justify-between mb-2">
                             <span class="text-xs font-bold text-amber-700">MODA LURIK (OFFLINE)</span>
                             <input type="checkbox" v-model="useOfflineOpen" class="w-5 h-5 accent-amber-600" />
                        </div>
                        <div v-if="useOfflineOpen">
                             <label class="text-[10px] font-bold text-amber-600 uppercase tracking-widest pl-1">Kode Validasi Kantor Pusat</label>
                             <input v-model="validationCode" type="text" class="w-full text-xl font-bold p-3 border-2 border-amber-200 rounded-xl focus:border-amber-500 outline-none uppercase" placeholder="ABCDEF" />
                             <p class="text-[10px] text-amber-700 mt-2">Hubungi admin untuk mendapatkan kode harian jika server terputus.</p>
                        </div>
                    </div>

                    <button @click="openShift" class="w-full py-5 bg-zinc-900 text-white rounded-2xl font-black text-lg hover:bg-black transition-all shadow-xl active:scale-95">MULAI KASIR 🚀</button>
                </div>
            </div>
        </div>

        <!-- CLOSE SHIFT MODAL -->
        <div v-if="showCloseShiftModal" class="fixed inset-0 z-[100] bg-black/80 backdrop-blur-sm flex items-center justify-center p-4">
            <div class="bg-white rounded-[32px] w-full max-w-md p-10 shadow-2xl">
                <h2 class="text-2xl font-black mb-6 tracking-tight">Tutup Shift & Setoran</h2>
                <div class="space-y-6">
                    <div class="p-4 bg-zinc-50 rounded-2xl border border-zinc-100">
                        <div class="flex justify-between text-sm mb-1 text-zinc-500">Total Transaksi (Sistem)</div>
                        <div class="text-xl font-bold text-zinc-900">{{ formatCurrency(store.subtotal) }}</div>
                    </div>
                    <div>
                        <label class="text-[10px] font-bold text-zinc-400 uppercase tracking-widest pl-1">Hitung Tunai di Laci</label>
                        <input v-model="cashRecorded" type="number" class="w-full text-2xl font-bold p-4 border-2 border-zinc-100 rounded-2xl focus:border-brand-500 outline-none" />
                    </div>
                    <div class="flex gap-4">
                        <button @click="showCloseShiftModal = false" class="flex-1 py-4 font-bold text-zinc-500">Batal</button>
                        <button @click="closeShift" class="flex-1 py-4 bg-danger text-white rounded-2xl font-black">TUTUP SHIFT</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- PENDING TRANSACTIONS LIST -->
        <div v-if="showPendingList" class="fixed inset-0 z-[100] bg-black/60 backdrop-blur-sm flex justify-end">
            <div class="bg-white w-full max-w-md h-full flex flex-col shadow-2xl animate-in slide-in-from-right duration-300">
                <div class="p-6 border-b border-gray-100 flex items-center justify-between">
                    <h2 class="text-xl font-black tracking-tight">Transaksi Terparkir</h2>
                    <button @click="showPendingList = false" class="text-gray-400 hover:text-black"><X :size="24" /></button>
                </div>
                <div class="flex-1 overflow-auto p-6 space-y-4">
                    <div v-if="pendingTransactions.length === 0" class="text-center py-20 text-gray-400 italic">Tidak ada transaksi terparkir</div>
                    <div v-for="pt in pendingTransactions" :key="pt.id" class="p-4 rounded-2xl border border-gray-100 hover:border-brand-300 transition-all cursor-pointer group" @click="recallSale(pt.id)">
                        <div class="flex justify-between font-bold text-sm mb-1">
                            <span>TRANS #{{ pt.id }}</span>
                            <span class="text-brand-600">{{ formatCurrency(pt.total) }}</span>
                        </div>
                        <div class="text-xs text-gray-500">{{ pt.cart_data.length }} items • {{ new Date(pt.created_at).toLocaleTimeString() }}</div>
                        <div class="mt-2 text-[10px] uppercase text-brand-600 font-bold opacity-0 group-hover:opacity-100 transition-opacity">RECALL TRANSACTION →</div>
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
