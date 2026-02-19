<script setup>
import { ref, watch, onMounted } from 'vue';
import { 
    ShieldCheck, 
    X, 
    Lock, 
    ChevronRight,
    Fingerprint,
    AlertTriangle,
    CheckCircle2
} from 'lucide-vue-next';

const props = defineProps({
    show: Boolean,
    title: {
        type: String,
        default: 'Privilege Escalation Required'
    },
    message: {
        type: String,
        default: 'This operation requires authorized personnel validation.'
    },
    actionLabel: {
        type: String,
        default: 'AUTHORIZE ACTION'
    }
});

const emit = defineEmits(['close', 'approved', 'denied']);

const pin = ref('');
const isVerifying = ref(false);
const error = ref(null);
const success = ref(false);

const handleInput = (num) => {
    if (pin.value.length < 4) {
        pin.value += num;
    }
};

const clearPin = () => {
    pin.value = '';
    error.value = null;
};

const verify = async () => {
    if (pin.value.length < 4) return;
    
    isVerifying.value = true;
    error.value = null;
    
    // Simulate back-end privilege check
    // In real app: axios.post('/api/auth/verify-manager', { pin: pin.value })
    setTimeout(() => {
        if (pin.value === '1234') { // Mock manager PIN
            success.value = true;
            setTimeout(() => {
                emit('approved');
                reset();
            }, 800);
        } else {
            error.value = 'Invalid access signature. Security event logged.';
            pin.value = '';
            isVerifying.value = false;
        }
    }, 1000);
};

const reset = () => {
    pin.value = '';
    isVerifying.value = false;
    error.value = null;
    success.value = false;
};

watch(() => props.show, (val) => {
    if (!val) reset();
});

onMounted(() => {
    window.addEventListener('keydown', (e) => {
        if (!props.show) return;
        if (e.key >= '0' && e.key <= '9') handleInput(e.key);
        if (e.key === 'Backspace') pin.value = pin.value.slice(0, -1);
        if (e.key === 'Enter') verify();
        if (e.key === 'Escape') emit('close');
    });
});
</script>

<template>
    <div v-if="show" class="fixed inset-0 z-[200] flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-xl animate-in fade-in duration-300">
        
        <div class="bg-white dark:bg-dark-surface w-full max-w-sm rounded-[40px] shadow-premium overflow-hidden flex flex-col animate-in zoom-in-95 duration-300 relative border border-brand-500/10">
            
            <!-- Strategic Header -->
            <div class="p-10 text-center space-y-4">
                <div class="w-20 h-20 mx-auto bg-brand-50 dark:bg-brand-900/10 rounded-[24px] flex items-center justify-center text-brand-600 relative overflow-hidden group">
                    <ShieldCheck :size="40" stroke-width="2.5" class="relative z-10 transition-transform group-hover:scale-110" />
                    <div class="absolute inset-0 bg-brand-600/5 animate-pulse-soft"></div>
                </div>
                
                <div class="space-y-1">
                    <h3 class="text-2xl font-black text-slate-900 dark:text-zinc-100 tracking-tighter uppercase font-serif italic">{{ title }}</h3>
                    <p class="text-[10px] font-black text-slate-400 dark:text-slate-500 uppercase tracking-widest leading-relaxed px-4">
                        {{ message }}
                    </p>
                </div>
            </div>

            <!-- PIN Interface -->
            <div class="px-10 pb-10 space-y-8">
                
                <!-- Display Dots -->
                <div class="flex justify-center gap-4">
                    <div v-for="i in 4" :key="i" 
                         class="w-4 h-4 rounded-full border-2 transition-all duration-300"
                         :class="[
                            pin.length >= i ? 'bg-brand-600 border-brand-600 scale-125 shadow-lg shadow-brand-200' : 'border-slate-200 dark:border-dark-border',
                            error && pin.length === 0 ? 'border-red-500 bg-red-500 animate-bounce' : '',
                            success ? 'bg-emerald-500 border-emerald-500' : ''
                         ]">
                    </div>
                </div>

                <!-- Numerical Matrix -->
                <div class="grid grid-cols-3 gap-3">
                    <button v-for="n in 9" :key="n" 
                            @click="handleInput(n.toString())"
                            class="h-16 rounded-2xl bg-surface-50 dark:bg-dark-bg/40 text-lg font-black text-slate-700 dark:text-zinc-300 hover:bg-brand-600 hover:text-white transition-all active:scale-90 border border-transparent hover:border-brand-500 shadow-sm">
                        {{ n }}
                    </button>
                    <button @click="clearPin" class="h-16 rounded-2xl text-xs font-black text-slate-400 uppercase tracking-widest hover:text-red-500">CLR</button>
                    <button @click="handleInput('0')" class="h-16 rounded-2xl bg-surface-50 dark:bg-dark-bg/40 text-lg font-black text-slate-700 dark:text-zinc-300 hover:bg-brand-600 hover:text-white transition-all active:scale-90 border border-transparent hover:border-brand-500 shadow-sm">0</button>
                    <button @click="verify" :disabled="pin.length < 4 || isVerifying"
                            class="h-16 rounded-2xl bg-slate-900 dark:bg-zinc-800 text-white flex items-center justify-center hover:bg-black transition-all active:scale-95 disabled:opacity-30">
                        <CheckCircle2 v-if="success" :size="24" class="text-emerald-400" />
                        <ChevronRight v-else :size="24" />
                    </button>
                </div>

                <!-- Status Feedback -->
                <div v-if="error" class="bg-red-50 dark:bg-red-900/10 border border-red-100 dark:border-red-900/20 p-4 rounded-2xl flex items-start gap-3 animate-in fade-in slide-in-from-top-2">
                    <AlertTriangle :size="16" class="text-red-500 shrink-0 mt-0.5" />
                    <span class="text-[9px] font-black text-red-500 uppercase tracking-[0.05em] leading-normal">{{ error }}</span>
                </div>

                 <p v-if="!error" class="text-[9px] text-center text-slate-400 font-bold uppercase tracking-widest animate-pulse-soft flex items-center justify-center gap-2">
                    <Lock :size="10" /> Authorized Nodes Only
                </p>
            </div>

            <!-- Absolute Close Control -->
            <button @click="$emit('close')" class="absolute top-6 right-6 text-slate-300 hover:text-slate-900 transition-colors">
                <X :size="20" stroke-width="3" />
            </button>

            <!-- Success Overlay -->
            <div v-if="success" class="absolute inset-0 bg-emerald-500 text-white flex flex-col items-center justify-center space-y-4 animate-in fade-in duration-300 z-20">
                <ShieldCheck :size="80" stroke-width="2" class="animate-bounce" />
                <h4 class="text-2xl font-black italic uppercase tracking-tighter">Access Granted</h4>
                <p class="text-[10px] uppercase font-black tracking-widest opacity-60">Handshaking Session Token...</p>
            </div>

        </div>
    </div>
</template>

<style scoped>
.animate-pulse-soft {
    animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
}
@keyframes pulse {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.5; }
}
</style>
