<script setup>
import { ref, computed, watch, onUnmounted } from 'vue';
import { usePosStore } from '@/Stores/posStore';
import { printReceipt } from '@/Utils/thermalPrinter';
import { X, Printer, CheckCircle, Loader2, Info } from 'lucide-vue-next';
import axios from 'axios';

const props = defineProps({
    show: Boolean
});

const emit = defineEmits(['close', 'completed']);

const store = usePosStore();
const cashReceived = ref('');
const isProcessing = ref(false);
const showSuccess = ref(false);
const lastTransaction = ref(null);

// Checkout State
const paymentMethod = ref('cash'); // 'cash' | 'qris'
const qrisStatus = ref('idle'); // 'idle' | 'generating' | 'waiting' | 'paid'
let qrisPollingInterval = null;

const changeAmount = computed(() => {
    const received = parseInt(cashReceived.value) || 0;
    return Math.max(0, received - store.total);
});

const canCheckout = computed(() => {
    if (paymentMethod.value === 'cash') {
       const received = parseInt(cashReceived.value) || 0;
       return received >= store.total && store.cart.length > 0;
    }
    // For QRIS, button is disabled until paid status, but we handle that in template
    return false;
});

// Watch show to reset
watch(() => props.show, (newVal) => {
    if (newVal) {
        paymentMethod.value = 'cash';
        cashReceived.value = '';
        qrisStatus.value = 'idle';
        clearInterval(qrisPollingInterval);
    }
});

const initQrisPayment = () => {
    paymentMethod.value = 'qris';
    qrisStatus.value = 'generating';
    
    // Simulate generation delay
    setTimeout(() => {
        qrisStatus.value = 'waiting';
        startQrisPolling();
    }, 800);
};

const startQrisPolling = () => {
    // Simulate checking backend every 1s
    // In real app: call API /api/payment/check/{transactionId}
    let checks = 0;
    if (qrisPollingInterval) clearInterval(qrisPollingInterval);

    qrisPollingInterval = setInterval(() => {
        checks++;
        // Simulate auto-success after 5 seconds
        if (checks >= 5) {
            forceSuccessQris();
        }
    }, 1000);
};

onUnmounted(() => {
    if (qrisPollingInterval) clearInterval(qrisPollingInterval);
});

const forceSuccessQris = () => {
    if (qrisPollingInterval) clearInterval(qrisPollingInterval);
    qrisStatus.value = 'paid';
    
    // Slight delay before finalizing wrapper
    setTimeout(() => {
        processCheckout();
    }, 500);
};

const processCheckout = async () => {
    // Validation for cash
    if (paymentMethod.value === 'cash' && (!canCheckout.value || isProcessing.value)) return;
    
    isProcessing.value = true;

    // Construct Payload for Backend
    const payload = {
        customer_id: store.customer ? store.customer.id : null,
        redeem_points: 0, // Pending Loyalty implementation
        items: store.cart.map(item => ({
            id: item.id,
            name: item.name,
            price: item.price,
            quantity: item.qty
        })),
        totals: {
            subtotal: store.subtotal,
            tax: store.taxAmount,
            discount: 0,
            grandTotal: store.total
        },
        payment: {
            method: paymentMethod.value.toUpperCase(),
            cashReceived: paymentMethod.value === 'cash' ? parseInt(cashReceived.value) : store.total,
            change: paymentMethod.value === 'cash' ? changeAmount.value : 0
        },
        timestamp: new Date().toISOString()
    };

    try {
        const response = await axios.post(route('pos.store'), payload);

        if (response.data.success) {
            // Success
            lastTransaction.value = {
                ...payload,
                invoice_number: response.data.invoice_number,
                id: response.data.transaction_id,
                created_at: new Date().toISOString(),
                change_amount: payload.payment.change // Frontend display helper
            };

            showSuccess.value = true;
            store.clearCart();
            
            // Auto print receipt
            handlePrint();
        } 
    } catch (error) {
        console.error('Transaction failed', error);
        
        // Handle specific error messages from backend (e.g., Stock Insufficient)
        const msg = error.response?.data?.message || 'Transaction failed. Please try again.';
        alert(msg);
    } finally {
        isProcessing.value = false;
        if (qrisPollingInterval) clearInterval(qrisPollingInterval);
    }
};

