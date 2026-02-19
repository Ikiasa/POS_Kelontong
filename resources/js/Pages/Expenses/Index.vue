<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head, useForm } from '@inertiajs/vue3';
import ContentBlock from '@/Components/UI/ContentBlock.vue';
import Button from '@/Components/UI/Button.vue';
import Input from '@/Components/UI/Input.vue';
import { ref, computed } from 'vue';
import { Plus, Trash2, Calendar, FileText, Banknote } from 'lucide-vue-next';

const props = defineProps({
    expenses: Object,
    accounts: Array, // Expense Accounts
});

const showForm = ref(false);

const form = useForm({
    account_code: '',
    amount: '',
    description: '',
    date: new Date().toISOString().split('T')[0],
});

const submit = () => {
    form.post(route('expenses.store'), {
        onSuccess: () => {
            form.reset('amount', 'description');
            showForm.value = false;
        },
    });
};

const formatCurrency = (value) => {
    return new Intl.NumberFormat('id-ID', {
        style: 'currency',
        currency: 'IDR',
        minimumFractionDigits: 0
    }).format(value);
};

const formatDate = (dateString) => {
    return new Date(dateString).toLocaleDateString('id-ID', {
        day: 'numeric', month: 'short', year: 'numeric'
    });
};
</script>

<template>
    <Head title="Pengeluaran Operasional" />

    <MainLayout>
        <template #header>
            <div class="flex items-center justify-between">
                <h2 class="font-bold text-xl text-zinc-800 dark:text-zinc-200 leading-tight flex items-center gap-2">
                    <Banknote class="text-rose-500" />
                    Pengeluaran Operasional
                </h2>
                <Button @click="showForm = !showForm" variant="primary">
                    <Plus class="w-4 h-4 mr-2" />
                    Catat Pengeluaran
                </Button>
            </div>
        </template>

        <div class="p-6 space-y-6">
            <!-- Form Card -->
            <div v-if="showForm" class="bg-white dark:bg-zinc-900 p-6 rounded-xl shadow-lg border border-zinc-200 dark:border-zinc-800 mb-6 animate-in slide-in-from-top-4">
                <h3 class="font-bold text-lg mb-4">Input Pengeluaran Baru</h3>
                <form @submit.prevent="submit" class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-bold text-zinc-700 dark:text-zinc-300 mb-1">Tanggal</label>
                        <input type="date" v-model="form.date" class="w-full rounded-lg border-zinc-300 dark:bg-zinc-800 dark:border-zinc-700" required />
                    </div>
                    <div>
                         <label class="block text-sm font-bold text-zinc-700 dark:text-zinc-300 mb-1">Jenis Pengeluaran</label>
                         <select v-model="form.account_code" class="w-full rounded-lg border-zinc-300 dark:bg-zinc-800 dark:border-zinc-700" required>
                             <option value="" disabled>Pilih Kategori</option>
                             <option v-for="acc in accounts" :key="acc.id" :value="acc.code">{{ acc.code }} - {{ acc.name }}</option>
                         </select>
                    </div>
                    <div class="md:col-span-2">
                        <Input label="Jumlah (Rp)" type="number" v-model="form.amount" placeholder="0" required />
                    </div>
                    <div class="md:col-span-2">
                         <Input label="Keterangan" v-model="form.description" placeholder="Contoh: Bayar Listrik Bulan Ini" required />
                    </div>
                    <div class="md:col-span-2 flex justify-end gap-2 mt-2">
                        <Button type="button" variant="ghost" @click="showForm = false">Batal</Button>
                        <Button type="submit" :loading="form.processing">Simpan</Button>
                    </div>
                </form>
            </div>

            <!-- Expense List -->
             <ContentBlock title="Riwayat Pengeluaran">
                <div class="overflow-x-auto">
                    <table class="w-full text-left">
                        <thead class="text-xs text-zinc-500 uppercase bg-zinc-50 dark:bg-zinc-800/50">
                            <tr>
                                <th class="px-4 py-3">Tanggal</th>
                                <th class="px-4 py-3">No. Ref</th>
                                <th class="px-4 py-3">Kategori</th>
                                <th class="px-4 py-3">Keterangan</th>
                                <th class="px-4 py-3 text-right">Jumlah</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-zinc-100 dark:divide-zinc-800">
                            <tr v-if="expenses.data.length === 0">
                                <td colspan="5" class="px-4 py-8 text-center text-zinc-500">Belum ada data pengeluaran.</td>
                            </tr>
                            <tr v-for="expense in expenses.data" :key="expense.id" class="hover:bg-zinc-50 dark:hover:bg-zinc-800/50 transition-colors">
                                <td class="px-4 py-3 whitespace-nowrap text-sm">{{ formatDate(expense.transaction_date) }}</td>
                                <td class="px-4 py-3 text-xs font-mono text-zinc-500">{{ expense.reference_number }}</td>
                                <td class="px-4 py-3 text-sm font-bold text-zinc-700 dark:text-zinc-300">
                                    {{ expense.items.find(i => i.debit > 0)?.account_name || 'Expense' }}
                                </td>
                                <td class="px-4 py-3 text-sm text-zinc-600 dark:text-zinc-400">{{ expense.description }}</td>
                                <td class="px-4 py-3 text-right font-bold text-rose-600">
                                    {{ formatCurrency(expense.items.find(i => i.debit > 0)?.debit || 0) }}
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                 <!-- Pagination -->
                <div class="mt-4 flex justify-between items-center text-sm text-zinc-500">
                     <span>Menampilkan {{ expenses.data.length }} dari {{ expenses.total }} data</span>
                     <div class="flex gap-2">
                        <template v-for="(link, k) in expenses.links" :key="k">
                            <div v-if="link.url === null" class="px-3 py-1 border rounded opacity-50" v-html="link.label" />
                            <Link v-else :href="link.url" class="px-3 py-1 border rounded hover:bg-zinc-100" :class="{'bg-brand-50 border-brand-200 text-brand-700': link.active}" v-html="link.label" />
                        </template>
                     </div>
                </div>
             </ContentBlock>
        </div>
    </MainLayout>
</template>
