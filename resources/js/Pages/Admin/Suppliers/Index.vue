<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head, Link, useForm, router } from '@inertiajs/vue3';
import { ref, watch } from 'vue';
import { 
    Factory, Phone, Mail, Plus, Search, 
    MoreVertical, Edit2, Trash2, MapPin, 
    User, ChevronRight, X 
} from 'lucide-vue-next';
import debounce from 'lodash/debounce';

const props = defineProps({
    suppliers: Object,
    filters: Object,
    flash: Object
});

const search = ref(props.filters.search || '');
const showModal = ref(false);
const isEditing = ref(false);
const editingId = ref(null);

const form = useForm({
    name: '',
    contact_person: '',
    phone: '',
    email: '',
    address: '',
    default_lead_time_days: 3,
    minimum_order_value: 0
});

const openModal = (supplier = null) => {
    if (supplier) {
        isEditing.value = true;
        editingId.value = supplier.id;
        form.name = supplier.name;
        form.contact_person = supplier.contact_person;
        form.phone = supplier.phone;
        form.email = supplier.email;
        form.address = supplier.address;
        form.default_lead_time_days = supplier.default_lead_time_days;
        form.minimum_order_value = supplier.minimum_order_value;
    } else {
        isEditing.value = false;
        editingId.value = null;
        form.reset();
    }
    showModal.value = true;
};

const closeModal = () => {
    showModal.value = false;
    form.reset();
};

const submit = () => {
    if (isEditing.value) {
        form.put(route('admin.suppliers.update', editingId.value), {
            onSuccess: () => closeModal(),
        });
    } else {
        form.post(route('admin.suppliers.store'), {
            onSuccess: () => closeModal(),
        });
    }
};

const confirmDelete = (id) => {
    if (confirm('Are you sure you want to delete this supplier?')) {
        router.delete(route('admin.suppliers.destroy', id));
    }
};

const performSearch = debounce((q) => {
    router.get(route('admin.suppliers.index'), { search: q }, { 
        preserveState: true, 
        replace: true 
    });
}, 300);

watch(search, (newVal) => performSearch(newVal));

const formatCurrency = (val) => new Intl.NumberFormat('id-ID', { style: 'currency', currency: 'IDR', minimumFractionDigits: 0 }).format(val);
</script>

