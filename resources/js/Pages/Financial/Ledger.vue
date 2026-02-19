<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head, router } from '@inertiajs/vue3';
import { ref, watch } from 'vue';
import debounce from 'lodash/debounce';
import { 
    ClipboardList, Search, Calendar, 
    ArrowRight, Filter, XCircle,
    ArrowDownLeft, ArrowUpRight
} from 'lucide-vue-next';

const props = defineProps({
    items: Object,
    accounts: Array,
    filters: Object
});

const filters = ref({
    account_code: props.filters.account_code || '',
    start_date: props.filters.start_date,
    end_date: props.filters.end_date
});

const formatCurrency = (val) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', minimumFractionDigits: 0 }).format(val);

const updateFilters = debounce(() => {
    router.get(route('financial.ledger'), filters.value, { preserveState: true, replace: true });
}, 300);

watch(filters, updateFilters, { deep: true });

const resetFilters = () => {
    filters.value = { account_code: '', start_date: props.filters.start_date, end_date: props.filters.end_date };
};
</script>

<template>
    <Head title="General Ledger" />

    <MainLayout title="General Ledger">
        <div class="space-y-6 pb-20">
            <!-- Header & Period Selector -->
            <div class="flex flex-col md:flex-row md:items-center justify-between gap-6">
                <div>
                    <h2 class="text-xl font-black text-zinc-900 dark:text-white flex items-center gap-2">
                        <BookOpen class="text-red-600" />
                        General Ledger
                    </h2>
                    <p class="text-zinc-500">Atomic journal entries and transaction lineage</p>
                </div>

                <div class="flex flex-wrap items-center gap-3 bg-white dark:bg-zinc-900 p-2 rounded-2xl border border-zinc-200 dark:border-zinc-800 shadow-sm">
                    <select v-model="filters.account_code" class="bg-transparent border-none text-xs font-bold focus:ring-0 min-w-[200px]">
                        <option value="">All Accounts</option>
                        <option v-for="acc in accounts" :key="acc.code" :value="acc.code">{{ acc.code }} - {{ acc.name }}</option>
                    </select>
                    <div class="h-4 w-px bg-zinc-200 dark:bg-zinc-700"></div>
                    <div class="flex items-center gap-2 px-2">
                        <Calendar :size="14" class="text-zinc-400" />
                        <input v-model="filters.start_date" type="date" class="bg-transparent border-none text-[10px] font-black uppercase focus:ring-0">
                    </div>
                    <span>-</span>
                    <input v-model="filters.end_date" type="date" class="bg-transparent border-none text-[10px] font-black uppercase focus:ring-0">

                    <button v-if="filters.account_code" @click="resetFilters" class="p-1.5 text-zinc-400 hover:text-red-500 transition-colors">
                        <XCircle :size="16" />
                    </button>
                    <button @click="openModal()"
                        class="bg-red-600 hover:bg-red-700 text-white px-6 h-11 rounded-xl flex items-center gap-2 font-bold shadow-lg shadow-red-600/20 transition-all">
                    <Plus :size="18" />
                    Record Entry
                </button>
                </div>
            </div>

            <!-- Entries List -->
            <div class="space-y-4">
                <div class="relative">
                    <Search :size="18" class="text-zinc-400 absolute left-3 top-1/2 -translate-y-1/2" />
                    <input v-model="search" type="text" placeholder="Search transactions..."
                           class="w-full pl-10 h-11 bg-zinc-50 dark:bg-zinc-950 border-zinc-200 dark:border-zinc-800 rounded-lg focus:ring-2 focus:ring-red-500 text-sm">
                </div>
                <div v-for="item in items.data" :key="item.id"
                     class="group bg-white dark:bg-zinc-900 rounded-2xl border border-zinc-200 dark:border-zinc-800 hover:shadow-xl hover:shadow-red-500/5 transition-all overflow-hidden">

                    <div class="flex flex-col md:flex-row">
                        <!-- Left Info -->
                        <div class="w-full md:w-64 p-6 border-r border-zinc-100 dark:border-zinc-800 bg-zinc-50/50 dark:bg-zinc-950/20">
                            <div class="text-[10px] font-black text-red-600 dark:text-red-400 uppercase tracking-widest mb-1">
                                {{ new Date(item.entry.transaction_date).toLocaleDateString() }}
                            </div>
                            <div class="font-mono text-sm font-black text-zinc-900 dark:text-white mb-2">
                                {{ item.entry.reference_number }}
                            </div>
                            <div class="text-[10px] font-bold text-zinc-400 uppercase tracking-tighter">
                                Ref: {{ item.entry.reference_type.split('\\').pop() }} #{{ item.entry.reference_id }}
                            </div>
                        </div>

                        <!-- Main Content -->
                        <div class="flex-1 p-6 flex items-center justify-between gap-8">
                            <div class="flex-1 space-y-1">
                                <div class="flex items-center gap-2">
                                    <span class="text-[10px] font-mono font-black text-zinc-400 bg-zinc-100 dark:bg-zinc-800 px-1.5 py-0.5 rounded">
                                        {{ item.account_code }}
                                    </span>
                                    <span class="font-bold text-zinc-900 dark:text-white">{{ item.account_name }}</span>
                                </div>
                                <p class="text-xs text-zinc-500 line-clamp-1 italic">{{ item.entry.description }}</p>
                            </div>

                            <div class="flex items-center gap-12 text-right">
                                <div v-if="item.debit > 0" class="space-y-0.5">
                                    <div class="text-[8px] font-black text-emerald-500 uppercase tracking-widest flex items-center justify-end gap-1">
                                        <ArrowDownLeft :size="8" /> Debit
                                    </div>
                                    <div class="text-sm font-black text-emerald-600 dark:text-emerald-400">{{ formatCurrency(item.debit) }}</div>
                                </div>
                                <div v-if="item.credit > 0" class="space-y-0.5">
                                    <div class="text-[8px] font-black text-red-500 uppercase tracking-widest flex items-center justify-end gap-1">
                                        <ArrowUpRight :size="8" /> Credit
                                    </div>
                                    <div class="text-sm font-black text-red-600 dark:text-red-400">{{ formatCurrency(item.credit) }}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div v-if="items.data.length === 0" class="p-20 text-center bg-white dark:bg-zinc-900 rounded-3xl border border-dashed border-zinc-200 dark:border-zinc-800">
                    <ClipboardList :size="48" class="text-zinc-200 dark:text-zinc-800 mx-auto mb-4" />
                    <p class="text-zinc-400 font-bold">No ledger movements found for selected filters.</p>
                </div>
            </div>

            <!-- Pagination -->
            <div v-if="items.total > items.per_page" class="flex justify-center pt-8">
                <div class="flex bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-xl overflow-hidden shadow-sm">
                    <button v-for="link in items.links" :key="link.label"
                            @click="router.visit(link.url)"
                            :disabled="!link.url || link.active"
                            class="px-4 py-2 text-sm font-bold transition-colors disabled:opacity-50"
                            :class="link.active ? 'bg-indigo-600 text-white' : 'text-zinc-500 hover:bg-zinc-50 dark:hover:bg-zinc-800'"
                            v-html="link.label">
                    </button>
                </div>
            </div>
        </div>
    </MainLayout>
</template>
