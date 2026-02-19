<script setup>
import MainLayout from '@/Layouts/MainLayout.vue';
import { Head, useForm, Link } from '@inertiajs/vue3';
import { ref, computed } from 'vue';
import { Package, ArrowLeft, Save, AlertCircle, Image as ImageIcon, X } from 'lucide-vue-next';
import Input from '@/Components/UI/Input.vue';
import Button from '@/Components/UI/Button.vue';

const props = defineProps({
    product: Object, // Optional, if editing
    categories: Array,
});

const isEditing = computed(() => !!props.product);

const form = useForm({
    name: props.product?.name || '',
    category_id: props.product?.category_id || '',
    price: props.product?.price || 0,
    cost_price: props.product?.cost_price || 0,
    stock: props.product?.stock || 0,
    barcode: props.product?.barcode || '',
    image: null,
    _method: props.product ? 'PUT' : 'POST', // Spoof method for file upload on edit
});

// Image preview state
const imagePreview = ref(props.product?.image ? `/storage/${props.product.image}` : null);

const handleImageUpload = (event) => {
    const file = event.target.files[0];
    if (file) {
        form.image = file;
        imagePreview.value = URL.createObjectURL(file);
    }
};

const removeImage = () => {
    form.image = null;
    imagePreview.value = null;
    // Reset file input
    const input = document.getElementById('image');
    if (input) input.value = '';
};

const submit = () => {
    if (isEditing.value) {
        // Use post with _method: PUT for file uploads in Laravel
        form.post(route('products.update', props.product.id), {
            forceFormData: true,
        });
    } else {
        form.post(route('products.store'));
    }
};
</script>

