<script setup>
import { Link, usePage } from '@inertiajs/vue3';
import { LayoutGrid, Monitor, ShoppingCart, User, Search, Settings } from 'lucide-vue-next';
import { useCartStore } from '@/Stores/cartStore';
import { computed, ref, onMounted, onUnmounted } from 'vue';

defineProps({
    title: String,
});

const page = usePage();
const cartStore = useCartStore();

// Get current user (cashier) from Inertia page props
const currentUser = computed(() => page.props.auth?.user || { name: 'Cashier' });
const isOnline = ref(navigator.onLine);

const updateOnlineStatus = () => {
    isOnline.value = navigator.onLine;
};

onMounted(() => {
    window.addEventListener('online', updateOnlineStatus);
    window.addEventListener('offline', updateOnlineStatus);
});

onUnmounted(() => {
    window.removeEventListener('online', updateOnlineStatus);
    window.removeEventListener('offline', updateOnlineStatus);
});

const formatPrice = (value) => {
    return new Intl.NumberFormat('id-ID', {
        style: 'currency',
        currency: 'IDR',
        minimumFractionDigits: 0
    }).format(value);
};

const openPayment = () => {
    window.dispatchEvent(new CustomEvent('open-payment'));
};
</script>

<template>
    <div class="flex h-screen w-full bg-slate-50 dark:bg-dark-bg overflow-hidden text-zinc-900 dark:text-zinc-200 font-sans">
        <!-- Main Content (Products) - 65% width -->
        <main class="flex-[65] flex flex-col h-full min-w-0 bg-white dark:bg-zinc-900 shadow-xl z-10">
            <!-- Header -->
            <header class="h-16 border-b border-gray-200 dark:border-zinc-800 flex items-center justify-between px-6 shrink-0 bg-white dark:bg-zinc-900 z-20">
                <div class="flex items-center gap-4 overflow-hidden">
                    <Link href="/dashboard" class="p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-zinc-800 transition-colors text-zinc-500">
                        <LayoutGrid :size="20" />
                    </Link>
                    
                    <!-- Session Indicator -->
                    <div class="flex items-center gap-3 pl-3 border-l border-gray-200 dark:border-zinc-800">
                        <div class="flex flex-col">
                            <span class="text-xs text-zinc-500 font-medium">POS Kelontong</span>
                            <span class="text-sm font-bold text-zinc-900 dark:text-zinc-200 leading-none">{{ currentUser.name }}</span>
                        </div>
                    </div>
                </div>
                
                <div class="flex items-center gap-2">
                    <!-- Session Status -->
                    <div class="px-3 py-1.5 rounded-full bg-blue-50 dark:bg-blue-500/10 text-blue-600 dark:text-blue-400 text-xs font-bold flex items-center gap-1.5 border border-blue-100 dark:border-blue-500/20">
                        <Monitor :size="12" />
                        SESSION OPEN
                    </div>
                    
                    <!-- Online Status -->
                    <div :class="[
                        'px-3 py-1.5 rounded-full text-xs font-bold flex items-center gap-1.5 border transition-colors',
                        isOnline 
                            ? 'bg-success/10 dark:bg-success/20 text-success border-success/20 dark:border-success/30' 
                            : 'bg-danger/10 dark:bg-danger/20 text-danger border-danger/20 dark:border-danger/30'
                    ]">
                        <div :class="['w-2 h-2 rounded-full animate-pulse', isOnline ? 'bg-success' : 'bg-danger']"></div>
                        {{ isOnline ? 'ONLINE' : 'OFFLINE' }}
                    </div>
                </div>
            </header>

            <!-- Product Grid Area -->
            <div class="flex-1 overflow-y-auto p-4 content-start">
                <slot name="grid" />
            </div>
        </main>

        <!-- Sidebar (Cart) - 35% width -->
        <aside class="flex-[35] flex flex-col h-full bg-white dark:bg-dark-bg border-l border-gray-200 dark:border-zinc-800 shrink-0 z-20">
            <!-- Cart Header -->
            <div class="h-16 border-b border-gray-200 dark:border-zinc-800 px-6 flex items-center justify-between shrink-0">
                <div class="flex items-center gap-2">
                    <ShoppingCart :size="20" class="text-zinc-500" />
                    <span class="text-lg font-bold text-zinc-900 dark:text-zinc-200">
                        Cart <span class="text-zinc-500">({{ cartStore.count }} items)</span>
                    </span>
                </div>
                <div class="flex items-center gap-3 cursor-pointer hover:opacity-75 transition-opacity">
                    <div class="w-8 h-8 rounded-full bg-brand-100 dark:bg-brand-900/30 flex items-center justify-center text-brand-600 dark:text-brand-400 font-bold text-xs border border-brand-200 dark:border-brand-900/50">
                        GS
                    </div>
                </div>
            </div>

            <!-- Cart Items -->
            <div class="flex-1 overflow-y-auto p-4 space-y-2 bg-gray-50/50 dark:bg-zinc-900/50">
                <slot name="cart" />
            </div>

            <!-- Totals & Payment -->
            <div class="p-6 bg-white dark:bg-dark-bg border-t border-gray-200 dark:border-zinc-800 shrink-0 space-y-4 shadow-[0_-4px_6px_-1px_rgba(0,0,0,0.05)] z-30">
                <div class="space-y-2">
                    <div class="flex justify-between text-zinc-500 text-sm">
                        <span>Subtotal</span>
                        <span>{{ formatPrice(cartStore.subtotal) }}</span>
                    </div>
                    <div class="flex justify-between text-zinc-500 text-sm">
                        <span>Tax (11%)</span>
                        <span>{{ formatPrice(cartStore.tax) }}</span>
                    </div>
                    <div v-if="cartStore.discountAmount > 0" class="flex justify-between text-danger text-sm">
                        <span>Discount ({{ cartStore.discountPercent }}%)</span>
                        <span>-{{ formatPrice(cartStore.discountAmount) }}</span>
                    </div>
                    <div class="flex justify-between items-end pt-3 border-t-2 border-gray-200 dark:border-zinc-800">
                        <span class="text-zinc-900 dark:text-zinc-200 font-bold text-lg">TOTAL</span>
                        <span class="text-5xl font-black text-zinc-900 dark:text-zinc-200 tracking-tight leading-none">{{ formatPrice(cartStore.total) }}</span>
                    </div>
                </div>

                <div class="grid grid-cols-4 gap-2">
                   <button @click="cartStore.clear" class="col-span-1 py-4 rounded-xl bg-gray-100 dark:bg-zinc-800 text-zinc-600 dark:text-zinc-400 font-bold hover:bg-gray-200 dark:hover:bg-zinc-700 transition-colors flex flex-col items-center justify-center gap-1 text-xs">
                        CLEAR
                        <span class="text-[10px] opacity-50">(ESC)</span>
                    </button>
                    <button @click="openPayment" :disabled="cartStore.count === 0" class="col-span-3 py-4 rounded-xl bg-zinc-900 dark:bg-brand-600 text-white font-bold text-lg hover:bg-black dark:hover:bg-brand-500 transition-all shadow-lg shadow-zinc-900/10 dark:shadow-brand-600/20 active:scale-[0.98] disabled:opacity-50 disabled:cursor-not-allowed">
                        Charge <span class="text-sm opacity-75">(F8)</span>
                    </button>
                </div>
            </div>
        </aside>
    </div>
</template>
