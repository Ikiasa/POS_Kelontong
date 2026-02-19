<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head } from '@inertiajs/vue3';
import { ref, onMounted } from 'vue';
import { 
    ShoppingCart, 
    AlertTriangle, 
    Clock, 
    Sparkles
} from 'lucide-vue-next';
import ReorderPanel from '@/Components/Assistant/ReorderPanel.vue';
import DeadStockPanel from '@/Components/Assistant/DeadStockPanel.vue';
import ExpiryPanel from '@/Components/Assistant/ExpiryPanel.vue';
import InsightsPanel from '@/Components/Assistant/InsightsPanel.vue';

const activeTab = ref('insights');

const tabs = [
    { id: 'insights', label: 'AI Insights', icon: Sparkles },
    { id: 'reorder', label: 'Smart Restock', icon: ShoppingCart },
    { id: 'deadstock', label: 'Dead Stock', icon: AlertTriangle },
    { id: 'expiry', label: 'Expiry Monitor', icon: Clock },
];
</script>

<template>
    <Head title="Retail Assistant" />

    <MainLayout title="Retail Smart Assistant">
        <div class="space-y-6">
            <!-- Header & Tabs -->
            <div class="bg-white dark:bg-zinc-900 p-2 rounded-xl border border-gray-100 dark:border-zinc-800 flex gap-2">
                <button 
                    v-for="tab in tabs" 
                    :key="tab.id"
                    @click="activeTab = tab.id"
                    class="flex-1 flex items-center justify-center gap-2 py-3 rounded-lg text-sm font-bold transition-all"
                    :class="activeTab === tab.id ? 'bg-red-900 text-white shadow-lg shadow-red-900/30' : 'text-zinc-500 hover:bg-gray-50 dark:hover:bg-zinc-800 hover:text-red-700'"
                >
                    <component :is="tab.icon" :size="18" />
                    {{ tab.label }}
                </button>
            </div>

            <!-- Content Area -->
            <div class="bg-white dark:bg-zinc-900 rounded-xl border border-gray-100 dark:border-zinc-800 shadow-sm min-h-[500px]">
                <Transition
                    enter-active-class="transition-opacity duration-300"
                    enter-from-class="opacity-0"
                    enter-to-class="opacity-100"
                    leave-active-class="hidden"
                >
                    <div v-if="activeTab === 'insights'" class="p-6">
                        <InsightsPanel />
                    </div>
                    <div v-else-if="activeTab === 'reorder'" class="p-6">
                        <ReorderPanel />
                    </div>
                    <div v-else-if="activeTab === 'deadstock'" class="p-6">
                        <DeadStockPanel />
                    </div>
                    <div v-else-if="activeTab === 'expiry'" class="p-6">
                        <ExpiryPanel />
                    </div>
                </Transition>
            </div>
        </div>
    </MainLayout>
</template>
