<script setup>
import AuthenticatedLayout from '@/Layouts/AuthenticatedLayout.vue';
import { Head } from '@inertiajs/vue3';
import { ShieldAlert, RefreshCw, Copy, Check } from 'lucide-vue-next';
import { ref } from 'vue';

defineProps({
    stores: Array
});

const copiedId = ref(null);

const copyCode = (code, id) => {
    navigator.clipboard.writeText(code);
    copiedId.value = id;
    setTimeout(() => copiedId.value = null, 2000);
};
</script>

<template>
    <Head title="Store Management" />

    <AuthenticatedLayout>
        <template #header>
            <h2 class="font-semibold text-xl text-gray-800 leading-tight">Branch Management</h2>
        </template>

        <div class="py-12">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
                <div class="bg-white overflow-hidden shadow-sm sm:rounded-lg p-6">
                    <div class="flex items-center gap-3 mb-8">
                        <div class="w-12 h-12 bg-amber-100 text-amber-600 rounded-2xl flex items-center justify-center">
                            <ShieldAlert :size="24" />
                        </div>
                        <div>
                            <h3 class="text-lg font-black tracking-tight">Emergency Offline Validation Codes</h3>
                            <p class="text-sm text-gray-500">Provide these codes to cashiers if the internet is down at their branch.</p>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <div v-for="store in stores" :key="store.id" class="border-2 border-gray-100 rounded-3xl p-6 hover:border-brand-500 transition-all group">
                            <div class="flex justify-between items-start mb-4">
                                <div>
                                    <h4 class="font-black text-xl tracking-tight">{{ store.name }}</h4>
                                    <p class="text-xs text-gray-400">{{ store.address }}</p>
                                </div>
                                <div class="bg-brand-50 text-brand-600 text-[10px] font-bold px-2 py-1 rounded">ID: {{ store.id }}</div>
                            </div>

                            <div class="bg-gray-50 rounded-2xl p-4 border border-dashed border-gray-200">
                                <label class="text-[10px] font-bold text-gray-400 uppercase tracking-widest block mb-2">Today's Validation Code</label>
                                <div class="flex items-center justify-between">
                                    <span class="text-3xl font-black font-mono tracking-widest text-zinc-900">{{ store.offline_code }}</span>
                                    <button @click="copyCode(store.offline_code, store.id)" class="w-10 h-10 rounded-xl flex items-center justify-center transition-colors" :class="copiedId === store.id ? 'bg-green-100 text-green-600' : 'bg-white border border-gray-200 text-gray-400 hover:text-brand-600'">
                                        <Check v-if="copiedId === store.id" :size="20" />
                                        <Copy v-else :size="20" />
                                    </button>
                                </div>
                            </div>
                            
                            <p class="mt-4 text-[10px] text-gray-500 italic">*This code expires at midnight server time.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AuthenticatedLayout>
</template>