const handlePrint = () => {
    if (lastTransaction.value) {
        printReceipt(lastTransaction.value);
    }
};

const close = () => {
    showSuccess.value = false;
    cashReceived.value = '';
    paymentMethod.value = 'cash';
    lastTransaction.value = null;
    emit('close');
};

const formatCurrency = (value) => {
    return new Intl.NumberFormat('id-ID', {
        style: 'currency',
        currency: 'IDR',
        minimumFractionDigits: 0
    }).format(value);
};
</script>

<template>
    <div v-if="show" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm">
        
        <!-- Main Checkout Box -->
        <div v-if="!showSuccess" class="bg-white dark:bg-zinc-900 w-full max-w-md rounded-2xl shadow-xl overflow-hidden animate-in fade-in zoom-in duration-200 flex flex-col max-h-[90vh]">
            <div class="px-6 py-4 border-b border-gray-100 dark:border-zinc-800 flex items-center justify-between shrink-0">
                <h3 class="font-bold text-lg text-zinc-900 dark:text-white">Payment Method</h3>
                <button @click="$emit('close')" class="p-2 hover:bg-gray-100 dark:hover:bg-zinc-800 rounded-full transition-colors">
                    <X :size="20" class="text-zinc-500" />
                </button>
            </div>

            <!-- Payment Tabs -->
            <div class="flex p-2 bg-gray-50 dark:bg-zinc-950/50 mx-6 mt-6 rounded-xl shrink-0">
                <button 
                    @click="paymentMethod = 'cash'"
                    class="flex-1 py-2 text-sm font-bold rounded-lg transition-all flex items-center justify-center gap-2"
                    :class="paymentMethod === 'cash' ? 'bg-white dark:bg-zinc-800 text-zinc-900 dark:text-white shadow-sm' : 'text-zinc-500 hover:text-zinc-700'"
                >
                    <span>💵</span> Cash
                </button>
                <button 
                    @click="initQrisPayment"
                    class="flex-1 py-2 text-sm font-bold rounded-lg transition-all flex items-center justify-center gap-2"
                    :class="paymentMethod === 'qris' ? 'bg-white dark:bg-zinc-800 text-zinc-900 dark:text-white shadow-sm' : 'text-zinc-500 hover:text-zinc-700'"
                >
                    <span>📱</span> QRIS
                </button>
            </div>

            <div class="p-6 space-y-6 overflow-y-auto">
                <!-- Total Display -->
                <div class="text-center space-y-1">
                    <p class="text-sm text-zinc-500">Total Amount</p>
                    <p class="text-4xl font-black text-red-600 dark:text-red-400">
                        {{ formatCurrency(store.total) }}
                    </p>
                </div>

                <!-- CASH MODE -->
                <div v-if="paymentMethod === 'cash'" class="space-y-6 animate-in fade-in slide-in-from-right-4 duration-300">
                    <div class="space-y-2">
                        <label class="text-sm font-medium text-zinc-700 dark:text-zinc-300">Cash Received</label>
                        <div class="relative">
                            <span class="absolute left-4 top-1/2 -translate-y-1/2 text-zinc-400 font-bold">Rp</span>
                            <input 
                                v-model="cashReceived"
                                type="number" 
                                class="w-full pl-12 pr-4 py-4 text-xl font-bold rounded-xl border-gray-200 dark:border-zinc-700 dark:bg-zinc-800 focus:ring-2 focus:ring-red-500 transition-all"
                                placeholder="0"
                                autofocus
                            />
                        </div>
                    </div>

                    <!-- Change Display -->
                    <div class="flex items-center justify-between p-4 bg-gray-50 dark:bg-zinc-800/50 rounded-xl">
                        <span class="text-sm font-medium text-zinc-500">Change</span>
                        <div class="flex flex-col items-end">
                             <span class="text-xl font-bold text-zinc-900 dark:text-white">{{ formatCurrency(changeAmount) }}</span>
                             <span v-if="changeAmount < 0" class="text-xs text-red-500 font-bold">Insufficient</span>
                        </div>
                       
                    </div>

                    <!-- Quick Cash Buttons -->
                    <div class="grid grid-cols-3 gap-2">
                        <button 
                            v-for="amount in [20000, 50000, 100000]" 
                            :key="amount"
                            @click="cashReceived = (parseInt(cashReceived) || 0) + amount"
                            class="py-2 text-sm font-medium rounded-lg border border-gray-200 dark:border-zinc-700 hover:bg-gray-50 dark:hover:bg-zinc-800 transition-colors active:bg-gray-200"
                        >
                            +{{ formatCurrency(amount) }}
                        </button>
                        <button @click="cashReceived = store.total" class="py-2 text-sm font-bold rounded-lg border border-red-200 bg-red-50 text-red-700 hover:bg-red-100 transition-colors col-span-3">
                            Pas ({{ formatCurrency(store.total) }})
                        </button>
                    </div>
                </div>

                <!-- QRIS MODE -->
                <div v-if="paymentMethod === 'qris'" class="flex flex-col items-center space-y-6 animate-in fade-in slide-in-from-right-4 duration-300">
                    
                    <div class="relative group">
                        <!-- Simulated QR Code Container -->
                        <div class="w-48 h-48 bg-white border-2 border-zinc-900 rounded-xl p-2 shadow-lg flex items-center justify-center overflow-hidden relative">
                             <!-- Loading State -->
                            <div v-if="qrisStatus === 'generating'" class="absolute inset-0 flex flex-col items-center justify-center bg-white z-10">
                                <Loader2 :size="32" class="animate-spin text-zinc-300 mb-2" />
                                <span class="text-xs text-zinc-400 font-bold">Generating QR...</span>
                            </div>

                            <!-- Success Overlay -->
                             <div v-if="qrisStatus === 'paid'" class="absolute inset-0 flex flex-col items-center justify-center bg-green-500/90 z-20 text-white animate-in fade-in">
                                <CheckCircle :size="48" class="mb-2 drop-shadow-md" />
                                <span class="font-bold drop-shadow-md">PAID</span>
                            </div>

                            <!-- "Real" QR Image (Placeholder API) -->
                            <img 
                                v-if="qrisStatus !== 'generating'"
                                :src="`https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=KELONTONGPOS-${store.total}`" 
                                class="w-full h-full object-contain mix-blend-multiply opacity-90"
                                alt="QRIS Code"
                            />
                            
                            <!-- Logo Overlay -->
                            <div v-if="qrisStatus === 'waiting'" class="absolute inset-0 flex items-center justify-center pointer-events-none">
                                <div class="bg-white p-1 rounded-full shadow-sm">
                                    <div class="w-6 h-6 bg-red-600 rounded-full flex items-center justify-center text-white text-[8px] font-black">
                                        K
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Scan Frame Animation -->
                        <div v-if="qrisStatus === 'waiting'" class="absolute -inset-4 border-2 border-red-500/30 rounded-2xl animate-pulse"></div>
                    </div>

                    <div class="text-center space-y-1">
                        <p class="text-sm font-bold text-zinc-900 dark:text-white flex items-center justify-center gap-2">
                            <span v-if="qrisStatus === 'waiting'" class="relative flex h-3 w-3">
                              <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-red-400 opacity-75"></span>
                              <span class="relative inline-flex rounded-full h-3 w-3 bg-red-500"></span>
                            </span>
                            <span v-if="qrisStatus === 'generating'">Preparing QRIS...</span>
                            <span v-else-if="qrisStatus === 'waiting'">Waiting for payment...</span>
                            <span v-else-if="qrisStatus === 'paid'" class="text-green-600">Payment Verified!</span>
                        </p>
                        <p class="text-xs text-zinc-500">Scan via GoPay, OVO, Dana, BCA, etc.</p>
                    </div>

                    <div class="w-full p-3 bg-blue-50 text-blue-700 rounded-lg text-xs flex items-start gap-2">
                        <Info :size="14" class="shrink-0 mt-0.5" />
                        <p>This is a simulated QRIS. The system will automatically detect payment after 5 seconds.</p>
                    </div>

                </div>
            </div>

            <div class="p-6 pt-2 shrink-0 bg-white dark:bg-zinc-900 z-10">
                <button 
                    v-if="paymentMethod === 'cash'"
                    @click="processCheckout"
                    :disabled="!canCheckout || isProcessing"
                    class="w-full py-4 bg-gradient-to-r from-red-600 to-red-700 hover:from-red-500 hover:to-red-600 disabled:opacity-50 disabled:cursor-not-allowed text-white font-bold rounded-xl shadow-lg shadow-red-900/20 transition-all flex items-center justify-center gap-2"
                >
                    <span v-if="isProcessing">Processing...</span>
                    <span v-else>Complete Payment (Enter)</span>
                </button>

                 <button 
                    v-if="paymentMethod === 'qris'"
                    @click="forceSuccessQris"
                    :disabled="qrisStatus !== 'waiting'"
                    class="w-full py-4 bg-zinc-100 hover:bg-zinc-200 text-zinc-900 font-bold rounded-xl transition-all flex items-center justify-center gap-2"
                >
                    <CheckCircle :size="18" class="text-green-600" />
                    <span>Simulate Success (Manual)</span>
                </button>
            </div>
        </div>

        <!-- Success & Print Modal -->
        <div v-else class="bg-white dark:bg-zinc-900 w-full max-w-sm rounded-2xl shadow-xl overflow-hidden animate-in zoom-in duration-300">
            <div class="p-8 text-center space-y-6">
                <div class="w-20 h-20 bg-green-100 dark:bg-green-900/30 rounded-full flex items-center justify-center mx-auto text-green-600 dark:text-green-400">
                    <CheckCircle :size="40" />
                </div>
                
                <div>
                    <h3 class="text-2xl font-bold text-zinc-900 dark:text-white">Transaction Success!</h3>
                    <p class="text-zinc-500 mt-2">Paid via {{ paymentMethod === 'qris' ? 'QRIS' : 'Cash' }}</p>
                </div>
                
                <div v-if="paymentMethod === 'cash'" class="p-4 bg-gray-50 rounded-xl">
                     <p class="text-xs text-zinc-500 uppercase tracking-wider font-bold mb-1">Kembalian</p>
                    <p class="text-3xl font-black text-zinc-900 dark:text-white">{{ formatCurrency(lastTransaction.change_amount) }}</p>
                </div>
                 <div v-else class="p-4 bg-blue-50 text-blue-700 rounded-xl text-sm font-medium">
                    Payment Verified automatically by system.
                </div>

                <div class="flex flex-col gap-3">
                    <button 
                        @click="handlePrint"
                        class="w-full py-3 bg-gray-100 dark:bg-zinc-800 hover:bg-gray-200 dark:hover:bg-zinc-700 text-zinc-900 dark:text-white font-bold rounded-xl transition-colors flex items-center justify-center gap-2"
                    >
                        <Printer :size="20" />
                        Print Receipt Again
                    </button>
                    
                    <button 
                        @click="close"
                        class="w-full py-3 bg-red-600 hover:bg-red-700 text-white font-bold rounded-xl shadow-lg shadow-red-500/30 transition-colors"
                    >
                        New Transaction
                    </button>
                </div>
            </div>
        </div>

    </div>
</template>
