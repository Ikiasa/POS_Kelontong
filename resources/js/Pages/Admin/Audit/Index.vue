<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head, router } from '@inertiajs/vue3';
import { ref, watch } from 'vue';
import { 
    ShieldCheck, AlertTriangle, Clock, Search, 
    User, Filter, CheckCircle2, XCircle, ChevronDown,
    Calendar as CalendarIcon, Activity, ArrowDownRight, ArrowUpRight
} from 'lucide-vue-next';
import debounce from 'lodash/debounce';

const props = defineProps({
    logs: Object,
    alerts: Array,
    users: Array,
    filters: Object
});

const filters = ref({
    user_id: props.filters.user_id || '',
    action: props.filters.action || '',
    date: props.filters.date || ''
});

const updateFilters = debounce(() => {
    router.get(route('audit.index'), filters.value, { preserveState: true, replace: true });
}, 300);

watch(filters, updateFilters, { deep: true });

const resolveAlert = (id) => {
    if (confirm('Mark this alert as resolved?')) {
        router.put(route('audit.resolve', id));
    }
};

const getSeverityClass = (severity) => {
    switch (severity) {
        case 'high': return 'bg-red-100 text-red-700 dark:bg-red-900/40 dark:text-red-400 border-red-200 dark:border-red-800';
        case 'medium': return 'bg-yellow-100 text-yellow-700 dark:bg-yellow-900/40 dark:text-yellow-400 border-yellow-200 dark:border-yellow-800';
        default: return 'bg-blue-100 text-blue-700 dark:bg-blue-900/40 dark:text-blue-400 border-blue-200 dark:border-blue-800';
    }
};

const getActionIcon = (action) => {
    if (action.includes('Login')) return Clock;
    if (action.includes('Delete')) return XCircle;
    if (action.includes('Create') || action.includes('Update')) return CheckCircle2;
    return ShieldCheck;
};

const resetFilters = () => {
    filters.value = { user_id: '', action: '', date: '' };
};
</script>

