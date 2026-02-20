<script setup>
import { Head, useForm, Link } from '@inertiajs/vue3';
import Input from '@/Components/UI/Input.vue';
import Button from '@/Components/UI/Button.vue';
import { User, Lock } from 'lucide-vue-next';

defineProps({
    status: String,
});

const form = useForm({
    email: '',
    password: '',
    remember: false,
});

const submit = () => {
    form.post('/login', {
        onFinish: () => form.reset('password'),
    });
};
</script>

<template>
    <Head title="Log in" />

    <div class="min-h-screen flex flex-col sm:justify-center items-center pt-6 sm:pt-0 bg-gray-50 dark:bg-zinc-950">
        <div class="w-full sm:max-w-md mt-6 px-6 py-8 bg-white dark:bg-zinc-900 shadow-md overflow-hidden sm:rounded-2xl border border-gray-100 dark:border-zinc-800">
            <div class="flex justify-center mb-8">
                <div class="w-12 h-12 bg-red-600 rounded-xl flex items-center justify-center text-white font-bold shadow-lg shadow-red-600/20 text-xl">
                    K
                </div>
            </div>

            <h2 class="text-center text-2xl font-bold text-zinc-900 dark:text-white mb-8">Sign in to your account</h2>

            <div v-if="status" class="mb-4 font-medium text-sm text-green-600">
                {{ status }}
            </div>

            <form @submit.prevent="submit" class="space-y-6">
                <Input 
                    v-model="form.email"
                    type="email"
                    placeholder="Email Address"
                    :icon="User"
                    :error="form.errors.email"
                    required
                    autofocus
                />

                <Input 
                    v-model="form.password"
                    type="password"
                    placeholder="Password"
                    :icon="Lock"
                    :error="form.errors.password"
                    required
                />

                <div class="flex items-center justify-between">
                    <label class="flex items-center">
                        <input type="checkbox" v-model="form.remember" class="rounded border-gray-300 text-red-600 shadow-sm focus:ring-red-500">
                        <span class="ml-2 text-sm text-zinc-600 dark:text-zinc-400">Remember me</span>
                    </label>

                    <Link
                        v-if="true"
                        :href="route('password.request')"
                        class="underline text-sm text-zinc-600 dark:text-zinc-400 hover:text-red-900 rounded-md focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500"
                    >
                        Forgot your password?
                    </Link>
                </div>

                <Button class="w-full" :loading="form.processing">
                    Log in
                </Button>
            </form>
        </div>
    </div>
</template>