<template>
    <Head :title="isEditing ? `Edit Product: ${product.name}` : 'Create Product'" />

    <MainLayout :title="isEditing ? 'Edit Product' : 'New Product'">
        <div class="max-w-3xl mx-auto">
            <!-- Back Button -->
            <div class="mb-6">
                <Link :href="route('products.index')" class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200 flex items-center gap-2 text-sm font-medium transition-colors">
                    <ArrowLeft class="w-4 h-4" />
                    Back to Products
                </Link>
            </div>

            <!-- Form Card -->
            <div class="bg-white dark:bg-zinc-900 rounded-2xl shadow-sm border border-gray-200 dark:border-zinc-800 overflow-hidden">
                <div class="p-6 border-b border-gray-100 dark:border-zinc-800 flex items-center gap-3">
                    <div class="p-2 bg-red-50 dark:bg-red-900/20 rounded-lg text-red-600 dark:text-red-400">
                        <Package :size="20" />
                    </div>
                    <div>
                        <h2 class="text-lg font-bold text-gray-900 dark:text-white">
                            {{ isEditing ? 'Update Product Details' : 'Product Information' }}
                        </h2>
                        <p class="text-sm text-gray-500 dark:text-gray-400">
                            {{ isEditing ? `Editing product ID: ${product.id}` : 'Fill in the details to create a new product.' }}
                        </p>
                    </div>
                </div>
                
                <form @submit.prevent="submit" class="p-6 space-y-6">
                    <!-- Basic Info -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div class="space-y-2">
                             <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">Product Name</label>
                             <Input v-model="form.name" placeholder="e.g. Aqua 600ml" :error="form.errors.name" required />
                        </div>

                        <div class="space-y-2">
                            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">Category</label>
                            <select v-model="form.category_id" class="w-full h-10 px-3 bg-white dark:bg-zinc-900 border border-gray-300 dark:border-zinc-700 rounded-lg text-sm focus:ring-2 focus:ring-red-500 focus:border-red-500 transition-colors text-gray-900 dark:text-white">
                                <option value="" disabled>Select Category</option>
                                <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
                            </select>
                            <p v-if="form.errors.category_id" class="text-xs text-red-500 mt-1">{{ form.errors.category_id }}</p>
                        </div>
                    </div>

                    <!-- Image Upload -->
                    <div class="space-y-2">
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">Product Image</label>
                        
                        <div class="flex items-start gap-4">
                            <!-- Image Preview -->
                            <div v-if="imagePreview" class="relative group">
                                <img :src="imagePreview" alt="Preview" class="w-32 h-32 object-cover rounded-lg border border-gray-200 dark:border-zinc-700" />
                                <button @click.prevent="removeImage" class="absolute -top-2 -right-2 bg-red-500 text-white rounded-full p-1 shadow-md hover:bg-red-600 transition-colors">
                                    <X class="w-4 h-4" />
                                </button>
                            </div>

                            <!-- Placeholder -->
                            <div v-else class="w-32 h-32 rounded-lg border-2 border-dashed border-gray-300 dark:border-zinc-700 flex flex-col items-center justify-center text-gray-400 gap-2 bg-gray-50 dark:bg-zinc-800/50">
                                <ImageIcon class="w-8 h-8" />
                                <span class="text-xs">No image</span>
                            </div>

                            <!-- Upload Input -->
                            <div class="flex-1">
                                <input 
                                    type="file" 
                                    id="image" 
                                    @change="handleImageUpload" 
                                    accept="image/*"
                                    class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-red-50 file:text-red-700 hover:file:bg-red-100 dark:file:bg-red-900/30 dark:file:text-red-400 transition-colors"
                                />
                                <p class="text-xs text-gray-500 mt-2">Max file size: 2MB. Supported formats: JPG, PNG, WEBP.</p>
                                <p v-if="form.errors.image" class="text-xs text-red-500 mt-1">{{ form.errors.image }}</p>
                            </div>
                        </div>
                    </div>

                    <!-- Pricing -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 p-4 bg-gray-50 dark:bg-zinc-800/50 rounded-xl border border-gray-100 dark:border-zinc-800">
                        <div class="space-y-2">
                             <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">Selling Price (Rp)</label>
                             <div class="relative">
                                 <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-500 text-sm">Rp</span>
                                 <input type="number" v-model="form.price" class="w-full pl-10 pr-3 h-10 rounded-lg border-gray-300 dark:border-zinc-700 bg-white dark:bg-zinc-900 text-sm focus:ring-2 focus:ring-red-500" placeholder="0" min="0" required />
                             </div>
                             <p v-if="form.errors.price" class="text-xs text-red-500 mt-1">{{ form.errors.price }}</p>
                        </div>

                        <div class="space-y-2">
                             <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">Cost Price (Rp)</label>
                             <div class="relative">
                                 <span class="absolute left-3 top-1/2 -translate-y-1/2 text-gray-500 text-sm">Rp</span>
                                 <input type="number" v-model="form.cost_price" class="w-full pl-10 pr-3 h-10 rounded-lg border-gray-300 dark:border-zinc-700 bg-white dark:bg-zinc-900 text-sm focus:ring-2 focus:ring-red-500" placeholder="0" min="0" required />
                             </div>
                             <p v-if="form.errors.cost_price" class="text-xs text-red-500 mt-1">{{ form.errors.cost_price }}</p>
                        </div>
                    </div>

                    <!-- Inventory -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div class="space-y-2">
                             <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">Stock Quantity</label>
                             <Input type="number" v-model="form.stock" placeholder="0" min="0" :error="form.errors.stock" />
                             <p v-if="isEditing" class="text-xs text-orange-500 flex items-center gap-1">
                                <AlertCircle class="w-3 h-3" />
                                Updating stock directly here will not record a batch history.
                             </p>
                        </div>

                        <div class="space-y-2">
                             <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">Barcode / SKU</label>
                             <Input v-model="form.barcode" placeholder="Scan or enter barcode" :error="form.errors.barcode" />
                        </div>
                    </div>
                    
                    <!-- Actions -->
                    <div class="flex justify-end gap-3 pt-4 border-t border-gray-100 dark:border-zinc-800">
                        <Link :href="route('products.index')" class="px-4 py-2 text-sm font-medium text-gray-700 dark:text-gray-300 bg-white dark:bg-zinc-800 border border-gray-300 dark:border-zinc-700 rounded-lg hover:bg-gray-50 dark:hover:bg-zinc-700 transition-colors">
                            Cancel
                        </Link>
                        <Button type="submit" :disabled="form.processing" class="px-8 h-11 bg-red-600 hover:bg-red-700 text-white rounded-xl font-black uppercase tracking-widest text-xs shadow-lg shadow-red-600/20 transition-all disabled:opacity-50 flex items-center gap-2">
                            <Save :size="18" />
                            {{ isEditing ? 'Update Product' : 'Save Product' }}
                        </Button>
                    </div>
                </form>
            </div>
        </div>
    </MainLayout>
</template>
