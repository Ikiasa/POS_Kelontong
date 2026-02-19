<script setup>
import { ref, computed, watch, onMounted, onUnmounted } from 'vue';
import { 
    X, Banknote, QrCode, Split, Loader2
} from 'lucide-vue-next';
import axios from 'axios';

const props = defineProps({
    show: Boolean,
    subtotal: Number,
    tax: Number,
    total: Number,
    discount: Number,
    items: Array,
    customer: Object
});

const emit = defineEmits(['close', 'success']);

const paymentMethod = ref('cash');
const cashReceived = ref('');
const splitPayments = ref([]);
const isProcessing = ref(false);
const qrisPayload = ref('');
const qrisStatus = ref('pending'); // pending, scanning, verified

const formatCurrency = (val) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', minimumFractionDigits: 0 }).format(val);

const change = computed(() => {
    if (paymentMethod.value === 'split') return 0;
    const received = parseFloat(cashReceived.value) || 0;
    return Math.max(0, received - props.total);
});

const remainingBalance = computed(() => {
    if (paymentMethod.value !== 'split') return 0;
    const paid = splitPayments.value.reduce((sum, p) => sum + parseFloat(p.amount || 0), 0);
    return Math.max(0, props.total - paid);
});

const setPaymentMethod = (method) => {
    paymentMethod.value = method;
    if (method === 'qris') {
        generateQRIS();
    } else if (method === 'split') {
        splitPayments.value = [];
    }
};

const generateQRIS = () => {
    const amountStr = String(Math.floor(props.total)).padStart(12, '0');
    qrisPayload.value = `00020101021226300016ID.CO.QRIS.WWW011893600523000000010215${amountStr}5802ID5911KelontongKu6005Depok62070703A016304` + Math.random().toString(36).substring(7).toUpperCase();
};

const addSplitPayment = (method, amount) => {
    if (!amount || amount <= 0) return;
    splitPayments.value.push({
        method: method,
        amount: parseFloat(amount),
        reference: ''
    });
    cashReceived.value = '';
};

const removeSplitPayment = (index) => {
    splitPayments.value.splice(index, 1);
};

const processPayment = async () => {
    if (isProcessing.value) return;

    // Validation
    if (paymentMethod.value === 'split' && remainingBalance.value > 0) {
        alert('Still have balance remaining');
        return;
    }
    if (paymentMethod.value === 'cash' && change.value < 0 && parseFloat(cashReceived.value) < props.total) {
        alert('Insufficient cash');
        return;
    }

    isProcessing.value = true;

    const paymentItems = paymentMethod.value === 'split'
        ? splitPayments.value
        : [{
            method: paymentMethod.value,
            amount: props.total,
            reference: null
        }];

    const payload = {
        items: props.items,
        customer_id: props.customer?.id,
        payment: {
            method: paymentMethod.value,
            cashReceived: paymentMethod.value === 'cash' ? parseFloat(cashReceived.value) : null,
            change: change.value,
            items: paymentItems
        },
        totals: {
            subtotal: props.subtotal,
            tax: props.tax,
            discount: props.discount,
            grandTotal: props.total
        }
    };

    try {
        const response = await axios.post('/sales', payload);
        if (response.data.success) {
            emit('success', response.data);
            emit('close');
        } else {
            alert(response.data.message || 'Transaction failed');
        }
    } catch (error) {
        console.error(error);
        alert(error.response?.data?.message || 'Transaction failed');
    } finally {
        isProcessing.value = false;
    }
};

const handleKeyDown = (e) => {
    if (e.key === 'Escape') emit('close');
    if (e.key === 'Enter' && props.show) processPayment();
};

onMounted(() => window.addEventListener('keydown', handleKeyDown));
onUnmounted(() => window.removeEventListener('keydown', handleKeyDown));
</script>

