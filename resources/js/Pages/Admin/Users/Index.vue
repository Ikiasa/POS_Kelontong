<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head, useForm, router } from '@inertiajs/vue3';
import { ref, watch } from 'vue';
import { 
    Users, UserPlus, Search, Edit2, Trash2, 
    Shield, Mail, Key, ShieldCheck, ShieldAlert,
    ChevronLeft, ChevronRight, X
} from 'lucide-vue-next';
import debounce from 'lodash/debounce';

const props = defineProps({
    users: Object,
    filters: Object
});

const search = ref(props.filters.search || '');
const showModal = ref(false);
const editingUser = ref(null);

const form = useForm({
    name: '',
    email: '',
    role: 'cashier',
    password: '',
});

const openModal = (user = null) => {
    editingUser.value = user;
    if (user) {
        form.name = user.name;
        form.email = user.email;
        form.role = user.role;
        form.password = '';
    } else {
        form.reset();
    }
    showModal.value = true;
};

const closeModal = () => {
    showModal.value = false;
    editingUser.value = null;
    form.reset();
};

const submit = () => {
    if (editingUser.value) {
        form.put(route('admin.users.update', editingUser.value.id), {
            onSuccess: () => closeModal(),
        });
    } else {
        form.post(route('admin.users.store'), {
            onSuccess: () => closeModal(),
        });
    }
};

const deleteUser = (user) => {
    if (confirm(`Are you sure you want to delete ${user.name}?`)) {
        router.delete(route('admin.users.destroy', user.id));
    }
};

watch(search, debounce((value) => {
    router.get(route('admin.users.index'), { search: value }, { preserveState: true, replace: true });
}, 300));

const getRoleBadge = (role) => {
    switch (role) {
        case 'owner': return 'bg-purple-100 text-purple-700 dark:bg-purple-900/30 dark:text-purple-400';
        case 'manager': return 'bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400';
        default: return 'bg-zinc-100 text-zinc-700 dark:bg-zinc-800 dark:text-zinc-400';
    }
};

const getRoleIcon = (role) => {
    switch (role) {
        case 'owner': return ShieldCheck;
        case 'manager': return Shield;
        default: return Users;
    }
};
</script>

