<script setup>
defineProps({
    modelValue: [String, Number],
    type: { type: String, default: 'text' },
    placeholder: String,
    icon: [Object, Function], // Lucide Icon Component
    error: String,
});

defineEmits(['update:modelValue']);
</script>

<template>
    <div class="space-y-1">
        <div class="relative group">
            <component 
                v-if="icon" 
                :is="icon" 
                class="absolute left-3 top-1/2 -translate-y-1/2 text-zinc-400 group-focus-within:text-red-500 transition-colors pointer-events-none" 
                :size="18" 
            />
            <input
                :type="type"
                :value="modelValue"
                @input="$emit('update:modelValue', $event.target.value)"
                :placeholder="placeholder"
                class="w-full bg-white dark:bg-zinc-900 border border-gray-200 dark:border-zinc-700 rounded-xl py-2.5 text-sm transition-all focus:outline-none focus:ring-2 focus:ring-red-500/20 focus:border-red-500 text-zinc-900 dark:text-white placeholder:text-zinc-400"
                :class="{'pl-10': icon, 'pl-4': !icon, 'border-red-500 focus:border-red-500 focus:ring-red-500/20': error}"
            />
        </div>
        <p v-if="error" class="text-xs text-red-500 ml-1">{{ error }}</p>
    </div>
</template>
