<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head } from '@inertiajs/vue3';
import { ref, computed, nextTick, onMounted } from 'vue';
import { Search, Scan, CheckCircle, AlertCircle, RefreshCcw, Save } from 'lucide-vue-next';
import axios from 'axios';

const props = defineProps({
    products: Array
});

const scanInput = ref('');
const scanInputRef = ref(null);
const physicalQty = ref(1);
const auditItems = ref([]); // {id, name, system, physical, diff}
const isProcessing = ref(false);

const handleScan = () => {
    if (!scanInput.value) return;

    const product = props.products.find(p => p.barcode === scanInput.value || p.name.toLowerCase().includes(scanInput.value.toLowerCase()));
    
    if (product) {
        const existing = auditItems.value.find(i => i.id === product.id);
        if (existing) {
            existing.physical += physicalQty.value;
            existing.diff = existing.physical - existing.system;
        } else {
            auditItems.value.unshift({
                id: product.id,
                name: product.name,
                system: product.stock,
                physical: physicalQty.value,
                diff: physicalQty.value - product.stock
            });
        }
    } else {
        alert('Product not found: ' + scanInput.value);
    }

    scanInput.value = '';
    physicalQty.value = 1;
    nextTick(() => scanInputRef.value.focus());
};

const reconcile = async (item) => {
    isProcessing.value = true;
    try {
        const response = await axios.post('/inventory/audit/reconcile', {
            product_id: item.id,
            physical_qty: item.physical,
            notes: 'System Opname Reconcile'
        });
        
        if (response.data.success) {
            item.system = response.data.new_stock;
            item.diff = 0;
            // Optionally remove from list after reconcile
            alert('Reconciled ' + item.name);
        }
    } catch (error) {
        alert('Reconcile failed for ' + item.name);
    } finally {
        isProcessing.value = false;
    }
};

onMounted(() => {
    nextTick(() => scanInputRef.value.focus());
});
</script>

<template>
    <Head title="Stock Audit" />
    <MainLayout title="Stock Audit & Opname">
        <div class="max-w-4xl mx-auto space-y-6 pb-20">
            <!-- Scan Controls -->
            <div class="bg-white dark:bg-zinc-900 p-8 rounded-3xl border border-gray-100 dark:border-zinc-800 shadow-xl">
                <div class="flex flex-col md:flex-row gap-4">
                    <div class="flex-1 relative">
                        <Scan class="absolute left-4 top-1/2 -translate-y-1/2 text-zinc-400" :size="20" />
                        <input 
                            ref="scanInputRef"
                            v-model="scanInput"
                            @keyup.enter="handleScan"
                            type="text" 
                            placeholder="Scan barcode or type product name..."
                            class="w-full pl-12 pr-4 py-4 bg-zinc-50 dark:bg-zinc-950 border-2 border-zinc-100 dark:border-zinc-800 rounded-2xl text-lg font-bold focus:ring-0 focus:border-red-500 transition-all"
                        />
                    </div>
                    <div class="w-full md:w-32">
                         <input 
                            v-model.number="physicalQty"
                            type="number"
                            class="w-full py-4 bg-zinc-50 dark:bg-zinc-950 border-2 border-zinc-100 dark:border-zinc-800 rounded-2xl text-lg font-bold text-center focus:ring-0 focus:border-red-500 transition-all"
                            placeholder="Qty"
                        />
                    </div>
                    <button @click="startAudit" 
                            class="bg-red-600 hover:bg-red-700 text-white px-6 h-11 rounded-xl flex items-center gap-2 font-bold shadow-lg shadow-red-600/20 transition-all">
                        <Play :size="18" />
                        Start Audit
                    </button>
                </div>
            </div>


            <!-- Audit List -->
            <div class="space-y-4">
                <div v-if="auditItems.length === 0" class="p-12 text-center bg-zinc-50 dark:bg-zinc-900/50 rounded-3xl border-2 border-dashed border-zinc-200 dark:border-zinc-800">
                     <AlertCircle :size="48" class="mx-auto text-zinc-300 mb-4" />
                     <p class="text-zinc-500 font-medium">No items scanned yet. Start scanning to perform audit.</p>
                </div>

                <div v-for="item in auditItems" :key="item.id" class="bg-white dark:bg-zinc-900 p-6 rounded-3xl border border-gray-100 dark:border-zinc-800 shadow-sm flex items-center justify-between gap-6 animate-in slide-in-from-top-4">
                    <div class="flex-1">
                        <h4 class="font-black text-zinc-900 dark:text-white uppercase tracking-tight">{{ item.name }}</h4>
                        <div class="flex gap-4 mt-1">
                            <span class="text-[10px] font-bold text-zinc-400 uppercase tracking-widest">System: {{ item.system }}</span>
                            <span class="text-[10px] font-bold text-zinc-400 uppercase tracking-widest">Physical: {{ item.physical }}</span>
                        </div>
                    </div>

                    <div class="flex items-center gap-6">
                        <div :class="['text-right', item.diff === 0 ? 'text-emerald-500' : (item.diff > 0 ? 'text-red-500' : 'text-red-500')]">
                            <div class="text-xl font-black tabular-nums">{{ item.diff > 0 ? '+' : '' }}{{ item.diff }}</div>
                            <div class="text-[8px] font-black uppercase tracking-widest">{{ item.diff === 0 ? 'Match' : 'Discrepancy' }}</div>
                        </div>

                        <button 
                            @click="reconcile(item)"
                            :disabled="item.diff === 0 || isProcessing"
                            class="p-3 bg-zinc-50 dark:bg-zinc-950 border border-zinc-100 dark:border-zinc-800 rounded-2xl text-zinc-500 hover:text-red-600 hover:border-red-200 transition-all disabled:opacity-30"
                        >
                            <RefreshCcw v-if="!isProcessing" :size="20" />
                            <Loader2 v-else class="animate-spin" :size="20" />
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </MainLayout>
</template>
