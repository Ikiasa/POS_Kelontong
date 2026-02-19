<script setup>
import { Link } from '@inertiajs/vue3';
import { 
    LayoutDashboard, Monitor, Package, User, LogOut, 
    AlertTriangle, Box, Truck, Factory, ShoppingCart, 
    Banknote, PieChart, FileText, BarChart3, Sparkles,
    BookOpen, ClipboardList, ShieldCheck, Database, Key, Users,
    Sun, Moon
} from 'lucide-vue-next';
import { ref, onMounted } from 'vue';

defineProps({
    title: String,
});

const isDark = ref(false);

onMounted(() => {
    isDark.value = document.documentElement.classList.contains('dark');
});

const toggleTheme = () => {
    isDark.value = !isDark.value;
    if (isDark.value) {
        document.documentElement.classList.add('dark');
        document.documentElement.style.colorScheme = 'dark';
        localStorage.setItem('theme', 'dark');
    } else {
        document.documentElement.classList.remove('dark');
        document.documentElement.style.colorScheme = 'light';
        localStorage.setItem('theme', 'light');
    }
};
</script>

<template>
    <div class="flex h-screen w-full bg-white dark:bg-dark-bg text-zinc-900 dark:text-white font-sans antialiased">
        <!-- Sidebar -->
        <aside class="w-64 flex flex-col bg-dark-bg text-white shrink-0 transition-all duration-300 shadow-xl z-20 border-r border-zinc-800">
            <!-- Logo -->
            <div class="h-16 flex items-center gap-3 px-6 border-b border-zinc-900 shadow-sm relative z-10">
                <div class="w-8 h-8 bg-gradient-to-br from-brand-600 to-brand-800 rounded-lg flex items-center justify-center text-white font-bold shadow-lg shadow-black/20 ring-1 ring-white/10">
                    K
                </div>
                <span class="font-bold text-lg tracking-tight text-white drop-shadow-sm">KelontongPOS</span>
            </div>

            <!-- Nav -->
            <nav class="flex-1 overflow-y-auto p-4 space-y-6 scrollbar-thin scrollbar-thumb-zinc-800 hover:scrollbar-thumb-zinc-700">
                <!-- Main -->
                <div class="space-y-1">
                    <Link href="/pos" 
                          class="flex items-center gap-3 px-3 py-2 rounded-lg transition-all duration-200 text-sm font-medium group relative overflow-hidden"
                          :class="$page.url.startsWith('/pos') ? 'bg-brand-900/20 text-brand-300 shadow-inner shadow-black/20 ring-1 ring-brand-900/50' : 'text-zinc-400 hover:bg-zinc-900 hover:text-white'">
                        <Monitor :size="18" class="group-hover:scale-110 transition-transform" />
                        <span class="relative z-10">Open POS</span>
                    </Link>
                    <Link href="/dashboard" 
                          class="flex items-center gap-3 px-3 py-2 rounded-lg transition-all duration-200 text-sm font-medium group relative overflow-hidden"
                          :class="$page.url === '/dashboard' ? 'bg-brand-900/20 text-brand-300 shadow-inner shadow-black/20 ring-1 ring-brand-900/50' : 'text-zinc-400 hover:bg-zinc-900 hover:text-white'">
                        <LayoutDashboard :size="18" class="group-hover:scale-110 transition-transform" />
                        <span class="relative z-10">Dashboard</span>
                    </Link>
                    <Link href="/assistant" 
                          class="flex items-center gap-3 px-3 py-2 rounded-lg transition-all duration-200 text-sm font-medium group relative overflow-hidden"
                          :class="$page.url.startsWith('/assistant') ? 'bg-brand-900/20 text-brand-300 shadow-inner shadow-black/20 ring-1 ring-brand-900/50' : 'text-zinc-400 hover:bg-zinc-900 hover:text-white'">
                        <Sparkles :size="18" class="group-hover:scale-110 transition-transform" />
                        <span class="relative z-10">Smart Assistant</span>
                    </Link>
                </div>

                <!-- Operations -->
                <div>
                    <h3 class="px-3 text-xs font-bold text-zinc-500 uppercase tracking-widest mb-3">Operations</h3>
                    <div class="space-y-1">
                        <Link href="/products" class="flex items-center gap-3 px-3 py-2 rounded-lg text-zinc-400 hover:bg-zinc-900 hover:text-white text-sm font-medium transition-colors group">
                            <Package :size="18" class="group-hover:text-brand-400 transition-colors" />
                            Products
                        </Link>
                        <a href="/reports/expiry" 
                              class="flex items-center gap-3 px-3 py-2 rounded-lg transition-all duration-200 text-sm font-medium group"
                              :class="$page.url.startsWith('/reports/expiry') ? 'bg-brand-900/20 text-brand-300 shadow-inner shadow-black/20 ring-1 ring-brand-900/50' : 'text-zinc-400 hover:bg-zinc-900 hover:text-white'">
                            <AlertTriangle :size="18" class="group-hover:text-brand-400 transition-colors" />
                            Expiry Report
                        </a>
                        <Link href="/batches" class="flex items-center gap-3 px-3 py-2 rounded-lg text-zinc-400 hover:bg-zinc-900 hover:text-white text-sm font-medium transition-colors group">
                            <Box :size="18" class="group-hover:text-brand-400 transition-colors" />
                            Inventory & Batches
                        </Link>
                        <Link href="/stock-transfers" class="flex items-center gap-3 px-3 py-2 rounded-lg text-zinc-400 hover:bg-zinc-900 hover:text-white text-sm font-medium transition-colors group">
                            <Truck :size="18" class="group-hover:text-brand-400 transition-colors" />
                            Stock Transfers
                        </Link>
                    </div>
                </div>

                <!-- Procurement -->
                <div v-if="$page.props.auth.user.is_owner">
                    <h3 class="px-3 text-xs font-bold text-zinc-500 uppercase tracking-widest mb-3">Procurement</h3>
                    <div class="space-y-1">
                        <Link href="/admin/suppliers" class="flex items-center gap-3 px-3 py-2 rounded-lg text-zinc-400 hover:bg-zinc-900 hover:text-white text-sm font-medium transition-colors group">
                            <Factory :size="18" class="group-hover:text-brand-400 transition-colors" />
                            Suppliers
                        </Link>
                        <Link href="/purchase-orders" class="flex items-center gap-3 px-3 py-2 rounded-lg text-zinc-400 hover:bg-zinc-900 hover:text-white text-sm font-medium transition-colors group">
                            <ShoppingCart :size="18" class="group-hover:text-brand-400 transition-colors" />
                            Purchase Orders
                        </Link>
                        <Link href="/customers" class="flex items-center gap-3 px-3 py-2 rounded-lg text-zinc-400 hover:bg-zinc-900 hover:text-white text-sm font-medium transition-colors group">
                            <Users :size="18" class="group-hover:text-brand-400 transition-colors" />
                            Customers & Loyalty
                        </Link>
                         <a href="/cash-drawer" class="flex items-center gap-3 px-3 py-2 rounded-lg text-zinc-400 hover:bg-zinc-900 hover:text-white text-sm font-medium transition-colors group">
                            <Banknote :size="18" class="group-hover:text-brand-400 transition-colors" />
                            Cash Drawer
                        </a>
                    </div>
                </div>

                <!-- Insights -->
                <div v-if="$page.props.auth.user.is_manager">
                    <h3 class="px-3 text-xs font-bold text-zinc-500 uppercase tracking-widest mb-3">Insights</h3>
                    <div class="space-y-1">
                        <Link href="/financial" class="flex items-center gap-3 px-3 py-2 rounded-lg text-zinc-400 hover:bg-zinc-900 hover:text-white text-sm font-medium transition-colors group">
                            <PieChart :size="18" class="group-hover:text-brand-400 transition-colors" />
                            Financials
                        </Link>
                        <a href="/financial/accounts" class="flex items-center gap-3 px-3 py-2 rounded-lg text-zinc-400 hover:bg-zinc-900 hover:text-white text-sm font-medium transition-colors group">
                            <BookOpen :size="18" class="group-hover:text-brand-400 transition-colors" />
                            Chart of Accounts
                        </a>
                        <a href="/financial/ledger" class="flex items-center gap-3 px-3 py-2 rounded-lg text-zinc-400 hover:bg-zinc-900 hover:text-white text-sm font-medium transition-colors group">
                            <ClipboardList :size="18" class="group-hover:text-brand-400 transition-colors" />
                            General Ledger
                        </a>
                        <a v-if="$page.props.auth.user.is_owner" href="/financial/reports" class="flex items-center gap-3 px-3 py-2 rounded-lg text-zinc-400 hover:bg-zinc-900 hover:text-white text-sm font-medium transition-colors group">
                            <FileText :size="18" class="group-hover:text-brand-400 transition-colors" />
                            P&L / Balance Sheet
                        </a>
                        <Link href="/analytics" class="flex items-center gap-3 px-3 py-2 rounded-lg text-zinc-400 hover:bg-zinc-900 hover:text-white text-sm font-medium transition-colors group">
                            <BarChart3 :size="18" class="group-hover:text-brand-400 transition-colors" />
                            Analytics
                        </Link>
                        <Link :href="route('hq.intelligence')" 
                              class="flex items-center gap-3 px-3 py-2 rounded-lg transition-all duration-200 text-sm font-medium group"
                              :class="$page.url.startsWith('/hq-intelligence') ? 'bg-brand-900/20 text-brand-300 shadow-inner shadow-black/20 ring-1 ring-brand-900/50' : 'text-zinc-400 hover:bg-zinc-900 hover:text-white'">
                            <ShieldCheck :size="18" class="group-hover:text-amber-400 transition-colors" />
                            HQ Intelligence
                        </Link>
                        <Link href="/forecast" class="flex items-center gap-3 px-3 py-2 rounded-lg text-zinc-400 hover:bg-zinc-900 hover:text-white text-sm font-medium transition-colors group">
                            <Sparkles :size="18" class="group-hover:text-brand-400 transition-colors" />
                            AI Forecast
                        </Link>
                    </div>
                </div>

                <!-- Admin Zone -->
                <div v-if="$page.props.auth.user.is_owner">
                    <h3 class="px-3 text-xs font-bold text-zinc-500 uppercase tracking-widest mb-3">Admin Zone</h3>
                    <div class="space-y-1">
                        <a href="/admin/users" class="flex items-center gap-3 px-3 py-2 rounded-lg text-zinc-400 hover:bg-zinc-900 hover:text-white text-sm font-medium transition-colors group">
                            <Key :size="18" class="group-hover:text-brand-400 transition-colors" />
                            User Management
                        </a>
                        <a href="/audit" class="flex items-center gap-3 px-3 py-2 rounded-lg text-zinc-400 hover:bg-zinc-900 hover:text-white text-sm font-medium transition-colors group">
                            <ShieldCheck :size="18" class="group-hover:text-brand-400 transition-colors" />
                            Security & Audit
                        </a>
                        <a href="/backups" class="flex items-center gap-3 px-3 py-2 rounded-lg text-zinc-400 hover:bg-zinc-900 hover:text-white text-sm font-medium transition-colors group">
                            <Database :size="18" class="group-hover:text-brand-400 transition-colors" />
                            Backups & Health
                        </a>
                    </div>
                </div>
            </nav>

            <!-- User -->
            <div class="p-4 border-t border-zinc-900 bg-black/10">
                 <Link href="/logout" method="post" as="button" class="w-full flex items-center gap-3 px-3 py-2 rounded-lg hover:bg-zinc-900 text-zinc-400 hover:text-white transition-colors text-sm font-medium group">
                    <div class="p-1 rounded bg-black/20 group-hover:bg-zinc-800 transition-colors">
                        <LogOut :size="16" />
                    </div>
                    Sign Out
                </Link>
            </div>
        </aside>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col min-w-0 overflow-hidden">
            <header class="h-16 border-b border-gray-200 dark:border-zinc-800 px-8 flex items-center justify-between bg-white/80 dark:bg-dark-bg/80 backdrop-blur-sm z-10">
                <h1 class="text-xl font-semibold tracking-tight text-zinc-900 dark:text-zinc-200">{{ title }}</h1>
                <div class="flex items-center gap-4">
                    <!-- Theme Switcher -->
                    <button @click="toggleTheme" 
                            class="p-2.5 rounded-xl bg-zinc-100 dark:bg-zinc-800 text-zinc-600 dark:text-zinc-400 hover:text-brand-700 dark:hover:text-brand-400 transition-all border border-zinc-200 dark:border-zinc-700 shadow-sm overflow-hidden relative active:scale-95">
                        <div class="relative w-5 h-5">
                            <Sun :size="20" class="absolute inset-0 transition-all duration-500 transform pointer-events-none"
                                 :class="isDark ? '-translate-y-8 opacity-0 rotate-90' : 'translate-y-0 opacity-100 rotate-0'" />
                            <Moon :size="20" class="absolute inset-0 transition-all duration-500 transform pointer-events-none"
                                  :class="!isDark ? 'translate-y-8 opacity-0 -rotate-90' : 'translate-y-0 opacity-100 rotate-0'" />
                        </div>
                    </button>

                    <div class="h-8 w-px bg-zinc-200 dark:bg-zinc-800"></div>

                    <span class="text-sm font-bold text-zinc-600 dark:text-zinc-400">{{ $page.props.auth.user ? $page.props.auth.user.name : 'Guest' }}</span>
                </div>
            </header>

            <main class="flex-1 overflow-auto p-8 bg-gray-50/50 dark:bg-dark-bg/50">
                <slot />
            </main>
        </div>
    </div>
</template>