<template>
    <Head title="Security & Audit" />

    <MainLayout title="Security Intelligence">
        <div class="space-y-8 pb-20">
            <!-- Header -->
            <div class="flex items-center justify-between">
                <div>
                    <h2 class="text-xl font-black text-zinc-900 dark:text-white flex items-center gap-2">
                    <Activity class="text-red-600" />
                    Audit Logs
                </h2>
                    <p class="text-zinc-500">Real-time threat detection and staff activity tracking</p>
                </div>
            </div>

            <!-- Fraud Alerts -->
            <section class="space-y-4">
                <h3 class="text-sm font-black uppercase tracking-widest text-zinc-400 flex items-center gap-2">
                    <AlertTriangle :size="16" class="text-amber-500" />
                    Suspicious Activity Alerts
                </h3>

                <div v-if="alerts.length > 0" class="grid grid-cols-1 gap-4">
                    <div v-for="alert in alerts" :key="alert.id"
                         :class="['p-4 rounded-2xl border-l-8 border shadow-sm flex flex-col md:flex-row justify-between items-start md:items-center gap-4 transition-all', 
                                  alert.resolved ? 'opacity-50 grayscale border-zinc-200 dark:border-zinc-800' : getSeverityClass(alert.severity)]">
                        
                        <div class="flex-1 space-y-1">
                            <div class="flex items-center gap-3">
                                <span class="font-black text-lg">{{ alert.rule_name }}</span>
                                <span :class="['text-[10px] font-black uppercase tracking-widest px-2 py-0.5 rounded-full border', getSeverityClass(alert.severity)]">
                                    {{ alert.severity }}
                                </span>
                                <span v-if="alert.resolved" class="bg-emerald-100 text-emerald-800 dark:bg-emerald-900/40 dark:text-emerald-400 text-[10px] font-black px-2 py-0.5 rounded-full uppercase tracking-widest">
                                    Resolved
                                </span>
                            </div>
                            <p class="text-sm opacity-80">{{ alert.description }}</p>
                            <div class="flex items-center gap-4 text-[10px] font-bold uppercase tracking-tight opacity-60">
                                <span>By: {{ alert.user?.name || 'System' }}</span>
                                <span>|</span>
                                <span>{{ new Date(alert.created_at).toLocaleString() }}</span>
                                <span>|</span>
                                <span>Ref: {{ alert.reference_id }}</span>
                            </div>
                        </div>

                        <button v-if="!alert.resolved" @click="resolveAlert(alert.id)"
                                class="whitespace-nowrap bg-white dark:bg-zinc-800 text-zinc-900 dark:text-white px-4 py-2 rounded-xl text-xs font-black uppercase tracking-widest shadow-sm border border-zinc-200 dark:border-zinc-700 hover:scale-105 active:scale-95 transition-all">
                            Resolve Alert
                        </button>
                    </div>
                </div>
                <div v-else class="p-8 bg-emerald-50 dark:bg-emerald-900/10 border border-emerald-100 dark:border-emerald-900/20 rounded-2xl text-center">
                    <CheckCircle2 class="text-emerald-500 mx-auto mb-2" :size="32" />
                    <p class="text-emerald-700 dark:text-emerald-400 font-bold">No active security alerts. System is operating safely.</p>
                </div>
            </section>

            <!-- Audit Timeline -->
            <section class="space-y-4">
                <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                    <h3 class="text-sm font-black uppercase tracking-widest text-zinc-400 flex items-center gap-2">
                        <Clock :size="16" />
                        Staff Activity Timeline
                    </h3>

                    <!-- Filters -->
                    <div class="flex flex-wrap items-center gap-3 bg-zinc-100 dark:bg-zinc-800 p-2 rounded-2xl border border-zinc-200 dark:border-zinc-700">
                        <select v-model="filters.user_id" 
                            class="h-11 px-4 bg-white dark:bg-zinc-900 border-zinc-200 dark:border-zinc-800 rounded-xl text-sm focus:ring-2 focus:ring-red-500 font-bold text-zinc-600">
                        <option value="">All Users</option>
                        <option v-for="user in users" :key="user.id" :value="user.id">{{ user.name }}</option>
                    </select>
                    <select v-model="filters.action" 
                            class="h-11 px-4 bg-white dark:bg-zinc-900 border-zinc-200 dark:border-zinc-800 rounded-xl text-sm focus:ring-2 focus:ring-red-500 font-bold text-zinc-600">
                        <option value="">All Events</option>
                        <option value="created">Created</option>
                        <option value="updated">Updated</option>
                        <option value="deleted">Deleted</option>
                        <option value="login">Login</option>
                    </select>
                        <div class="h-4 w-px bg-zinc-300 dark:bg-zinc-600"></div>
                        <input v-model="filters.date" type="date" class="bg-transparent border-none text-xs font-bold focus:ring-0">
                        <button v-if="filters.user_id || filters.action || filters.date" @click="resetFilters" class="p-1 hover:text-red-500 transition-colors">
                            <XCircle :size="16" />
                        </button>
                    </div>
                </div>

                <div class="relative space-y-6 before:absolute before:left-[19px] before:top-4 before:bottom-4 before:w-px before:bg-zinc-200 dark:before:bg-zinc-800">
                    <div v-for="log in logs.data" :key="log.id" class="relative pl-12 group">
                        <!-- Timeline Pin -->
                        <div :class="['absolute left-0 top-1 w-10 h-10 rounded-full border-4 border-white dark:border-zinc-950 shadow-sm flex items-center justify-center transition-transform group-hover:scale-110 z-10', 
                                    log.action.includes('Login') ? 'bg-blue-500 text-white' : 
                                    log.action.includes('Delete') ? 'bg-red-500 text-white' : 'bg-zinc-200 dark:bg-zinc-800 text-zinc-600 dark:text-zinc-400']">
                            <component :is="getActionIcon(log.action)" :size="18" />
                        </div>

                        <div class="bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 p-5 rounded-2xl shadow-sm hover:shadow-xl hover:shadow-indigo-500/5 transition-all">
                            <div class="flex flex-col md:flex-row justify-between items-start gap-2 mb-3">
                                <div>
                                    <h4 class="font-black text-zinc-900 dark:text-white text-lg">{{ log.action }}</h4>
                                    <div class="flex items-center gap-3 text-xs text-zinc-500 font-bold uppercase tracking-tight">
                                        <span class="flex items-center gap-1"><User :size="12" /> {{ log.user?.name || 'System' }}</span>
                                        <span>•</span>
                                        <span>IP: {{ log.ip_address }}</span>
                                    </div>
                                </div>
                                <div class="text-right">
                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800 dark:bg-red-800/20 dark:text-red-400">
                                {{ (log.auditable_type || '').split('\\').pop() }} #{{ log.auditable_id }}
                            </span>
                        </div>
                                <span class="text-xs font-black text-indigo-600 bg-indigo-50 dark:bg-indigo-900/20 px-3 py-1 rounded-full">
                                    {{ new Date(log.created_at).toLocaleTimeString() }}
                                </span>
                            </div>

                            <!-- Data Diff (if exists) -->
                            <div v-if="log.old_values || log.new_values" class="mt-4 grid grid-cols-1 md:grid-cols-2 gap-4 bg-zinc-50 dark:bg-zinc-950 p-4 rounded-xl border border-zinc-100 dark:border-zinc-800 font-mono text-[10px] overflow-hidden">
                                <div class="space-y-2">
                                    <span class="text-red-500 font-black uppercase tracking-widest flex items-center gap-1">
                                        <ArrowDownRight :size="10" /> Before
                                    </span>
                                    <div v-if="log.old_values" class="space-y-1">
                                        <div v-for="(val, key) in log.old_values" :key="key" class="truncate border-b border-zinc-200/50 dark:border-zinc-800/50 pb-1">
                                            <span class="text-zinc-600 dark:text-zinc-400">{{ key }}:</span> {{ val }}
                                        </div>
                                    </div>
                                    <div v-else class="text-zinc-400 italic">No previous state</div>
                                </div>
                                <div class="space-y-2">
                                    <span class="text-emerald-500 font-black uppercase tracking-widest flex items-center gap-1">
                                        <ArrowUpRight :size="10" /> After
                                    </span>
                                    <div v-if="log.new_values" class="space-y-1">
                                        <div v-for="(val, key) in log.new_values" :key="key" class="truncate border-b border-zinc-200/50 dark:border-zinc-800/50 pb-1">
                                            <span class="text-zinc-600 dark:text-zinc-400">{{ key }}:</span> {{ val }}
                                        </div>
                                    </div>
                                    <div v-else class="text-zinc-400 italic">No new state</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Pagination -->
                <div v-if="logs.total > logs.per_page" class="flex justify-center pt-8">
                    <div class="flex bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 rounded-xl overflow-hidden shadow-sm">
                        <button v-for="link in logs.links" :key="link.label"
                                @click="router.visit(link.url)"
                                :disabled="!link.url || link.active"
                                class="px-4 py-2 text-sm font-bold transition-colors disabled:opacity-50"
                                :class="link.active ? 'bg-indigo-600 text-white' : 'text-zinc-500 hover:bg-zinc-50 dark:hover:bg-zinc-800'"
                                v-html="link.label">
                        </button>
                    </div>
                </div>
            </section>
        </div>
    </MainLayout>
</template>
