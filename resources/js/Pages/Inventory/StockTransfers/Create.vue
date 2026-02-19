<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head, useForm } from '@inertiajs/vue3';
import { Truck, Plus, Trash2, Save, ArrowRight, Search, AlertCircle } from 'lucide-vue-next';
import { ref, computed, watch } from 'vue';

const props = defineProps({
    stores: Array,
    products: Array
});

const form = useForm({
    source_store_id: '',
    dest_store_id: '',
    items: [],
    notes: ''
});

const availableProducts = computed(() => {
    if (!form.source_store_id) return [];
    // If products have store_id, filter by it. If store_id is null (global), include it?
    // Let's assume strict store ownership for now based on previous analysis.
    return props.products.filter(p => p.store_id == form.source_store_id);
});

const addItem = () => {
    form.items.push({
        product_id: '',
        quantity: 1
    });
};

const removeItem = (index) => {
    form.items.splice(index, 1);
};

// Reset items if source store changes
watch(() => form.source_store_id, () => {
    form.items = [];
});

const submit = () => {
    form.post(route('stock-transfers.store'));
};
</script>

<template>
    <Head title="Create Transfer" />

    <MainLayout title="New Stock Transfer">
        <div class="max-w-5xl mx-auto">
            <div class="mb-6 flex items-center justify-between">
                <div>
                     <h2 class="text-xl font-black text-zinc-900 dark:text-white flex items-center gap-2">
                        <Truck class="text-red-600" />
                        Create Stock Transfer
                    </h2>
                    <p class="text-sm text-zinc-500">Initiate a movement of goods between locations</p>
                </div>
            </div>

            <form @submit.prevent="submit" class="space-y-6">
                <!-- Location Details -->
                <div class="bg-white dark:bg-zinc-900 rounded-xl border border-zinc-200 dark:border-zinc-800 p-6 shadow-sm">
                    <h3 class="font-bold text-lg mb-4 text-zinc-900 dark:text-white">Location Details</h3>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-8 items-center">
                        <div class="space-y-2">
                            <label class="text-sm font-bold text-zinc-700 dark:text-zinc-300">Source Store (From)</label>
                            <select v-model="form.source_store_id" class="w-full rounded-xl border-zinc-300 dark:border-zinc-700 dark:bg-zinc-800 focus:ring-red-500 focus:border-red-500">
                                <option value="" disabled>Select Source</option>
                                <option v-for="store in stores" :key="store.id" :value="store.id">
                                    {{ store.name }}
                                </option>
                            </select>
                            <p class="text-xs text-zinc-500">Stock will be deducted from here.</p>
                        </div>

                        <div class="hidden md:flex justify-center text-zinc-300 dark:text-zinc-700">
                            <ArrowRight :size="32" />
                        </div>

                        <div class="space-y-2">
                            <label class="text-sm font-bold text-zinc-700 dark:text-zinc-300">Destination Store (To)</label>
                            <select v-model="form.dest_store_id" class="w-full rounded-xl border-zinc-300 dark:border-zinc-700 dark:bg-zinc-800 focus:ring-red-500 focus:border-red-500">
                                <option value="" disabled>Select Destination</option>
                                <option v-for="store in stores" :key="store.id" :value="store.id" :disabled="store.id === form.source_store_id">
                                    {{ store.name }}
                                </option>
                            </select>
                            <p class="text-xs text-zinc-500">Stock will be added here.</p>
                        </div>
                    </div>
                </div>

                <!-- Items -->
                <div class="bg-white dark:bg-zinc-900 rounded-xl border border-zinc-200 dark:border-zinc-800 p-6 shadow-sm">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="font-bold text-lg text-zinc-900 dark:text-white">Items to Transfer</h3>
                        <button type="button" @click="addItem" :disabled="!form.source_store_id"
                                class="text-sm font-bold text-red-600 hover:text-red-700 flex items-center gap-1 disabled:opacity-50 disabled:cursor-not-allowed">
                            <Plus :size="16" /> Add Item
                        </button>
                    </div>

                    <div v-if="!form.source_store_id" class="p-8 text-center bg-zinc-50 dark:bg-zinc-950 rounded-xl border border-dashed border-zinc-200 dark:border-zinc-800">
                        <AlertCircle class="mx-auto text-zinc-400 mb-2" />
                        <p class="text-zinc-500 font-medium">Please select a Source Store first.</p>
                    </div>

                    <div v-else class="space-y-4">
                        <div v-for="(item, index) in form.items" :key="index" class="flex items-start gap-4 p-4 bg-zinc-50 dark:bg-zinc-950 rounded-xl border border-zinc-100 dark:border-zinc-800">
                            <div class="flex-1 space-y-1">
                                <label class="text-xs font-bold text-zinc-500 uppercase">Product</label>
                                <select v-model="item.product_id" class="w-full rounded-lg border-zinc-300 dark:border-zinc-700 dark:bg-zinc-900 text-sm focus:ring-red-500">
                                    <option value="">Select Product</option>
                                    <option v-for="product in availableProducts" :key="product.id" :value="product.id">
                                        {{ product.name }} (Stock: {{ product.stock }})
                                    </option>
                                </select>
                            </div>
                            <div class="w-32 space-y-1">
                                <label class="text-xs font-bold text-zinc-500 uppercase">Quantity</label>
                                <input type="number" v-model="item.quantity" min="1" class="w-full rounded-lg border-zinc-300 dark:border-zinc-700 dark:bg-zinc-900 text-sm focus:ring-red-500" />
                            </div>
                            <button type="button" @click="removeItem(index)" class="mt-6 p-2 text-zinc-400 hover:text-red-600 transition-colors">
                                <Trash2 :size="18" />
                            </button>
                        </div>
                        
                         <button v-if="form.items.length === 0 && form.source_store_id" type="button" @click="addItem" 
                                class="w-full py-3 border-2 border-dashed border-zinc-200 dark:border-zinc-700 rounded-xl text-zinc-500 hover:text-red-600 hover:border-red-200 font-bold transition-all flex items-center justify-center gap-2">
                            <Plus :size="18" /> Add First Item
                        </button>
                    </div>
                </div>

                <!-- Notes & Submit -->
                <div class="bg-white dark:bg-zinc-900 rounded-xl border border-zinc-200 dark:border-zinc-800 p-6 shadow-sm">
                    <div class="space-y-2 mb-6">
                        <label class="text-sm font-bold text-zinc-700 dark:text-zinc-300">Notes (Optional)</label>
                        <textarea v-model="form.notes" rows="3" class="w-full rounded-xl border-zinc-300 dark:border-zinc-700 dark:bg-zinc-800 focus:ring-red-500 focus:border-red-500"></textarea>
                    </div>

                    <div class="flex justify-end gap-4">
                        <button type="button" @click="$inertia.visit(route('stock-transfers.index'))" class="px-6 py-2 rounded-xl font-bold text-zinc-600 hover:bg-zinc-100 dark:text-zinc-400 dark:hover:bg-zinc-800 transition-colors">
                            Cancel
                        </button>
                        <button type="submit" :disabled="form.processing" class="px-6 py-2 bg-red-600 hover:bg-red-700 text-white rounded-xl font-bold shadow-lg shadow-red-600/20 transition-all flex items-center gap-2 disabled:opacity-70 disabled:cursor-not-allowed">
                            <Save :size="18" />
                            Create Transfer
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </MainLayout>
</template>
