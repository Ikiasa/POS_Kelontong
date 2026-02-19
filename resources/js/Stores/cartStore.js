import { defineStore } from 'pinia';
import { ref, computed } from 'vue';

export const useCartStore = defineStore('cart', () => {
    // State
    const items = ref([]);
    const customer = ref(null);
    const discountPercent = ref(0);

    // Getters
    const count = computed(() => items.value.reduce((sum, item) => sum + item.quantity, 0));

    const subtotal = computed(() => {
        return items.value.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    });

    const tax = computed(() => Math.round(subtotal.value * 0.11)); // 11% PPN

    const discountAmount = computed(() => {
        return Math.round(subtotal.value * (discountPercent.value / 100));
    });

    const total = computed(() => {
        return Math.max(0, subtotal.value + tax.value - discountAmount.value);
    });

    // Actions
    function add(product) {
        const existing = items.value.find(i => i.id === product.id);
        if (existing) {
            if (existing.quantity >= product.stock) {
                alert(`Cannot add more. Only ${product.stock} items in stock.`);
                return;
            }
            existing.quantity++;
        } else {
            if (product.stock <= 0) {
                alert('Item is out of stock.');
                return;
            }
            items.value.push({ ...product, quantity: 1 });
        }
    }

    function remove(id) {
        items.value = items.value.filter(i => i.id !== id);
    }

    function updateQuantity(id, qty) {
        const item = items.value.find(i => i.id === id);
        if (item) {
            if (qty > item.stock) {
                alert(`Only ${item.stock} items in stock.`);
                item.quantity = item.stock;
                return;
            }
            item.quantity = qty;
            if (item.quantity <= 0) remove(id);
        }
    }

    function clear() {
        items.value = [];
        customer.value = null;
        discountPercent.value = 0;
    }

    function setCustomer(cust) {
        customer.value = cust;
    }

    return {
        items,
        customer,
        discountPercent,
        count,
        subtotal,
        tax,
        discountAmount,
        total,
        add,
        remove,
        updateQuantity,
        clear,
        setCustomer
    };
});
