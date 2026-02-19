<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head, useForm, router } from '@inertiajs/vue3';
import { ref } from 'vue';
import { Users, Phone, Mail, Plus, Search, ChevronRight } from 'lucide-vue-next';

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

const getTierColor = (tier) => {
    switch (tier) {
        case 'platinum': return 'bg-purple-100 text-purple-700 dark:bg-purple-900/30 dark:text-purple-400';
        case 'gold': return 'bg-amber-100 text-amber-700 dark:bg-amber-900/30 dark:text-amber-400';
        default: return 'bg-zinc-100 text-zinc-700 dark:bg-zinc-800 dark:text-zinc-400';
    }
};

const formatNumber = (val) => new Intl.NumberFormat('id-ID').format(val);
</script>

<template>
    <Head title="Customers & Loyalty" />

    <MainLayout title="Customer Management">
        <div class="space-y-6">
            <!-- Summary Header -->
            <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div>
                    <h2 class="text-xl font-black text-zinc-900 dark:text-white flex items-center gap-2">
                        <Users class="text-red-600" />
                        Customer Management
                    </h2>
                </div>
                <!-- Quick Add Form -->
                <div class="bg-white dark:bg-zinc-900 p-4 rounded-xl border border-zinc-200 dark:border-zinc-800 shadow-sm flex-1 max-w-2xl">
                    <form @submit.prevent="submit" class="grid grid-cols-1 md:grid-cols-4 gap-3">
                        <div class="md:col-span-1">
                            <input v-model="form.name" type="text" placeholder="Full Name" required
                                   class="w-full h-10 px-3 text-sm bg-zinc-50 dark:bg-zinc-800 border-zinc-200 dark:border-zinc-700 rounded-lg focus:ring-2 focus:ring-red-500">
                        </div>
                        <div class="md:col-span-1">
                            <input v-model="form.phone" type="text" placeholder="Phone (WA)" required
                                   class="w-full h-10 px-3 text-sm bg-zinc-50 dark:bg-zinc-800 border-zinc-200 dark:border-zinc-700 rounded-lg focus:ring-2 focus:ring-red-500">
                        </div>
                         <div class="md:col-span-1">
                            <input v-model="search" type="text" placeholder="Search customers..."
                           class="w-full pl-10 h-11 bg-zinc-50 dark:bg-zinc-950 border-zinc-200 dark:border-zinc-800 rounded-lg focus:ring-2 focus:ring-red-500 text-sm">
                        </div>
                        <button @click="openModal()" 
                                class="bg-red-600 hover:bg-red-700 text-white px-6 h-11 rounded-xl flex items-center gap-2 font-bold shadow-lg shadow-red-600/20 transition-all">
                            <UserPlus :size="18" />
                            New Customer
                        </button>
                    </form>
                </div>
            </div>

            <!-- Customer Table -->
            <div class="bg-white dark:bg-zinc-900 rounded-xl border border-zinc-200 dark:border-zinc-800 overflow-hidden shadow-sm">
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-zinc-50 dark:bg-zinc-950/50 border-b border-zinc-200 dark:border-zinc-800">
                                <th class="px-6 py-4 text-xs font-bold text-zinc-500 uppercase tracking-wider">Customer</th>
                                <th class="px-6 py-4 text-xs font-bold text-zinc-500 uppercase tracking-wider">Loyalty Tier</th>
                                <th class="px-6 py-4 text-xs font-bold text-zinc-500 uppercase tracking-wider text-right">Points</th>
                                <th class="px-6 py-4 text-xs font-bold text-zinc-500 uppercase tracking-wider">Last Visit</th>
                                <th class="px-6 py-4 text-xs font-bold text-zinc-500 uppercase tracking-wider text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-zinc-100 dark:divide-zinc-800/50">
                            <tr v-for="c in customers.data" :key="c.id" class="hover:bg-zinc-50 dark:hover:bg-zinc-800/30 transition-colors group">
                                <td class="px-6 py-4">
                                    <div class="flex items-center gap-3">
                                        <div class="w-10 h-10 rounded-full bg-red-50 dark:bg-red-900/20 flex items-center justify-center text-red-600 dark:text-red-400 font-bold">
                                            {{ c.name.charAt(0) }}
                                        </div>
                                        <div>
                                            <div class="font-bold text-zinc-900 dark:text-white">{{ c.name }}</div>
                                            <div class="text-xs text-zinc-500 flex items-center gap-1">
                                                <Phone :size="10" /> {{ c.phone }}
                                            </div>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-6 py-4">
                                    <span class="px-2.5 py-1 rounded-full text-[10px] font-black uppercase tracking-widest" :class="getTierColor(c.tier)">
                                        {{ c.tier }}
                                    </span>
                                </td>
                                <td class="px-6 py-4 text-right">
                                    <div class="text-lg font-mono font-bold text-emerald-600 dark:text-emerald-400">
                                        {{ formatNumber(c.points_balance) }}
                                    </div>
                                    <div class="text-[10px] text-zinc-400 uppercase">Points</div>
                                </td>
                                <td class="px-6 py-4 text-sm text-zinc-500 dark:text-zinc-400">
                                    {{ c.last_visit_at ? new Date(c.last_visit_at).toLocaleDateString() : 'Never' }}
                                </td>
                                <td class="px-6 py-4 text-center">
                                    <button @click="openModal(c)" class="p-2 text-zinc-400 hover:text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition-colors">
                                        <Edit2 :size="16" />
                                    </button>
                                </td>
                            </tr>
                            <tr v-if="customers.data.length === 0">
                                <td colspan="5" class="px-6 py-12 text-center text-zinc-500">
                                    No customers found. Start by adding one above.
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div v-if="customers.links.length > 3" class="px-6 py-4 border-t border-zinc-100 dark:border-zinc-800 flex justify-center gap-2">
                    <button v-for="link in customers.links" :key="link.label"
                            @click="link.url && router.visit(link.url)"
                            v-html="link.label"
                            :disabled="!link.url"
                            class="px-3 py-1 text-sm rounded-lg border transition-all"
                            :class="link.active 
                                ? 'bg-indigo-600 border-indigo-600 text-white font-bold' 
                                : 'border-zinc-200 dark:border-zinc-700 text-zinc-600 dark:text-zinc-400 hover:bg-zinc-50 dark:hover:bg-zinc-800 disabled:opacity-30'">
                    </button>
                </div>
            </div>
        </div>
    </MainLayout>
</template>