<template>
    <div v-if="show" class="fixed inset-0 z-[100] flex items-center justify-center p-4 sm:p-6">
        <!-- Backdrop -->
        <div class="absolute inset-0 bg-zinc-950/60 backdrop-blur-sm transition-opacity" @click="emit('close')"></div>

        <!-- Modal -->
        <div class="relative w-full max-w-2xl bg-white dark:bg-zinc-950 rounded-[2rem] border border-zinc-200 dark:border-zinc-800 shadow-2xl overflow-hidden flex flex-col max-h-[90vh] animate-in zoom-in-95 duration-200">
            <!-- Header -->
            <div class="px-8 py-6 border-b border-zinc-100 dark:border-zinc-900 flex items-center justify-between">
                <div>
                    <h2 class="text-xl font-black text-zinc-900 dark:text-white uppercase tracking-tight">Complete Transaction</h2>
                    <p class="text-xs text-zinc-500">Select payment method and confirm</p>
                </div>
                <button @click="emit('close')" class="p-2 hover:bg-zinc-100 dark:hover:bg-zinc-900 rounded-xl transition-colors">
                    <X :size="20" class="text-zinc-400" />
                </button>
            </div>

            <div class="flex-1 overflow-y-auto p-8 lg:p-10 space-y-8">
                <!-- Summary Card -->
                <div class="bg-red-600 rounded-3xl p-6 text-white shadow-xl shadow-red-600/20 relative overflow-hidden group">
                    <div class="relative z-10 flex justify-between items-end">
                        <div class="space-y-1">
                            <span class="text-[10px] font-black uppercase tracking-[0.2em] opacity-80">Final Payable Amount</span>
                            <div class="text-4xl font-black tabular-nums">{{ formatCurrency(total) }}</div>
                        </div>
                        <div class="text-right">
                             <div class="text-[10px] opacity-60 font-medium">Items: {{ items.length }}</div>
                        </div>
                    </div>
                    <div class="absolute -right-4 -bottom-4 opacity-10 group-hover:scale-110 transition-transform duration-700">
                        <Banknote :size="120" />
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-10">
                    <!-- Methods -->
                    <div class="space-y-4">
                        <h3 class="text-xs font-black uppercase tracking-widest text-zinc-400 mb-4">Payment Method</h3>
                        
                        <div class="grid grid-cols-1 gap-3">
                            <button @click="setPaymentMethod('cash')" 
                                    :class="['flex items-center gap-4 p-4 rounded-2xl border transition-all text-left', 
                                             paymentMethod === 'cash' ? 'bg-red-50 dark:bg-red-900/10 border-red-600 dark:border-red-400 ring-1 ring-red-600 dark:ring-red-400' : 'bg-white dark:bg-zinc-900 border-zinc-200 dark:border-zinc-800 hover:border-zinc-400']">
                                <div class="p-2 bg-white dark:bg-zinc-800 rounded-lg shadow-sm border border-zinc-100 dark:border-zinc-700">
                                    <Banknote :size="20" class="text-emerald-500" />
                                </div>
                                <div>
                                    <div class="text-sm font-bold text-zinc-900 dark:text-white">Cash Payment</div>
                                    <div class="text-[10px] text-zinc-500 uppercase tracking-tighter">Physical currency</div>
                                </div>
                            </button>

                            <button @click="setPaymentMethod('qris')" 
                                    :class="['flex items-center gap-4 p-4 rounded-2xl border transition-all text-left', 
                                             paymentMethod === 'qris' ? 'bg-red-50 dark:bg-red-900/10 border-red-600 dark:border-red-400 ring-1 ring-red-600 dark:ring-red-400' : 'bg-white dark:bg-zinc-900 border-zinc-200 dark:border-zinc-800 hover:border-zinc-400']">
                                <div class="p-2 bg-white dark:bg-zinc-800 rounded-lg shadow-sm border border-zinc-100 dark:border-zinc-700">
                                    <QrCode :size="20" class="text-red-600 dark:text-red-400" />
                                </div>
                                <div>
                                    <div class="text-sm font-bold text-zinc-900 dark:text-white">QRIS Integrated</div>
                                    <div class="text-[10px] text-zinc-500 uppercase tracking-tighter">Dynamic digital gateway</div>
                                </div>
                            </button>

                            <button @click="setPaymentMethod('split')" 
                                    :class="['flex items-center gap-4 p-4 rounded-2xl border transition-all text-left', 
                                             paymentMethod === 'split' ? 'bg-red-50 dark:bg-red-900/10 border-red-600 dark:border-red-400 ring-1 ring-red-600 dark:ring-red-400' : 'bg-white dark:bg-zinc-900 border-zinc-200 dark:border-zinc-800 hover:border-zinc-400']">
                                <div class="p-2 bg-white dark:bg-zinc-800 rounded-lg shadow-sm border border-zinc-100 dark:border-zinc-700">
                                    <Split :size="20" class="text-amber-500" />
                                </div>
                                <div>
                                    <div class="text-sm font-bold text-zinc-900 dark:text-white">Split / Combined</div>
                                    <div class="text-[10px] text-zinc-500 uppercase tracking-tighter">Multi-method settlement</div>
                                </div>
                            </button>
                        </div>
                    </div>

                    <!-- Details Area -->
                    <div class="space-y-6">
                        <!-- Cash View -->
                        <div v-if="paymentMethod === 'cash'" class="space-y-6 animate-in slide-in-from-right-4 duration-300">
                            <div>
                                <label class="block text-xs font-black uppercase tracking-widest text-zinc-400 mb-2">Cash Received</label>
                                <div class="relative group">
                                    <span class="absolute left-4 top-1/2 -translate-y-1/2 text-zinc-400 font-bold text-lg group-focus-within:text-red-600 transition-colors">Rp</span>
                                    <input type="number" v-model="cashReceived" id="cash-input"
                                           class="w-full bg-zinc-50 dark:bg-zinc-900/50 border-2 border-zinc-100 dark:border-zinc-800 p-4 pl-12 rounded-2xl text-2xl font-black tabular-nums focus:ring-0 focus:border-red-500 transition-all"
                                           placeholder="0">
                                </div>
                            </div>

                            <div class="p-6 bg-zinc-50 dark:bg-zinc-900/50 rounded-2xl border border-dashed border-zinc-200 dark:border-zinc-800 flex justify-between items-center">
                                <div class="text-xs font-bold text-zinc-500 uppercase tracking-widest">Change Due</div>
                                <div :class="['text-2xl font-black tabular-nums', change > 0 ? 'text-emerald-500' : 'text-zinc-300 dark:text-zinc-700']">
                                    {{ formatCurrency(change) }}
                                </div>
                            </div>

                            <div class="grid grid-cols-2 gap-2">
                                <button @click="cashReceived = total" class="py-2 bg-zinc-100 dark:bg-zinc-900 rounded-xl text-[10px] font-black uppercase tracking-widest hover:bg-zinc-200 dark:hover:bg-zinc-800 transition-all">Exact Amount</button>
                                <button @click="cashReceived = Math.ceil(total/100000)*100000" class="py-2 bg-zinc-100 dark:bg-zinc-900 rounded-xl text-[10px] font-black uppercase tracking-widest hover:bg-zinc-200 dark:hover:bg-zinc-800 transition-all">Next 100k</button>
                            </div>
                        </div>

                        <!-- QRIS View -->
                        <div v-if="paymentMethod === 'qris'" class="space-y-6 animate-in slide-in-from-right-4 duration-300 flex flex-col items-center">
                             <div v-if="qrisStatus === 'verified'" class="flex flex-col items-center justify-center p-8 bg-emerald-50 dark:bg-emerald-900/10 rounded-[2rem] border-4 border-emerald-500 w-full animate-in zoom-in-95">
                                 <div class="w-20 h-20 bg-emerald-500 rounded-full flex items-center justify-center text-white mb-4 shadow-lg shadow-emerald-500/40">
                                     <QrCode :size="40" />
                                 </div>
                                 <h4 class="text-xl font-black text-emerald-600 dark:text-emerald-400 uppercase tracking-tighter">Payment Verified</h4>
                                 <p class="text-xs text-emerald-600/70 font-bold">Funds received successfully</p>
                             </div>
                             
                             <template v-else>
                                 <div class="bg-white p-4 rounded-[2rem] shadow-2xl shadow-red-500/10 border-4 border-red-50 dark:border-zinc-800 relative group">
                                     <img :src="'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=' + encodeURIComponent(qrisPayload)" 
                                          class="w-48 h-48 lg:w-56 lg:h-56" />
                                     <div v-if="qrisStatus === 'scanning'" class="absolute inset-0 bg-white/80 dark:bg-zinc-950/80 backdrop-blur-[2px] rounded-[1.8rem] flex items-center justify-center">
                                         <Loader2 class="animate-spin text-red-600" :size="32" />
                                     </div>
                                 </div>
                                 <div class="text-center space-y-4">
                                    <div class="flex items-center justify-center gap-2 text-red-600 dark:text-red-400 font-black uppercase text-[10px] tracking-widest">
                                        <div class="w-2 h-2 rounded-full bg-red-600 animate-pulse"></div>
                                        {{ qrisStatus === 'scanning' ? 'Verifying Transaction...' : 'Awaiting Settlement' }}
                                    </div>
                                    <button @click="qrisStatus = 'scanning'; setTimeout(() => { qrisStatus = 'verified' }, 2000)" 
                                            class="px-4 py-2 bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 rounded-lg text-[10px] font-black uppercase tracking-widest border border-red-100 dark:border-red-500/20 hover:bg-red-100 transition-all">
                                        Simulate Scan Success
                                    </button>
                                 </div>
                             </template>
                        </div>

                        <!-- Split View -->
                        <div v-if="paymentMethod === 'split'" class="space-y-4 animate-in slide-in-from-right-4 duration-300">
                             <div class="bg-amber-50 dark:bg-amber-900/10 border border-amber-100 dark:border-amber-900/20 p-4 rounded-2xl">
                                <div class="flex justify-between items-center mb-1">
                                    <span class="text-[10px] font-black text-amber-700 dark:text-amber-400 uppercase tracking-widest">Remaining</span>
                                    <span class="text-lg font-black text-amber-800 dark:text-amber-300">{{ formatCurrency(remainingBalance) }}</span>
                                </div>
                                <div class="h-1.5 w-full bg-amber-100 dark:bg-zinc-800 rounded-full overflow-hidden">
                                     <div class="h-full bg-amber-500 transition-all duration-500" :style="{width: ((total - remainingBalance) / total * 100) + '%'}"></div>
                                </div>
                             </div>

                             <div class="space-y-2 max-h-[160px] overflow-y-auto pr-2 custom-scrollbar">
                                 <div v-for="(p, i) in splitPayments" :key="i" class="flex items-center justify-between p-3 bg-zinc-50 dark:bg-zinc-900 rounded-xl border border-zinc-100 dark:border-zinc-800 group">
                                     <div class="flex items-center gap-3">
                                         <span class="text-[10px] font-black uppercase text-zinc-400">{{ p.method }}</span>
                                         <span class="font-bold text-zinc-900 dark:text-white">{{ formatCurrency(p.amount) }}</span>
                                     </div>
                                     <button @click="removeSplitPayment(i)" class="p-1.5 text-zinc-400 hover:text-red-500 transition-colors">
                                         <X :size="14" />
                                     </button>
                                 </div>
                             </div>

                             <div v-if="remainingBalance > 0" class="pt-4 space-y-3">
                                 <div class="grid grid-cols-2 gap-2">
                                     <input type="number" v-model="cashReceived" class="p-3 bg-zinc-50 dark:bg-zinc-900 border-zinc-200 dark:border-zinc-800 rounded-xl text-sm font-bold" placeholder="Amount">
                                     <select class="p-3 bg-zinc-50 dark:bg-zinc-900 border-zinc-200 dark:border-zinc-800 rounded-xl text-sm font-bold focus:ring-0" 
                                             @change="addSplitPayment($event.target.value, cashReceived || remainingBalance); $event.target.value = '';">
                                         <option value="">+ Method</option>
                                         <option value="cash">Cash</option>
                                         <option value="gopay">GoPay</option>
                                         <option value="qris">QRIS</option>
                                         <option value="transfer">Transfer</option>
                                     </select>
                                 </div>
                             </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Footer -->
            <div class="px-8 py-6 border-t border-zinc-100 dark:border-zinc-900 flex justify-between gap-4">
                <button @click="emit('close')" class="px-6 py-3 text-sm font-black uppercase tracking-widest text-zinc-500 hover:text-zinc-900 dark:hover:text-white transition-colors">Abort</button>
                <button @click="processPayment" 
                        :disabled="isProcessing || (paymentMethod === 'cash' && change < 0 && parseFloat(cashReceived) < total) || (paymentMethod === 'split' && remainingBalance > 0)"
                        class="px-10 py-4 bg-zinc-900 dark:bg-white text-white dark:text-zinc-900 rounded-2xl font-black uppercase tracking-[0.2em] text-xs shadow-xl transition-all hover:scale-[1.02] active:scale-[0.98] disabled:opacity-50 flex items-center gap-3">
                    <Loader2 v-if="isProcessing" class="animate-spin" :size="16" />
                    {{ isProcessing ? 'Processing' : 'Confirm & Print' }}
                </button>
            </div>
        </div>
    </div>
</template>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
  width: 4px;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: #E4E4E7;
  border-radius: 10px;
}
.dark .custom-scrollbar::-webkit-scrollbar-thumb {
  background: #27272A;
}
</style>
