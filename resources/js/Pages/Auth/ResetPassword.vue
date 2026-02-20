<script setup>
import { Head, useForm } from '@inertiajs/vue3';
import Input from '@/Components/UI/Input.vue';
import Button from '@/Components/UI/Button.vue';
import { Lock, Mail } from 'lucide-vue-next';

const props = defineProps({
    email: String,
    token: String,
});

const form = useForm({
    token: props.token,
    email: props.email,
    password: '',
    password_confirmation: '',
});

const submit = () => {
    form.post(route('password.update'), {
        onFinish: () => form.reset('password', 'password_confirmation'),
    });
};
</script>

<template>
    <Head title="Reset Password" />

    <div class="min-h-screen flex flex-col sm:justify-center items-center pt-6 sm:pt-0 bg-gray-50 dark:bg-zinc-950">
        <div class="w-full sm:max-w-md mt-6 px-6 py-8 bg-white dark:bg-zinc-900 shadow-md overflow-hidden sm:rounded-2xl border border-gray-100 dark:border-zinc-800">
            <h2 class="text-center text-2xl font-bold text-zinc-900 dark:text-white mb-8">Reset your password</h2>

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

                <Input 
                    v-model="form.password"
                    type="password"
                    placeholder="New Password"
                    :icon="Lock"
                    :error="form.errors.password"
                    required
                />

                <Input 
                    v-model="form.password_confirmation"
                    type="password"
                    placeholder="Confirm New Password"
                    :icon="Lock"
                    :error="form.errors.password_confirmation"
                    required
                />

                <div class="flex items-center justify-end mt-4">
                    <Button :loading="form.processing">
                        Reset Password
                    </Button>
                </div>
            </form>
        </div>
    </div>
</template>
