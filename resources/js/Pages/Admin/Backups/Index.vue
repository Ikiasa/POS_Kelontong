<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head, router, usePage } from '@inertiajs/vue3';
import { 
    Database, Download, Trash2, RefreshCcw, 
    Save, HardDrive, HardDriveDownload, HardDriveUpload,
    CheckCircle2, AlertCircle, Clock, Info, ShieldAlert
} from 'lucide-vue-next';
import { computed } from 'vue';

const props = defineProps({
    backups: Array
});

const page = usePage();
const flashSuccess = computed(() => page.props.flash?.success);
const flashError = computed(() => page.props.flash?.error);

const createBackup = () => {
    router.post(route('backups.store'), {}, {
        onBefore: () => confirm('This will generate a full database snapshot. Proceed?'),
    });
};

const restoreBackup = (filename) => {
    if (confirm(`RESTORE WARNING: This will overwrite CURRENT database state with data from ${filename}. This action CANNOT BE UNDONE. Continue?`)) {
        router.post(route('backups.restore', filename));
    }
};

const deleteBackup = (filename) => {
    if (confirm(`Permanently delete backup file: ${filename}?`)) {
        router.delete(route('backups.destroy', filename));
    }
};

const formatSize = (bytes) => {
    const kb = bytes / 1024;
    return kb.toFixed(2) + ' KB';
};

const formatDate = (dateStr) => {
    const date = new Date(dateStr);
    return date.toLocaleString();
};

const getRelativeTime = (dateStr) => {
    const date = new Date(dateStr);
    const now = new Date();
    const diff = Math.floor((now - date) / 1000);
    
    if (diff < 60) return 'Just now';
    if (diff < 3600) return `${Math.floor(diff / 60)}m ago`;
    if (diff < 86400) return `${Math.floor(diff / 3600)}h ago`;
    return `${Math.floor(diff / 86400)}d ago`;
};
</script>