<template>
    <Head title="User Management" />

    <MainLayout title="User Management">
        <div class="space-y-6 pb-20">
            <!-- Header Actions -->
            <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                <div>
                    <h2 class="text-xl font-black text-zinc-900 dark:text-white flex items-center gap-2">
                        <Users class="text-red-600" />
                        System Access Control
                    </h2>
                    <p class="text-sm text-zinc-500">Manage staff accounts and permissions</p>
                </div>
                <button @click="openModal()" 
                        class="bg-red-600 hover:bg-red-700 text-white px-6 h-11 rounded-xl flex items-center gap-2 font-bold shadow-lg shadow-red-600/20 transition-all">
                    <UserPlus :size="18" />
                    New Staff Account
                </button>
            </div>

            <!-- Search & Filters -->
            <div class="bg-white dark:bg-zinc-900 p-4 rounded-xl border border-zinc-200 dark:border-zinc-800 shadow-sm">
                <div class="relative max-w-md">
                    <Search class="absolute left-3 top-1/2 -translate-y-1/2 text-zinc-400" :size="18" />
                    <input v-model="search" type="text" placeholder="Search by name or email..."
                           class="w-full pl-10 h-11 bg-zinc-50 dark:bg-zinc-950 border-zinc-200 dark:border-zinc-800 rounded-lg focus:ring-2 focus:ring-red-500 text-sm">
                </div>
            </div>

            <!-- Users Grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <div v-for="user in users.data" :key="user.id" 
                     class="group bg-white dark:bg-zinc-900 rounded-2xl border border-zinc-200 dark:border-zinc-800 p-6 hover:shadow-xl hover:shadow-red-500/5 transition-all relative overflow-hidden">
                    
                    <div class="flex items-start justify-between mb-4">
                        <div class="w-12 h-12 bg-red-50 dark:bg-red-900/20 rounded-xl flex items-center justify-center text-red-600 dark:text-red-400 font-bold text-lg">
                            {{ user.name.charAt(0) }}
                        </div>
                        <span :class="['text-[10px] font-black uppercase tracking-widest px-2.5 py-1 rounded-full flex items-center gap-1.5', getRoleBadge(user.role)]">
                            <component :is="getRoleIcon(user.role)" :size="12" />
                            {{ user.role }}
                        </span>
                    </div>

                    <div class="space-y-1">
                        <h3 class="font-black text-zinc-900 dark:text-white truncate">{{ user.name }}</h3>
                        <div class="flex items-center gap-1.5 text-zinc-400 text-sm truncate">
                            <Mail :size="14" />
                            {{ user.email }}
                        </div>
                    </div>

                    <div class="mt-6 pt-4 border-t border-zinc-100 dark:border-zinc-800 flex items-center justify-between">
                        <div class="text-[10px] font-bold text-zinc-400 uppercase tracking-tighter">
                            Joined {{ new Date(user.created_at).toLocaleDateString() }}
                        </div>
                        <div class="flex items-center gap-2">
                            <button @click="openModal(user)" class="p-2 text-zinc-400 hover:text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition-colors">
                                <Edit2 :size="16" />
                            </button>
                            <button @click="deleteUser(user)" 
                                    :disabled="user.id === $page.props.auth.user.id"
                                    class="p-2 text-zinc-400 hover:text-red-500 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition-colors disabled:opacity-30">
                                <Trash2 :size="16" />
                            </button>
                        </div>
                    </div>

                    <!-- Decorative Background Icon -->
                    <component :is="getRoleIcon(user.role)" :size="80" 
                               class="absolute -right-6 -bottom-6 opacity-[0.03] text-zinc-900 dark:text-white pointer-events-none transition-transform group-hover:scale-110" />
                </div>
            </div>

            <!-- Pagination -->
            <div v-if="users.total > users.per_page" class="flex justify-center pt-8">
                <div class="flex bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-xl overflow-hidden shadow-sm">
                    <button v-for="link in users.links" :key="link.label"
                            @click="router.visit(link.url)"
                            :disabled="!link.url || link.active"
                            class="px-4 py-2 text-sm font-bold transition-colors disabled:opacity-50"
                            :class="link.active ? 'bg-indigo-600 text-white' : 'text-zinc-500 hover:bg-zinc-50 dark:hover:bg-zinc-800'"
                            v-html="link.label">
                    </button>
                </div>
            </div>
        </div>

        <!-- Create/Edit Modal -->
        <div v-if="showModal" class="fixed inset-0 z-50 flex items-center justify-center p-4">
            <div class="absolute inset-0 bg-zinc-950/60 backdrop-blur-sm" @click="closeModal"></div>
            <div class="relative bg-white dark:bg-zinc-900 w-full max-w-md rounded-2xl shadow-2xl overflow-hidden animate-in fade-in zoom-in duration-200">
                <div class="px-6 py-4 border-b border-zinc-100 dark:border-zinc-800 flex items-center justify-between">
                    <h3 class="font-black text-zinc-900 dark:text-white uppercase tracking-widest text-sm flex items-center gap-2">
                        <Key :size="16" class="text-red-600" />
                        {{ editingUser ? 'Modify Account' : 'New Account' }}
                    </h3>
                    <button @click="closeModal" class="text-zinc-400 hover:text-zinc-900 dark:hover:text-white transition-colors">
                        <X :size="20" />
                    </button>
                </div>

                <form @submit.prevent="submit" class="p-6 space-y-5">
                    <div class="space-y-2">
                        <label class="text-[10px] font-black text-zinc-400 uppercase tracking-widest">Full Name</label>
                        <input v-model="form.name" type="text" required placeholder="Staff Name"
                               class="w-full h-11 bg-zinc-50 dark:bg-zinc-950 border-zinc-200 dark:border-zinc-800 rounded-lg focus:ring-2 focus:ring-indigo-500 text-sm">
                    </div>

                    <div class="space-y-2">
                        <label class="text-[10px] font-black text-zinc-400 uppercase tracking-widest">Email Address</label>
                        <input v-model="form.email" type="email" required placeholder="staff@example.com"
                               class="w-full h-11 bg-zinc-50 dark:bg-zinc-950 border-zinc-200 dark:border-zinc-800 rounded-lg focus:ring-2 focus:ring-indigo-500 text-sm">
                    </div>

                    <div class="grid grid-cols-2 gap-4">
                        <div class="space-y-2">
                            <label class="text-[10px] font-black text-zinc-400 uppercase tracking-widest">Access Role</label>
                            <select v-model="form.role" required
                                    class="w-full h-11 bg-zinc-50 dark:bg-zinc-950 border-zinc-200 dark:border-zinc-800 rounded-lg focus:ring-2 focus:ring-indigo-500 text-sm">
                                <option value="owner">Owner</option>
                                <option value="manager">Manager</option>
                                <option value="cashier">Cashier</option>
                            </select>
                        </div>
                        <div class="space-y-2">
                            <label class="text-[10px] font-black text-zinc-400 uppercase tracking-widest">Password</label>
                            <input v-model="form.password" type="password" :required="!editingUser" :placeholder="editingUser ? 'Leave blank to keep' : 'Min 6 chars'"
                                   class="w-full h-11 bg-zinc-50 dark:bg-zinc-950 border-zinc-200 dark:border-zinc-800 rounded-lg focus:ring-2 focus:ring-indigo-500 text-sm">
                        </div>
                    </div>

                    <div v-if="form.errors.email || form.errors.password" class="p-3 bg-red-50 dark:bg-red-900/10 rounded-lg border border-red-100 dark:border-red-900/20">
                        <ul class="text-[10px] font-bold text-red-600 dark:text-red-400 space-y-1">
                            <li v-if="form.errors.email">{{ form.errors.email }}</li>
                            <li v-if="form.errors.password">{{ form.errors.password }}</li>
                        </ul>
                    </div>

                    <button type="submit" :disabled="form.processing"
                            class="w-full h-11 bg-red-600 hover:bg-red-700 text-white rounded-xl font-black uppercase tracking-widest text-xs shadow-lg shadow-red-600/20 transition-all disabled:opacity-50">
                        {{ editingUser ? 'Update Account' : 'Initialize Account' }}
                    </button>
                </form>
            </div>
        </div>
    </MainLayout>
</template>
