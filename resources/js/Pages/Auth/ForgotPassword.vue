<script setup>
import { Head, useForm, Link } from '@inertiajs/vue3';
import Input from '@/Components/UI/Input.vue';
import Button from '@/Components/UI/Button.vue';
import { Mail, ArrowLeft } from 'lucide-vue-next';

defineProps({
    status: String,
});

const form = useForm({
    email: '',
});

const submit = () => {
    form.post(route('password.email'));
};
</script>

<template>
    <Head title="Forgot Password" />

    <div class="min-h-screen flex flex-col sm:justify-center items-center pt-6 sm:pt-0 bg-gray-50 dark:bg-zinc-950">
        <div class="w-full sm:max-w-md mt-6 px-6 py-8 bg-white dark:bg-zinc-900 shadow-md overflow-hidden sm:rounded-2xl border border-gray-100 dark:border-zinc-800">
            <div class="mb-4 text-sm text-zinc-600 dark:text-zinc-400">
                Forgot your password? No problem. Just let us know your email address and we will email you a password reset link allowed you to choose a new one.
            </div>

            <div v-if="status" class="mb-4 font-medium text-sm text-green-600">
                {{ status }}
            </div>

            <form @submit.prevent="submit" class="space-y-6">
                <Input 
                    v-model="form.email"
                    type="email"
                    placeholder="Email Address"
                    :icon="Mail"
                    :error="form.errors.email"
                    required
                    autofocus
                />

                <div class="flex items-center justify-between mt-4">
                    <Link
                        :href="route('login')"
                        class="flex items-center gap-2 text-sm text-zinc-600 dark:text-zinc-400 hover:text-red-900 rounded-md focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
                    >
                        <ArrowLeft :size="16" />
                        Back to login
                    </Link>

                    <Button :loading="form.processing">
                        Email Password Reset Link
                    </Button>
                </div>
            </form>
        </div>
    </div>
</template>