<template>
    <Head title="Suppliers" />

    <MainLayout title="Supplier Management">
        <div class="space-y-6">
            <!-- Header Actions -->
            <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div class="relative flex-1 max-w-md">
                    <Search class="absolute left-3 top-1/2 -translate-y-1/2 text-zinc-400" :size="18" />
                    <input v-model="search" type="text" placeholder="Search suppliers or contacts..."
                           class="w-full pl-10 h-11 bg-zinc-50 dark:bg-zinc-950 border-zinc-200 dark:border-zinc-800 rounded-lg focus:ring-2 focus:ring-red-500 text-sm">
                </div>
                <button @click="openModal()" 
                        class="bg-red-600 hover:bg-red-700 text-white px-6 h-11 rounded-xl flex items-center gap-2 font-bold shadow-lg shadow-red-600/20 transition-all">
                    <Plus :size="20" />
                    Add Supplier
                </button>
            </div>

            <!-- Suppliers Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <div v-for="s in suppliers.data" :key="s.id" 
                     class="group bg-white dark:bg-zinc-900 rounded-2xl border border-zinc-200 dark:border-zinc-800 p-6 hover:shadow-xl hover:shadow-red-500/5 transition-all relative overflow-hidden">
                    <div class="flex items-start justify-between mb-4">
                        <div class="w-12 h-12 bg-red-50 dark:bg-red-900/20 rounded-xl flex items-center justify-center text-red-600 dark:text-red-400 font-bold text-lg">
                            {{ s.name.charAt(0) }}
                        </div>
                        <div class="flex items-center gap-2">
                            <button @click="openModal(s)" class="p-2 text-zinc-400 hover:text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition-colors">
                                <Edit2 :size="16" />
                            </button>
                            <button @click="confirmDelete(s.id)" class="p-2 text-zinc-400 hover:text-red-500 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition-colors">
                                <Trash2 :size="16" />
                            </button>
                        </div>
                    </div>

                    <h3 class="text-lg font-bold text-zinc-900 dark:text-white mb-1">{{ s.name }}</h3>
                    <div class="flex items-center gap-2 text-zinc-500 text-sm mb-4">
                        <User :size="14" />
                        {{ s.contact_person || 'No contact' }}
                    </div>

                    <div class="space-y-3 pt-4 border-t border-zinc-100 dark:border-zinc-800">
                        <div v-if="s.phone" class="flex items-center gap-3 text-sm text-zinc-600 dark:text-zinc-400">
                            <Phone :size="16" class="text-zinc-400" />
                            {{ s.phone }}
                        </div>
                        <div v-if="s.email" class="flex items-center gap-3 text-sm text-zinc-600 dark:text-zinc-400">
                            <Mail :size="16" class="text-zinc-400" />
                            {{ s.email }}
                        </div>
                        <div v-if="s.address" class="flex items-start gap-3 text-sm text-zinc-600 dark:text-zinc-400">
                            <MapPin :size="16" class="text-zinc-400 mt-0.5" />
                            <span class="line-clamp-2">{{ s.address }}</span>
                        </div>
                    </div>

                    <div class="mt-6 flex items-center justify-between pt-4 border-t border-dashed border-zinc-100 dark:border-zinc-800">
                        <div>
                            <div class="text-[10px] uppercase font-black text-zinc-400 tracking-wider">Lead Time</div>
                            <div class="font-bold text-zinc-900 dark:text-white">{{ s.default_lead_time_days }} Days</div>
                        </div>
                        <div class="text-right">
                            <div class="text-[10px] uppercase font-black text-zinc-400 tracking-wider">Min. Order</div>
                            <div class="font-bold text-emerald-600">{{ formatCurrency(s.minimum_order_value) }}</div>
                        </div>
                    </div>
                </div>

                <div v-if="suppliers.data.length === 0" class="col-span-full py-20 text-center">
                    <div class="w-20 h-20 bg-zinc-50 dark:bg-zinc-900 rounded-full flex items-center justify-center mx-auto mb-4 border-2 border-dashed border-zinc-200 dark:border-zinc-800">
                        <Search :size="32" class="text-zinc-300" />
                    </div>
                    <h3 class="text-zinc-600 dark:text-zinc-400 font-medium">No suppliers found</h3>
                    <p class="text-zinc-400 text-sm">Try adjusting your search or add a new supplier.</p>
                </div>
            </div>

            <!-- Pagination -->
            <div v-if="suppliers.links.length > 3" class="flex justify-center pt-8">
                <div class="flex gap-2">
                    <button v-for="link in suppliers.links" :key="link.label"
                            @click="link.url && router.visit(link.url)"
                            v-html="link.label"
                            :disabled="!link.url"
                            class="px-4 py-2 text-sm rounded-xl border transition-all"
                            :class="link.active 
                                ? 'bg-red-600 border-red-600 text-white font-bold shadow-lg shadow-red-600/20' 
                                : 'border-zinc-200 dark:border-zinc-800 text-zinc-600 dark:text-zinc-400 hover:bg-zinc-50 dark:hover:bg-zinc-800 disabled:opacity-30'">
                    </button>
                </div>
            </div>

            <!-- Add/Edit Modal -->
            <div v-if="showModal" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-zinc-950/50 backdrop-blur-sm">
                <div class="bg-white dark:bg-zinc-900 w-full max-w-lg rounded-3xl shadow-2xl overflow-hidden animate-in fade-in zoom-in duration-200">
                    <div class="p-6 border-b border-zinc-100 dark:border-zinc-800 flex items-center justify-between">
                        <h2 class="text-xl font-black text-zinc-900 dark:text-white flex items-center gap-2">
                            <Truck class="text-red-600" />
                            Supplier Management
                        </h2>
                        <button @click="closeModal" class="p-2 hover:bg-zinc-100 dark:hover:bg-zinc-800 rounded-full transition-colors">
                            <X :size="20" class="text-zinc-400" />
                        </button>
                    </div>
                    <form @submit.prevent="submit" class="p-6 space-y-4">
                        <div class="col-span-2 space-y-1">
                            <label class="text-[10px] font-black text-zinc-400 uppercase tracking-widest">Supplier Name</label>
                            <input v-model="form.name" type="text" required placeholder="PT. Supplier Jaya"
                                class="w-full h-11 bg-zinc-50 dark:bg-zinc-950 border-zinc-200 dark:border-zinc-800 rounded-lg focus:ring-2 focus:ring-red-500 text-sm">
                        </div>

                        <div class="space-y-2">
                            <label class="text-[10px] font-black text-zinc-400 uppercase tracking-widest">Contact Person</label>
                            <input v-model="form.contact_person" type="text" placeholder="Mr. Budi"
                                class="w-full h-11 bg-zinc-50 dark:bg-zinc-950 border-zinc-200 dark:border-zinc-800 rounded-lg focus:ring-2 focus:ring-red-500 text-sm">
                        </div>

                        <div class="grid grid-cols-2 gap-4">
                            <div class="space-y-2">
                                <label class="text-[10px] font-black text-zinc-400 uppercase tracking-widest">Phone</label>
                                <input v-model="form.phone" type="text" placeholder="081..."
                                    class="w-full h-11 bg-zinc-50 dark:bg-zinc-950 border-zinc-200 dark:border-zinc-800 rounded-lg focus:ring-2 focus:ring-red-500 text-sm">
                            </div>
                            <div class="space-y-2">
                                <label class="text-[10px] font-black text-zinc-400 uppercase tracking-widest">Email</label>
                                <input v-model="form.email" type="email" placeholder="sales@supplier.com"
                                    class="w-full h-11 bg-zinc-50 dark:bg-zinc-950 border-zinc-200 dark:border-zinc-800 rounded-lg focus:ring-2 focus:ring-red-500 text-sm">
                            </div>
                        </div>        
                        <div class="col-span-2 space-y-1">
                            <label class="text-xs font-bold text-zinc-500 uppercase">Address</label>
                            <textarea v-model="form.address" rows="2"
                                class="w-full px-4 py-3 bg-zinc-50 dark:bg-zinc-950 border-zinc-200 dark:border-zinc-800 rounded-xl focus:ring-2 focus:ring-red-500 transition-all"></textarea>
                        </div>
                        <div class="space-y-1">
                            <label class="text-xs font-bold text-zinc-500 uppercase">Default Lead Time (Days)</label>
                            <input v-model.number="form.default_lead_time_days" type="number" min="0" required
                                class="w-full h-11 px-4 bg-zinc-50 dark:bg-zinc-950 border-zinc-200 dark:border-zinc-800 rounded-xl focus:ring-2 focus:ring-red-500 transition-all">
                        </div>
                        <div class="space-y-1">
                            <label class="text-xs font-bold text-zinc-500 uppercase">Min. Order Value</label>
                            <input v-model.number="form.minimum_order_value" type="number" min="0" required
                                class="w-full h-11 px-4 bg-zinc-50 dark:bg-zinc-950 border-zinc-200 dark:border-zinc-800 rounded-xl focus:ring-2 focus:ring-red-500 transition-all">
                        </div>
                        <div class="pt-6 flex gap-3">
                            <button type="button" @click="closeModal"
                                    class="flex-1 h-12 bg-zinc-100 dark:bg-zinc-800 text-zinc-600 dark:text-zinc-400 font-bold rounded-xl hover:bg-zinc-200 dark:hover:bg-zinc-700 transition-all">
                                Cancel
                            </button>
                            <button type="submit" :disabled="form.processing"
                            class="w-full h-11 bg-red-600 hover:bg-red-700 text-white rounded-xl font-black uppercase tracking-widest text-xs shadow-lg shadow-red-600/20 transition-all disabled:opacity-50">
                        {{ isEditing ? 'Update Supplier' : 'Create Supplier' }}
                    </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </MainLayout>
</template>
