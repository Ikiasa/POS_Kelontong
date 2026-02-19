<script setup>
import { onMounted, onUnmounted } from 'vue';
import { X } from 'lucide-vue-next';

const props = defineProps({
    show: Boolean,
    maxWidth: {
        type: String,
        default: '2xl'
    },
    closeable: {
        type: Boolean,
        default: true
    }
});

const emit = defineEmits(['close']);

const close = () => {
    if (props.closeable) {
        emit('close');
    }
};

const closeOnEscape = (e) => {
    if (e.key === 'Escape' && props.show) {
        close();
    }
};

onMounted(() => document.addEventListener('keydown', closeOnEscape));
onUnmounted(() => document.removeEventListener('keydown', closeOnEscape));

const maxWidthClass = {
    'sm': 'max-w-sm',
    'md': 'max-w-md',
    'lg': 'max-w-lg',
    'xl': 'max-w-xl',
    '2xl': 'max-w-2xl',
    '3xl': 'max-w-3xl',
    '4xl': 'max-w-4xl',
    '5xl': 'max-w-5xl',
    '6xl': 'max-w-6xl',
    '7xl': 'max-w-7xl',
}[props.maxWidth];
</script>

<template>
    <Teleport to="body">
        <Transition
            enter-active-class="transition ease-out duration-200"
            enter-from-class="opacity-0"
            enter-to-class="opacity-100"
            leave-active-class="transition ease-in duration-200"
            leave-from-class="opacity-100"
            leave-to-class="opacity-0"
        >
            <div v-show="show" class="fixed inset-0 overflow-y-auto px-4 py-6 sm:px-0 z-50" scroll-region>
                <div
                    class="fixed inset-0 bg-black/50 backdrop-blur-sm"
                    @click="close"
                />

                <Transition
                    enter-active-class="transition ease-out duration-200"
                    enter-from-class="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
                    enter-to-class="opacity-100 translate-y-0 sm:scale-100"
                    leave-active-class="transition ease-in duration-200"
                    leave-from-class="opacity-100 translate-y-0 sm:scale-100"
                    leave-to-class="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
                >
                    <div 
                        v-show="show" 
                        class="relative transform overflow-hidden rounded-2xl bg-white dark:bg-zinc-900 shadow-xl transition-all sm:w-full sm:mx-auto border border-gray-200 dark:border-zinc-800"
                        :class="maxWidthClass"
                    >
                        <button
                            v-if="closeable"
                            @click="close"
                            class="absolute top-4 right-4 text-gray-400 hover:text-gray-600 dark:hover:text-gray-200 transition-colors z-10"
                        >
                            <X class="w-5 h-5" />
                        </button>

                        <slot />
                    </div>
                </Transition>
            </div>
        </Transition>
    </Teleport>
</template>
