<script setup>
import { Link, usePage } from '@inertiajs/vue3';
import { 
    LayoutDashboard, Monitor, Package, User, LogOut, 
    AlertTriangle, Box, Truck, Factory, ShoppingCart, 
    Banknote, PieChart, FileText, BarChart3, Sparkles,
    BookOpen, ClipboardList, ShieldCheck, Database, Key, Users,
    Sun, Moon, ChevronLeft, ChevronRight, Store, Search, Bell
} from 'lucide-vue-next';
import { ref, onMounted, computed } from 'vue';

defineProps({
    title: String,
});

const isDark = ref(false);
const isCollapsed = ref(false);
const page = usePage();

onMounted(() => {
    isDark.value = document.documentElement.classList.contains('dark');
    // Check localStorage for sidebar state
    const savedState = localStorage.getItem('sidebar-collapsed');
    if (savedState !== null) {
        isCollapsed.value = savedState === 'true';
    }
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

const toggleSidebar = () => {
    isCollapsed.value = !isCollapsed.value;
    localStorage.setItem('sidebar-collapsed', isCollapsed.value);
};

const user = computed(() => page.props.auth.user);
const currentUrl = computed(() => page.url);

const navGroups = [
    {
        name: 'Main',
        items: [
            { name: 'Dashboard', icon: LayoutDashboard, href: '/dashboard', active: currentUrl.value === '/dashboard' },
            { name: 'POS Terminal', icon: Monitor, href: '/pos', active: currentUrl.value.startsWith('/pos'), accent: true },
            { name: 'Smart Assistant', icon: Sparkles, href: '/assistant', active: currentUrl.value.startsWith('/assistant') },
        ]
    },
    {
        name: 'Inventory & Operations',
        items: [
            { name: 'Products', icon: Package, href: '/products', active: currentUrl.value.startsWith('/products') },
            { name: 'Batches', icon: Box, href: '/batches', active: currentUrl.value.startsWith('/batches') },
            { name: 'Transfers', icon: Truck, href: '/stock-transfers', active: currentUrl.value.startsWith('/stock-transfers') },
            { name: 'Suppliers', icon: Factory, href: '/admin/suppliers', active: currentUrl.value.startsWith('/admin/suppliers'), ownerOnly: true },
        ]
    },
    {
        name: 'Financial & Strategic',
        items: [
            { name: 'Financials', icon: PieChart, href: '/financial', active: currentUrl.value.startsWith('/financial'), managerOnly: true },
            { name: 'HQ Intelligence', icon: ShieldCheck, href: '/hq-intelligence', active: currentUrl.value.startsWith('/hq-intelligence'), ownerOnly: true, badge: 'NEW' },
            { name: 'AI Forecast', icon: BarChart3, href: '/forecast', active: currentUrl.value.startsWith('/forecast'), managerOnly: true },
        ]
    },
    {
        name: 'System Control',
        items: [
            { name: 'User Management', icon: Key, href: '/admin/users', active: currentUrl.value.startsWith('/admin/users'), ownerOnly: true },
            { name: 'Security Audit', icon: ShieldCheck, href: '/audit', active: currentUrl.value.startsWith('/audit'), ownerOnly: true },
            { name: 'Data Health', icon: Database, href: '/backups', active: currentUrl.value.startsWith('/backups'), ownerOnly: true },
        ]
    }
];

const filteredNav = computed(() => {
    return navGroups.map(group => ({
        ...group,
        items: group.items.filter(item => {
            if (item.ownerOnly && !user.value?.is_owner) return false;
            if (item.managerOnly && !user.value?.is_manager) return false;
            return true;
        })
    })).filter(group => group.items.length > 0);
});

</script>

<template>
    <div class="flex h-screen w-full bg-surface-50 dark:bg-dark-bg text-slate-900 dark:text-dark-text-vibrant font-sans antialiased overflow-hidden transition-colors duration-300">
        <!-- Sidebar -->
        <aside :class="[
            'flex flex-col bg-dark-surface text-white shrink-0 transition-all duration-300 ease-in-out z-30 relative border-r border-dark-border shadow-soft',
            isCollapsed ? 'w-20' : 'w-72'
        ]">
            <!-- Logo & Toggle -->
            <div class="h-16 flex items-center justify-between px-6 border-b border-dark-border overflow-hidden">
                <div class="flex items-center gap-3 transition-opacity duration-300" :class="isCollapsed ? 'opacity-0' : 'opacity-100'">
                    <div class="w-8 h-8 bg-brand-600 rounded-xl flex items-center justify-center text-white font-black shadow-lg ring-1 ring-white/20">
                        K
                    </div>
                    <span class="font-black text-lg tracking-tighter">Kelontong<span class="font-light text-brand-400">POS</span></span>
                </div>
                <!-- Toggle Button -->
                <button @click="toggleSidebar" class="p-1.5 rounded-lg bg-dark-surface hover:bg-zinc-800 border border-dark-border text-zinc-400 transition-colors absolute right-4 top-4 z-40" :class="isCollapsed ? 'right-auto left-1/2 -translate-x-1/2' : ''">
                    <ChevronLeft v-if="!isCollapsed" :size="16" />
                    <ChevronRight v-else :size="16" />
                </button>
            </div>

            <!-- Navigation -->
            <nav class="flex-1 overflow-y-auto overflow-x-hidden p-4 space-y-8 scrollbar-hide custom-scrollbar">
                <div v-for="group in filteredNav" :key="group.name" class="space-y-1">
                    <h3 v-if="!isCollapsed" class="px-4 text-[10px] font-black text-zinc-500 uppercase tracking-widest mb-3 transition-all duration-300">
                        {{ group.name }}
                    </h3>
                    
                    <div v-for="item in group.items" :key="item.name" class="relative group">
                        <Link :href="item.href" 
                              class="flex items-center gap-3 px-4 py-2.5 rounded-xl transition-all duration-200 text-sm font-semibold relative overflow-hidden group/item"
                              :class="[
                                  item.active 
                                    ? 'bg-brand-600 text-white shadow-lg shadow-brand-900/40' 
                                    : 'text-zinc-400 hover:bg-zinc-800/50 hover:text-zinc-100',
                                  isCollapsed ? 'justify-center px-0' : ''
                              ]">
                            
                            <component :is="item.icon" :size="20" :class="[
                                item.active ? 'scale-110 text-white' : 'group-hover/item:text-brand-400 group-hover/item:scale-110',
                                'transition-all duration-200'
                            ]" />
                            
                            <span v-if="!isCollapsed" class="whitespace-nowrap transition-all duration-300 overflow-hidden">
                                {{ item.name }}
                            </span>

                            <!-- Active Indicator -->
                            <div v-if="item.active" class="absolute left-0 top-1/2 -translate-y-1/2 w-1 h-2/3 bg-white rounded-r-full shadow-[0_0_8px_white]"></div>

                            <!-- Badge -->
                            <span v-if="item.badge && !isCollapsed" class="ml-auto px-1.5 py-0.5 rounded-md bg-red-500 text-[8px] font-black text-white animate-pulse">
                                {{ item.badge }}
                            </span>
                        </Link>
                        
                        <!-- Tooltip for Collapsed State -->
                        <div v-if="isCollapsed" class="absolute left-full ml-4 px-2 py-1 bg-zinc-900 text-white text-[10px] font-bold rounded opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none z-50 whitespace-nowrap border border-dark-border shadow-xl">
                            {{ item.name }}
                        </div>
                    </div>
                </div>
            </nav>

            <!-- User Footer -->
            <div class="p-4 border-t border-dark-border bg-black/20">
                <div v-if="!isCollapsed" class="flex items-center gap-3 mb-4 px-2 py-3 rounded-2xl bg-zinc-900/50 border border-dark-border">
                    <div class="w-10 h-10 rounded-xl bg-brand-600/20 flex items-center justify-center text-brand-400 font-bold border border-brand-500/30">
                        {{ user?.name?.[0] || 'U' }}
                    </div>
                    <div class="flex flex-col min-w-0">
                        <span class="text-sm font-bold truncate">{{ user?.name || 'Guest' }}</span>
                        <span class="text-[10px] text-zinc-500 uppercase tracking-tighter">{{ user?.role || 'User' }}</span>
                    </div>
                </div>
                <Link href="/logout" method="post" as="button" class="w-full flex items-center gap-3 px-4 py-3 rounded-xl hover:bg-red-500/10 text-zinc-400 hover:text-red-400 transition-all duration-200 font-bold group" :class="isCollapsed ? 'justify-center px-0' : ''">
                    <LogOut :size="20" class="group-hover:translate-x-1 transition-transform" />
                    <span v-if="!isCollapsed" class="text-sm">Sign Out</span>
                </Link>
            </div>
        </aside>

        <!-- Main Content Core -->
        <div class="flex-1 flex flex-col min-w-0 overflow-hidden">
            <!-- Global Header -->
            <header class="h-20 border-b border-surface-200 dark:border-dark-border px-8 flex items-center justify-between bg-white/80 dark:bg-dark-bg/80 backdrop-blur-xl z-20">
                <div class="flex items-center gap-6">
                    <h1 class="text-2xl font-black tracking-tight text-slate-900 dark:text-zinc-100 hidden sm:block">
                        {{ title }}
                    </h1>
                    
                    <!-- Branch Selector (Enterprise UX) -->
                    <div class="h-10 px-4 bg-surface-100 dark:bg-dark-surface border border-surface-200 dark:border-dark-border rounded-xl flex items-center gap-3 text-sm font-bold cursor-pointer hover:bg-white dark:hover:bg-zinc-800 transition-all">
                        <Store :size="16" class="text-brand-500" />
                        <span class="hidden md:inline">{{ user?.store?.name || 'Branch: Pusat Jakarta' }}</span>
                        <span class="md:hidden">Branch: HQ</span>
                        <div class="w-4 h-4 rounded-full bg-green-500 border-2 border-white dark:border-dark-surface"></div>
                    </div>
                </div>

                <div class="flex items-center gap-4">
                    <!-- Search Trigger -->
                    <button class="w-10 h-10 rounded-xl bg-surface-100 dark:bg-dark-surface border border-surface-200 dark:border-dark-border flex items-center justify-center text-slate-500 dark:text-zinc-400 hover:bg-white dark:hover:bg-zinc-800 transition-all">
                        <Search :size="18" />
                    </button>

                    <!-- Notifications -->
                    <button class="relative w-10 h-10 rounded-xl bg-surface-100 dark:bg-dark-surface border border-surface-200 dark:border-dark-border flex items-center justify-center text-slate-500 dark:text-zinc-400 hover:bg-white dark:hover:bg-zinc-800 transition-all">
                        <Bell :size="18" />
                        <span class="absolute top-2 right-2 w-2.5 h-2.5 bg-red-500 rounded-full border-2 border-white dark:border-dark-surface"></span>
                    </button>

                    <div class="h-10 w-px bg-surface-200 dark:bg-dark-border mx-2"></div>

                    <!-- Theme Switcher -->
                    <button @click="toggleTheme" 
                            class="p-2.5 rounded-xl bg-zinc-100 dark:bg-zinc-800 text-zinc-600 dark:text-zinc-400 hover:text-brand-600 dark:hover:text-brand-400 transition-all border border-zinc-200 dark:border-zinc-700 shadow-sm overflow-hidden relative active:scale-95">
                        <div class="relative w-5 h-5">
                            <Sun :size="20" class="absolute inset-0 transition-all duration-500 transform pointer-events-none"
                                 :class="isDark ? '-translate-y-8 opacity-0 rotate-90' : 'translate-y-0 opacity-100 rotate-0'" />
                            <Moon :size="20" class="absolute inset-0 transition-all duration-500 transform pointer-events-none"
                                  :class="!isDark ? 'translate-y-8 opacity-0 -rotate-90' : 'translate-y-0 opacity-100 rotate-0'" />
                        </div>
                    </button>
                </div>
            </header>

            <!-- Content Area -->
            <main class="flex-1 overflow-auto p-4 md:p-8 animate-in fade-in slide-in-from-bottom-2 duration-700">
                <slot />
            </main>
        </div>
    </div>
</template>

<style>
/* Custom Scrollbar for better SaaS feel */
.custom-scrollbar::-webkit-scrollbar {
    width: 4px;
}
.custom-scrollbar::-webkit-scrollbar-track {
    background: transparent;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
    background-color: rgb(var(--color-surface-800) / 0.5);
    border-radius: 9999px;
}
.custom-scrollbar::-webkit-scrollbar-thumb:hover {
    background-color: var(--color-surface-700);
}

/* Hide scrollbar by default */
.scrollbar-hide::-webkit-scrollbar {
    display: none;
}
</style>
