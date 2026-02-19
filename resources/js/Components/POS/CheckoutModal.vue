<script setup>
import { ref, computed, watch, onUnmounted } from 'vue';
import { usePosStore } from '@/Stores/posStore';
import { printReceipt } from '@/Utils/thermalPrinter';
import { 
    X, 
    Printer, 
    CheckCircle, 
    Loader2, 
    Info, 
    WifiOff,
    CreditCard,
    DollarSign,
    QrCode,
    Plus,
    Trash2,
    Check
} from 'lucide-vue-next';
import axios from 'axios';
import { offlineSync } from '@/Services/OfflineSyncService';

const props = defineProps({
    show: Boolean
});

const emit = defineEmits(['close', 'completed']);

const store = usePosStore();
const isProcessing = ref(false);
const showSuccess = ref(false);
const lastTransaction = ref(null);

// Checkout State
const payments = ref([
    { method: 'CASH', amount: 0, reference: '' }
]);

const addPaymentLine = (method = 'CASH') => {
    const remaining = store.total - totalPaid.value;
    if (remaining > 0) {
        payments.value.push({ method, amount: remaining, reference: '' });
    }
};

const removePaymentLine = (index) => {
    if (payments.value.length > 1) {
        payments.value.splice(index, 1);
    } else {
        payments.value[0].amount = 0;
    }
};

const totalPaid = computed(() => {
    return payments.value.reduce((acc, p) => acc + (parseFloat(p.amount) || 0), 0);
});

const changeAmount = computed(() => {
    return Math.max(0, totalPaid.value - store.total);
});

const canCheckout = computed(() => {
    return totalPaid.value >= store.total && store.cart.length > 0 && !isProcessing.value;
});

// QRIS Sub-state
const qrisStatus = ref('idle'); // idle | generating | waiting | paid
let qrisPollingInterval = null;

const initQrisLine = () => {
    qrisStatus.value = 'generating';
    setTimeout(() => {
        qrisStatus.value = 'waiting';
        startQrisPolling();
    }, 1000);
};

const startQrisPolling = () => {
    let checks = 0;
    if (qrisPollingInterval) clearInterval(qrisPollingInterval);
    qrisPollingInterval = setInterval(() => {
        checks++;
        if (checks >= 4) {
             finalizeQris();
        }
    }, 1000);
};

const finalizeQris = () => {
    if (qrisPollingInterval) clearInterval(qrisPollingInterval);
    qrisStatus.value = 'paid';
};

// Reset state when opening
watch(() => props.show, (newVal) => {
    if (newVal) {
        payments.value = [{ method: 'CASH', amount: store.total, reference: '' }];
        showSuccess.value = false;
        qrisStatus.value = 'idle';
    }
});

onUnmounted(() => {
    if (qrisPollingInterval) clearInterval(qrisPollingInterval);
});

const processCheckout = async () => {
    if (!canCheckout.value) return;
    
    isProcessing.value = true;
    const now = new Date().toISOString();

    const payload = {
        customer_id: store.customer ? store.customer.id : null,
        items: store.cart.map(item => ({
            id: item.id,
            name: item.name,
            price: item.price,
            quantity: item.qty
        })),
        totals: {
            subtotal: store.subtotal,
            tax: 0,
            discount: 0,
            grandTotal: store.total
        },
        payment: {
            method: payments.value.length > 1 ? 'split' : payments.value[0].method,
            items: payments.value.map(p => ({
                method: p.method,
                amount: p.amount,
                reference: p.reference
            }))
        },
        timestamp: now
    };

    try {
        if (!navigator.onLine) {
            const localId = await offlineSync.saveTransactionLocally(payload);
            lastTransaction.value = { 
                ...payload, 
                invoice_number: `OFF-${Date.now().toString().slice(-6)}`,
                change_amount: changeAmount.value,
                is_offline: true 
            };
        } else {
            const response = await axios.post(route('pos.store'), payload);
            lastTransaction.value = {
                ...payload,
                invoice_number: response.data.invoice_number,
                transaction_id: response.data.transaction_id,
                change_amount: changeAmount.value
            };
        }

        showSuccess.value = true;
        store.clearCart();
        printReceipt(lastTransaction.value);
    } catch (error) {
        alert(error.response?.data?.message || 'Transaction failed. Check connection.');
    } finally {
        isProcessing.value = false;
    }
};

