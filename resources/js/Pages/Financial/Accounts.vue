<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head } from '@inertiajs/vue3';
import { 
    BookOpen, Hash, Layers, 
    Tag, Info, Plus
} from 'lucide-vue-next';

const props = defineProps({
    accounts: Array
});

const getTypeBadge = (type) => {
    switch (type) {
        case 'asset': return 'bg-blue-100 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400';
        case 'liability': return 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400';
        case 'equity': return 'bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400';
        case 'revenue': return 'bg-indigo-100 text-indigo-700 dark:bg-indigo-900/30 dark:text-indigo-400';
        case 'expense': return 'bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400';
        default: return 'bg-zinc-100 text-zinc-700 dark:bg-zinc-800 dark:text-zinc-400';
    }
};
</script>

<template>
    <Head title="Chart of Accounts" />

    <MainLayout title="Accounting Structure">
        <div class="space-y-6 pb-20">
            <!-- Header -->
            <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div>
                    <h2 class="text-xl font-black text-zinc-900 dark:text-white flex items-center gap-2">
                    <CreditCard class="text-red-600" />
                    Accounts & Banks
                </h2>
                    <p class="text-sm text-zinc-500">Official registry of all financial tracking entities</p>
                </div>
                <button @click="openModal()" 
                        class="bg-red-600 hover:bg-red-700 text-white px-6 h-11 rounded-xl flex items-center gap-2 font-bold shadow-lg shadow-red-600/20 transition-all">
                    <Plus :size="18" />
                    Add Account
                </button>
            </div>

            <!-- Table -->
            <div class="bg-white dark:bg-zinc-900 rounded-2xl border border-zinc-200 dark:border-zinc-800 shadow-sm overflow-hidden">
                <table class="w-full">
                    <thead>
                        <tr class="bg-zinc-50 dark:bg-zinc-950 border-b border-zinc-200 dark:border-zinc-800">
                            <th class="px-8 py-4 text-left text-[10px] font-black text-zinc-400 uppercase tracking-widest">Account Code</th>
                            <th class="px-8 py-4 text-left text-[10px] font-black text-zinc-400 uppercase tracking-widest">Title / Name</th>
                            <th class="px-8 py-4 text-left text-[10px] font-black text-zinc-400 uppercase tracking-widest">Type</th>
                            <th class="px-8 py-4 text-left text-[10px] font-black text-zinc-400 uppercase tracking-widest">Description</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-zinc-100 dark:divide-zinc-800">
                        <tr v-for="account in accounts" :key="account.id" class="hover:bg-zinc-50 dark:hover:bg-zinc-950/50 transition-colors">
                            <td class="px-8 py-5">
                                <span class="font-mono text-sm font-black text-indigo-600 dark:text-indigo-400">
                                    {{ account.code }}
                                </span>
                            </td>
                            <td class="px-8 py-5">
                                <div class="font-bold text-zinc-900 dark:text-white">{{ account.name }}</div>
                            </td>
                            <td class="px-8 py-5">
                                <span :class="['text-[10px] font-black uppercase tracking-widest px-2.5 py-1 rounded-full', getTypeBadge(account.type)]">
                                    {{ account.type }}
                                </span>
                            </td>
                            <td class="px-8 py-5">
                                <span class="text-xs text-zinc-500 line-clamp-1">{{ account.description || 'Standard accounting entity' }}</span>
                                <div class="flex items-center gap-2">
                                    <button @click="openModal(account)" class="p-2 text-zinc-400 hover:text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition-colors">
                                        <Edit2 :size="16" />
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Hint -->
            <div class="bg-indigo-50 dark:bg-indigo-900/10 border border-indigo-100 dark:border-indigo-900/20 p-6 rounded-2xl flex items-start gap-4">
                <Info class="text-indigo-600 shrink-0" :size="20" />
                <p class="text-xs text-indigo-700 dark:text-indigo-400 font-bold leading-relaxed">
                    The Chart of Accounts is pre-configured according to standard retail accounting principles. 
                    Modification of system accounts is restricted to maintain data integrity with the AI Analytics engine.
                </p>
            </div>
        </div>
    </MainLayout>
</template>
