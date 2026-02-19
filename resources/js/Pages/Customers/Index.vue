<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import DataTable from '@/Components/Common/DataTable.vue';
import { Head, useForm, router } from '@inertiajs/vue3';
import { ref } from 'vue';
import { Users, Phone, Mail, Plus, Search, UserPlus, Star } from 'lucide-vue-next';

const props = defineProps({
    customers: Object,
    flash: Object
});

const form = useForm({
    name: '',
    phone: '',
    email: '',
});

const submit = () => {
    form.post(route('customers.store'), {
        preserveScroll: true,
        onSuccess: () => form.reset(),
    });
};

const columns = [
    { key: 'identity', label: 'Persona', sortable: false },
    { key: 'tier', label: 'Loyalty Protocol', sortable: true },
    { key: 'points_balance', label: 'Equilibrium', align: 'right', sortable: true },
    { key: 'last_visit_at', label: 'Temporal Marker', sortable: true }
];

const getTierStyle = (tier) => {
    switch (tier?.toLowerCase()) {
        case 'platinum': return 'bg-brand-50 text-brand-600 border-brand-100';
        case 'gold': return 'bg-amber-50 text-amber-600 border-amber-100';
        default: return 'bg-slate-50 text-slate-400 border-slate-100';
    }
};

const formatNumber = (val) => new Intl.NumberFormat('id-ID').format(val);
const handleEdit = (item) => { /* logic to open edit modal */ };
</script>

<template>
    <Head title="Client Relations" />

    <MainLayout title="Persona Management">
        <template #header-actions>
             <div class="flex items-center gap-4">
                <div class="bg-white dark:bg-dark-surface p-2 rounded-2xl border border-surface-100 dark:border-dark-border shadow-soft flex items-center gap-2">
                    <input v-model="form.name" type="text" placeholder="Identity Name" 
                           class="bg-transparent border-none text-[10px] font-black uppercase tracking-widest px-4 focus:ring-0 w-32 outline-none">
                    <div class="w-px h-6 bg-surface-100 dark:bg-dark-border"></div>
                     <input v-model="form.phone" type="text" placeholder="Contact Matrix" 
                           class="bg-transparent border-none text-[10px] font-black uppercase tracking-widest px-4 focus:ring-0 w-32 outline-none">
                    <button @click="submit" :disabled="form.processing"
                            class="bg-brand-600 hover:bg-brand-700 text-white p-2 rounded-xl transition-all active:scale-95 disabled:opacity-50">
                        <Plus :size="16" stroke-width="3" />
                    </button>
                </div>
            </div>
        </template>

        <div class="space-y-8 animate-in fade-in duration-500">
            
            <DataTable 
                :columns="columns"
                :items="customers.data"
                title="Client Registry"
                subtitle="High-Affinity Loyalty Accounts"
                searchPlaceholder="Analyze identity, contact, or tier..."
                @edit="handleEdit"
            >
                <!-- IDENTITY CELL -->
                <template #col-identity="{ item }">
                    <div class="flex items-center gap-4">
                        <div class="w-12 h-12 rounded-2xl bg-brand-50 dark:bg-brand-900/10 flex items-center justify-center text-brand-600 font-black text-lg shadow-inner">
                            {{ item.name.charAt(0) }}
                        </div>
                        <div class="flex flex-col">
                            <span class="text-sm font-black text-slate-900 dark:text-zinc-100 uppercase italic font-serif">{{ item.name }}</span>
                            <span class="text-[9px] font-bold text-slate-400 uppercase tracking-widest flex items-center gap-1">
                                <Phone :size="10" /> {{ item.phone }}
                            </span>
                        </div>
                    </div>
                </template>

                <!-- TIER CELL -->
                <template #col-tier="{ item }">
                    <div class="flex items-center gap-2">
                        <span class="px-3 py-1 rounded-full border text-[9px] font-black uppercase tracking-widest flex items-center gap-2" :class="getTierStyle(item.tier)">
                            <Star v-if="item.tier === 'platinum' || item.tier === 'gold'" :size="10" fill="currentColor" />
                            {{ item.tier || 'GENERIC' }}
                        </span>
                    </div>
                </template>

                <!-- EQUILIBRIUM CELL (POINTS) -->
                <template #col-points_balance="{ item }">
                    <div class="flex flex-col items-end">
                        <span class="text-xl font-black italic tabular-nums text-emerald-500">{{ formatNumber(item.points_balance) }}</span>
                        <span class="text-[9px] font-black text-slate-400 uppercase tracking-widest">Loyalty Credits</span>
                    </div>
                </template>

                <!-- TEMPORAL MARKER CELL (LAST VISIT) -->
                <template #col-last_visit_at="{ item }">
                    <div class="flex flex-col">
                        <span class="text-xs font-bold text-slate-700 dark:text-zinc-300">
                             {{ item.last_visit_at ? new Date(item.last_visit_at).toLocaleDateString(undefined, { day: '2-digit', month: 'short', year: 'numeric' }) : 'STAGNANT' }}
                        </span>
                        <span class="text-[9px] font-bold text-slate-400 uppercase tracking-widest">Last Interaction</span>
                    </div>
                </template>

            </DataTable>

        </div>
    </MainLayout>
</template>
