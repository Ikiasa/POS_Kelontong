<script setup>
defineProps({
    variant: {
        type: String,
        default: 'primary',
        validator: (value) => ['primary', 'secondary', 'danger', 'ghost', 'outline'].includes(value)
    },
    size: {
        type: String,
        default: 'md',
        validator: (value) => ['sm', 'md', 'lg', 'icon'].includes(value)
    },
    disabled: Boolean,
    loading: Boolean,
});
</script>

<template>
    <button
        :disabled="disabled || loading"
        class="inline-flex items-center justify-center rounded-xl font-medium transition-all focus:outline-none focus:ring-2 focus:ring-offset-2 disabled:opacity-50 disabled:pointer-events-none active:scale-[0.98]"
        :class="{
            // Variants
            'bg-zinc-900 dark:bg-brand-600 text-white hover:bg-zinc-800 dark:hover:bg-brand-700 shadow-sm focus:ring-zinc-900 dark:focus:ring-brand-500': variant === 'primary',
            'bg-white dark:bg-zinc-800 border border-gray-200 dark:border-zinc-700 text-zinc-700 dark:text-zinc-200 hover:bg-gray-50 dark:hover:bg-zinc-700 focus:ring-gray-200': variant === 'secondary',
            'bg-danger/10 dark:bg-danger/20 text-danger border border-transparent hover:bg-danger/20 dark:hover:bg-danger/30': variant === 'danger',
            'bg-transparent hover:bg-gray-100 dark:hover:bg-zinc-800 text-zinc-600 dark:text-zinc-400': variant === 'ghost',
            
            // Sizes
            'text-xs px-2.5 py-1.5': size === 'sm',
            'text-sm px-4 py-2': size === 'md',
            'text-base px-6 py-3': size === 'lg',
            'p-2': size === 'icon'
        }"
    >
        <svg v-if="loading" class="animate-spin -ml-1 mr-2 h-4 w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
        </svg>
        <slot />
    </button>
</template>
