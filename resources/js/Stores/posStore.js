import { defineStore } from 'pinia';
import { ref, computed } from 'vue';

export const usePosStore = defineStore('pos', () => {
    const cart = ref([]);
    const searchQuery = ref('');
    const selectedCategory = ref(null);
    const customer = ref(null);

    // Actions
    const addToCart = (product) => {
        const existingItem = cart.value.find(item => item.id === product.id);

        if (existingItem) {
            existingItem.qty++;
        } else {
            cart.value.push({
                ...product,
                qty: 1,
                discount: 0
            });
        }
    };

    const updateQty = (productId, qty) => {
        const item = cart.value.find(item => item.id === productId);
        if (item) {
            const parsedQty = parseInt(qty);
            if (isNaN(parsedQty)) {
                // If invalid input, do update but don't remove yet or keep last valid?
                // Better to just let it be empty if user is typing, but here this is called on @change (blur).
                // If blur and empty, maybe set to 1 or remove?
                // Let's set to 1 if invalid to be safe, or remove if intended. 
                // Usually empty = 0 or 1. Let's assume 1 for safety to avoid accidental deletion.
                item.qty = 1;
            } else {
                item.qty = parsedQty;
                if (item.qty <= 0) removeFromCart(productId);
            }
        }
    };

    const removeFromCart = (productId) => {
        cart.value = cart.value.filter(item => item.id !== productId);
    };

    const clearCart = () => {
        cart.value = [];
        customer.value = null;
    };

    const setCustomer = (cust) => {
        customer.value = cust;
    };

    // Getters
    const subtotal = computed(() => {
        return cart.value.reduce((total, item) => total + (item.price * item.qty), 0);
    });

    const taxAmount = computed(() => {
        return 0; // Customize if tax needed
    });

    const total = computed(() => {
        return subtotal.value + taxAmount.value;
    });

    const totalItems = computed(() => {
        return cart.value.reduce((total, item) => total + item.qty, 0);
    });

    return {
        cart,
        searchQuery,
        selectedCategory,
        customer,
        addToCart,
        updateQty,
        removeFromCart,
        clearCart,
        subtotal,
        taxAmount,
        total,
        totalItems,
        setCustomer
    };
});
