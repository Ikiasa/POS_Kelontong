<script setup>
defineProps({
    title: {
        type: String,
        required: false
    }
});
</script>

<template>
    <div class="bg-white dark:bg-zinc-900 rounded-xl shadow-sm border border-zinc-200 dark:border-zinc-800 overflow-hidden">
        <div v-if="title" class="px-6 py-4 border-b border-zinc-100 dark:border-zinc-800">
            <h3 class="font-bold text-lg text-zinc-900 dark:text-zinc-100">{{ title }}</h3>
        </div>
        <div class="p-6">
            <slot />
        </div>
    </div>
</template>