const formatCurrency = (value) => {
    return new Intl.NumberFormat('id-ID', {
        style: 'currency', currency: 'IDR', minimumFractionDigits: 0
    }).format(value);
};

const close = () => {
    showSuccess.value = false;
    emit('close');
};
</script>

<template>
    <div v-if="show" class="fixed inset-0 z-[100] flex items-center justify-center p-4 bg-slate-900/40 backdrop-blur-md animate-in fade-in duration-300">
        
        <!-- MAIN CHECKOUT CONSOLE -->
        <div v-if="!showSuccess" class="bg-white dark:bg-dark-surface w-full max-w-4xl rounded-[32px] shadow-premium overflow-hidden flex flex-col max-h-[90vh] animate-in zoom-in-95 duration-300">
            
            <!-- Header Section -->
            <div class="px-10 py-8 border-b border-surface-100 dark:border-dark-border flex items-center justify-between shrink-0 bg-surface-50/50 dark:bg-dark-bg/50">
                <div class="flex items-center gap-4">
                    <div class="w-12 h-12 rounded-2xl bg-brand-600 text-white flex items-center justify-center shadow-lg">
                        <CreditCard :size="24" stroke-width="2.5" />
                    </div>
                    <div>
                        <h3 class="text-2xl font-black text-slate-900 dark:text-zinc-100 tracking-tight">Checkout Terminal</h3>
                        <p class="text-xs font-bold text-slate-400 uppercase tracking-widest mt-1">Multi-Payment Consolidation</p>
                    </div>
                </div>
                <button @click="close" class="w-12 h-12 flex items-center justify-center hover:bg-slate-100 dark:hover:bg-zinc-800 rounded-2xl transition-all">
                    <X :size="24" class="text-slate-400" stroke-width="3" />
                </button>
            </div>

            <div class="flex-1 overflow-hidden flex">
                <!-- Left Panel: Summary & Split Payments -->
                <div class="flex-1 p-10 overflow-y-auto space-y-10 custom-scrollbar border-r border-surface-100 dark:border-dark-border">
                    
                    <!-- TOTAL HERO -->
                    <div class="p-8 bg-brand-50 dark:bg-brand-900/10 rounded-[28px] border border-brand-100 dark:border-brand-900/30 text-center relative overflow-hidden">
                        <div class="relative z-10">
                            <span class="text-[10px] font-black text-brand-600 uppercase tracking-[0.3em]">Consolidated Amount Due</span>
                            <h2 class="text-6xl font-black text-brand-600 dark:text-brand-400 tracking-tighter mt-2 tabular-nums italic">
                                {{ formatCurrency(store.total) }}
                            </h2>
                        </div>
                        <CreditCard :size="120" class="absolute -right-8 -bottom-8 text-brand-600/5 rotate-12" />
                    </div>

                    <!-- PAYMENT SPLITS -->
                    <div class="space-y-4">
                        <div class="flex items-center justify-between mb-4">
                            <h4 class="text-xs font-black text-slate-400 uppercase tracking-[0.2em]">Payment Breakdown</h4>
                            <button @click="addPaymentLine()" class="flex items-center gap-2 text-[10px] font-black text-brand-600 hover:text-brand-700 uppercase tracking-widest">
                                <Plus :size="14" /> ADD SPLIT
                            </button>
                        </div>
                        
                        <div v-for="(p, index) in payments" :key="index" class="p-6 bg-white dark:bg-dark-surface rounded-3xl border border-surface-200 dark:border-dark-border shadow-sm flex flex-col gap-6 animate-in slide-in-from-left-4 duration-300">
                            <!-- Method Selection (Full-Width Primary Grid) -->
                            <div class="w-full grid grid-cols-5 gap-1.5 bg-surface-50 dark:bg-dark-bg p-1.5 rounded-2xl border border-surface-200 dark:border-dark-border shadow-inner">
                                <button v-for="method in ['CASH', 'QRIS', 'DEBIT', 'CREDIT', 'VOUCHER']" 
                                        :key="method"
                                        @click="p.method = method"
                                        class="py-3 text-[10px] font-black rounded-xl transition-all uppercase tracking-tight border-2"
                                        :class="p.method === method ? 'bg-brand-600 text-white border-brand-500 shadow-md scale-[1.02]' : 'text-slate-400 border-transparent hover:bg-surface-100 dark:hover:bg-dark-surface'">
                                    {{ method }}
                                </button>
                            </div>
                            
                            <div class="flex items-center gap-4">
                                <!-- Amount Input (Wider) -->
                                <div class="flex-[2] relative">
                                    <input v-model.number="p.amount" type="number" 
                                           class="w-full pl-12 pr-4 py-4 bg-surface-50 dark:bg-dark-bg border-none rounded-2xl text-xl font-black tracking-tight focus:ring-2 focus:ring-brand-500 transition-all tabular-nums shadow-sm" />
                                    <div class="absolute left-4 top-1/2 -translate-y-1/2 text-xs font-black text-slate-400">Rp</div>
                                </div>

                                <!-- Reference / Card Number -->
                                <div class="flex-1 relative">
                                    <input v-model="p.reference" type="text" placeholder="REF #" 
                                           class="w-full px-5 py-4 bg-surface-50 dark:bg-dark-bg border-none rounded-2xl text-xs font-bold focus:ring-2 focus:ring-brand-500 transition-all uppercase shadow-sm" />
                                </div>

                                <!-- Inline Actions -->
                                <div class="flex items-center gap-2">
                                    <button v-if="p.method === 'QRIS' && qrisStatus === 'idle'" @click="initQrisLine" class="p-4 bg-brand-50 text-brand-600 rounded-2xl hover:bg-brand-100 transition-all border border-brand-100">
                                        <QrCode :size="20" />
                                    </button>
                                    <button @click="removePaymentLine(index)" class="p-4 text-red-300 hover:text-red-500 hover:bg-red-50 rounded-2xl transition-all border border-red-50/0 hover:border-red-100">
                                        <Trash2 :size="20" />
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Panel: Controls & Actions -->
                <div class="w-[380px] p-10 bg-surface-50 dark:bg-dark-bg/20 flex flex-col space-y-8 shrink-0">
                    
                    <!-- Balance Summary Card -->
                    <div class="space-y-3">
                         <div class="flex justify-between items-center text-xs font-bold text-slate-500 uppercase tracking-widest">
                            <span>Balance Due</span>
                            <span :class="totalPaid >= store.total ? 'text-emerald-500' : 'text-red-500'">
                                {{ formatCurrency(Math.max(0, store.total - totalPaid)) }}
                            </span>
                        </div>
                        <div class="h-2 bg-slate-200 dark:bg-dark-border rounded-full overflow-hidden">
                            <div class="h-full bg-brand-600 transition-all duration-500" 
                                 :style="{ width: Math.min(100, (totalPaid / store.total) * 100) + '%' }"></div>
                        </div>
                        <div class="flex justify-between items-center text-xs font-bold text-slate-500 uppercase tracking-widest">
                            <span>Kembalian</span>
                            <span class="text-slate-900 dark:text-zinc-200">{{ formatCurrency(changeAmount) }}</span>
                        </div>
                    </div>

                    <!-- QRIS Interaction Zone -->
                    <div v-if="qrisStatus !== 'idle'" class="p-6 bg-white dark:bg-dark-surface rounded-3xl shadow-soft border border-brand-100 dark:border-brand-900/30 flex flex-col items-center gap-4 text-center animate-in zoom-in-95">
                        <div class="w-40 h-40 bg-white p-2 rounded-2xl border border-slate-200 shadow-sm relative overflow-hidden">
                             <div v-if="qrisStatus === 'generating'" class="absolute inset-0 flex flex-col items-center justify-center bg-white z-10">
                                <Loader2 :size="24" class="animate-spin text-brand-600 mb-2" />
                                <span class="text-[9px] font-black uppercase text-brand-600">Generating QR...</span>
                            </div>
                             <div v-if="qrisStatus === 'paid'" class="absolute inset-0 flex flex-col items-center justify-center bg-emerald-500 z-10 text-white">
                                <Check :size="48" stroke-width="4" />
                                <span class="text-[9px] font-black uppercase mt-2">Verified</span>
                            </div>
                            <img :src="`https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=POS-${store.total}`" class="w-full h-full mix-blend-multiply opacity-90" />
                        </div>
                        <div>
                             <h5 class="text-sm font-black text-slate-800 dark:text-zinc-200 tracking-tight">QRIS Network Ready</h5>
                             <p class="text-[10px] text-slate-400 mt-1 uppercase font-bold">Awaiting Transaction Settlement</p>
                        </div>
                    </div>

                    <div class="flex-1"></div>

                    <!-- BIG BAYAR BUTTON -->
                    <button 
                        @click="processCheckout"
                        :disabled="!canCheckout || isProcessing"
                        class="w-full py-8 rounded-[28px] bg-brand-600 hover:bg-brand-700 disabled:bg-slate-200 dark:disabled:bg-dark-surface text-white flex flex-col items-center justify-center gap-2 shadow-premium hover:shadow-lg transition-all active:scale-95 group"
                    >
                         <div v-if="isProcessing" class="flex items-center gap-3">
                            <Loader2 :size="32" class="animate-spin" />
                            <span class="text-xl font-black italic tracking-tighter uppercase font-serif">Consolidating...</span>
                         </div>
                         <template v-else>
                            <span class="text-4xl font-black tracking-tighter uppercase italic leading-none font-serif">BAYAR</span>
                            <span class="text-[10px] font-black opacity-60 uppercase tracking-[0.3em]">Commit Financial Data</span>
                         </template>
                    </button>
                    
                    <p class="text-[10px] text-center text-slate-400 font-bold uppercase tracking-widest italic flex items-center justify-center gap-2">
                        <span class="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span>
                        Encrypted Node: Terminal_01
                    </p>
                </div>
            </div>
        </div>

        <!-- SUCCESS & RECEIPT CONSOLE -->
        <div v-else class="bg-white dark:bg-dark-surface w-full max-w-lg rounded-[48px] shadow-premium overflow-hidden animate-in zoom-in duration-500">
            <div class="p-12 text-center space-y-8">
                <div class="w-32 h-32 bg-emerald-50 dark:bg-emerald-900/20 rounded-[40px] flex items-center justify-center mx-auto text-emerald-500 shadow-inner">
                    <CheckCircle :size="64" stroke-width="2.5" />
                </div>
                
                <div class="space-y-2">
                    <h3 class="text-4xl font-black text-slate-900 dark:text-zinc-100 tracking-tighter italic font-serif uppercase">Verified Done.</h3>
                    <p class="text-sm font-bold text-slate-400 uppercase tracking-widest">Transaction Registered • #{{ lastTransaction?.invoice_number }}</p>
                    <div v-if="lastTransaction?.is_offline" class="mt-4 inline-flex items-center gap-2 bg-amber-50 text-amber-600 px-3 py-1.5 rounded-full text-[10px] font-black tracking-widest border border-amber-200">
                        <WifiOff :size="14" /> OFFLINE CACHE ACTIVE
                    </div>
                </div>
                
                <div class="grid grid-cols-2 gap-6">
                    <div class="p-6 bg-surface-50 dark:bg-dark-bg/50 rounded-3xl border border-surface-100 dark:border-dark-border text-left">
                        <span class="text-[9px] font-black text-slate-400 uppercase tracking-widest">Return Change</span>
                        <div class="text-2xl font-black text-slate-900 dark:text-zinc-100 mt-1 tabular-nums italic">{{ formatCurrency(lastTransaction?.change_amount || 0) }}</div>
                    </div>
                    <div class="p-6 bg-surface-50 dark:bg-dark-bg/50 rounded-3xl border border-surface-100 dark:border-dark-border text-left">
                        <span class="text-[9px] font-black text-slate-400 uppercase tracking-widest">Method</span>
                        <div class="text-2xl font-black text-brand-600 mt-1 uppercase italic">{{ lastTransaction?.payments?.[0]?.method || 'SETTLED' }}</div>
                    </div>
                </div>

                <div class="flex flex-col gap-4">
                    <button @click="printReceipt(lastTransaction)" class="w-full py-5 rounded-2xl bg-slate-900 dark:bg-zinc-800 text-white font-black uppercase tracking-widest shadow-lg flex items-center justify-center gap-3 transition-all hover:bg-black active:scale-95">
                        <Printer :size="20" /> RE-PRINT RECEIPT
                    </button>
                    <button @click="close" class="w-full py-5 rounded-2xl border-2 border-slate-200 dark:border-dark-border text-slate-600 dark:text-zinc-400 font-black uppercase tracking-widest transition-all hover:bg-slate-50 dark:hover:bg-zinc-800">
                        NEXT TRANSACTION 🚀
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>