<template>
    <Head title="System Backups" />

    <MainLayout title="System Reliability">
        <div class="space-y-8 pb-20">
            <!-- Header Section -->
            <div class="flex flex-col md:flex-row md:items-center justify-between gap-6">
                <div class="space-y-1">
                    <h2 class="text-xl font-black text-zinc-900 dark:text-white flex items-center gap-2">
                    <DatabaseBackup class="text-red-600" />
                    System Backups
                </h2>
                    <p class="text-zinc-500">Secure automated snapshots and data recovery control</p>
                </div>
                
                <button @click="createBackup" :disabled="isCreating"
                        class="bg-red-600 hover:bg-red-700 text-white px-6 h-11 rounded-xl flex items-center gap-2 font-bold shadow-lg shadow-red-600/20 transition-all disabled:opacity-70">
                    <Plus v-if="!isCreating" :size="18" />
                    <Loader2 v-else class="animate-spin" :size="18" />
                    {{ isCreating ? 'Creating Backup...' : 'Create New Backup' }}
                </button>
            </div>

            <!-- System Health Widget (Simplified) -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div class="bg-white dark:bg-zinc-900 p-6 rounded-2xl border border-zinc-200 dark:border-zinc-800 shadow-sm flex items-center gap-4">
                    <div class="p-4 bg-emerald-50 dark:bg-emerald-900/20 text-emerald-600 dark:text-emerald-400 rounded-2xl">
                        <CheckCircle2 :size="24" />
                    </div>
                    <div>
                        <div class="text-[10px] font-black text-zinc-400 uppercase tracking-widest mb-1">DB Status</div>
                        <div class="text-xl font-bold dark:text-white">Active (PGSql)</div>
                    </div>
                </div>

                <div class="bg-white dark:bg-zinc-900 p-6 rounded-2xl border border-zinc-200 dark:border-zinc-800 shadow-sm flex items-center gap-4">
                    <div class="p-4 bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 rounded-2xl">
                        <HardDrive :size="24" />
                    </div>
                    <div>
                        <div class="text-[10px] font-black text-zinc-400 uppercase tracking-widest mb-1">Total Backups</div>
                        <div class="text-xl font-bold dark:text-white">{{ backups.length }} Archives</div>
                    </div>
                </div>

                <div class="bg-white dark:bg-zinc-900 p-6 rounded-2xl border border-zinc-200 dark:border-zinc-800 shadow-sm flex items-center gap-4">
                    <div class="p-4 bg-amber-50 dark:bg-amber-900/20 text-amber-600 dark:text-amber-400 rounded-2xl">
                        <Clock :size="24" />
                    </div>
                    <div>
                        <div class="text-[10px] font-black text-zinc-400 uppercase tracking-widest mb-1">Retention Policy</div>
                        <div class="text-xl font-bold dark:text-white">Persistent</div>
                    </div>
                </div>
            </div>

            <!-- Notifications -->
            <div v-if="flashSuccess" class="p-4 bg-emerald-50 dark:bg-emerald-900/20 border border-emerald-100 dark:border-emerald-800 rounded-2xl flex items-center gap-3 text-emerald-700 dark:text-emerald-400 font-bold">
                 <CheckCircle2 :size="20" />
                 {{ flashSuccess }}
            </div>
             <div v-if="flashError" class="p-4 bg-red-50 dark:bg-red-900/20 border border-red-100 dark:border-red-800 rounded-2xl flex items-center gap-3 text-red-700 dark:text-red-400 font-bold">
                 <ShieldAlert :size="20" />
                 {{ flashError }}
            </div>

            <!-- Backups Table -->
            <div class="bg-white dark:bg-zinc-900 rounded-2xl border border-zinc-200 dark:border-zinc-800 shadow-sm overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead>
                            <tr class="bg-zinc-50 dark:bg-zinc-950 border-b border-zinc-200 dark:border-zinc-800">
                                <th class="px-6 py-4 text-left text-[10px] font-black text-zinc-400 uppercase tracking-widest">Archive Filename</th>
                                <th class="px-6 py-4 text-left text-[10px] font-black text-zinc-400 uppercase tracking-widest">Recorded On</th>
                                <th class="px-6 py-4 text-left text-[10px] font-black text-zinc-400 uppercase tracking-widest">File Size</th>
                                <th class="px-6 py-4 text-right text-[10px] font-black text-zinc-400 uppercase tracking-widest">Actions</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-zinc-100 dark:divide-zinc-800">
                            <tr v-for="backup in backups" :key="backup.name" class="group hover:bg-zinc-50 dark:hover:bg-zinc-950/50 transition-colors">
                                <td class="px-6 py-4">
                                    <div class="flex items-center gap-3">
                                        <div class="p-2 bg-zinc-100 dark:bg-zinc-800 text-zinc-500 rounded-lg group-hover:bg-red-50 dark:group-hover:bg-red-900/20 group-hover:text-red-600 transition-colors">
                                            <Database :size="16" />
                                        </div>
                                        <span class="font-mono text-xs text-zinc-900 dark:text-zinc-100 font-bold">{{ backup.name }}</span>
                                    </div>
                                </td>
                                <td class="px-6 py-4">
                                    <div class="text-sm dark:text-zinc-300">{{ formatDate(backup.date) }}</div>
                                    <div class="text-[10px] font-bold text-zinc-400 uppercase">{{ getRelativeTime(backup.date) }}</div>
                                </td>
                                <td class="px-6 py-4">
                                    <div class="text-xs font-black text-zinc-600 dark:text-zinc-400">{{ formatSize(backup.size) }}</div>
                                </td>
                                <td class="px-6 py-4">
                                    <div class="flex items-center justify-end gap-2">
                                        <button @click="downloadBackup(backup)" 
                                    class="p-2 text-zinc-400 hover:text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition-colors"
                                    title="Download Backup">
                                <Download :size="18" />
                            </button>
                                        <button @click="restoreBackup(backup.name)"
                                                class="p-2 text-zinc-400 hover:text-emerald-500 hover:bg-emerald-50 dark:hover:bg-emerald-900/20 rounded-lg transition-all"
                                                title="Restore System State">
                                            <RefreshCcw :size="18" />
                                        </button>
                                        <button @click="deleteBackup(backup.name)"
                                                class="p-2 text-zinc-400 hover:text-red-500 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-lg transition-all"
                                                title="Delete Archive">
                                            <Trash2 :size="18" />
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <tr v-if="backups.length === 0">
                                <td colspan="4" class="px-6 py-12 text-center text-zinc-400 italic text-sm">
                                    No backup archives found on local storage.
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Caution Panel -->
            <div class="bg-amber-50 dark:bg-amber-900/10 border border-amber-100 dark:border-amber-900/20 p-6 rounded-2xl flex items-start gap-4">
                <ShieldAlert class="text-amber-600 shrink-0" :size="24" />
                <div class="space-y-1">
                    <h4 class="font-black text-amber-900 dark:text-amber-400 text-sm uppercase tracking-widest">Disaster Recovery Note</h4>
                    <p class="text-xs text-amber-700 dark:text-amber-500/80 leading-relaxed font-bold">
                        Database restoration is a high-risk operation. Ensure you have a current export before attempting to restore an older archive.
                        Backups are currently stored at <code class="bg-amber-100 dark:bg-amber-900/40 px-1 rounded">storage/app/backups</code>.
                    </p>
                </div>
            </div>
        </div>
    </MainLayout>
</template>
