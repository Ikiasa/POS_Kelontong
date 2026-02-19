window.pos = (initialData = {}) => ({
    cart: [],
    products: [],
    categories: [],
    customers: [], // [NEW] Loaded from backend
    promotions: [], // [NEW] Loaded from backend
    searchQuery: '',
    selectedCategory: 'all',
    isLoading: false,

    // Customer & Loyalty [NEW]
    selectedCustomer: null,
    customerSearchQuery: '',
    redeemPoints: 0,
    showCustomerModal: false,

    // Payment State
    showPaymentModal: false,
    paymentMethod: 'cash',
    cashReceived: '',
    splitPayments: [], // [NEW] {method: 'cash', amount: 1000}
    serviceChargeRate: 0, // [UPDATED] Default 0% service charge
    isProcessingPayment: false,

    // QRIS State
    qrisStatus: 'waiting',
    qrisPayload: '', // [NEW] Simulated QRIS string

    // Offline State
    isOnline: navigator.onLine,
    offlineTransactions: [],

    ...initialData,

    init() {
        this.focusSearch();

        document.addEventListener('keydown', (e) => {
            if (e.key === 'F1') { e.preventDefault(); this.focusSearch(); } // Cari
            if (e.key === 'F2') { e.preventDefault(); this.clearCart(); } // BATAL (Clear)
            if (e.key === 'F8') { e.preventDefault(); if (this.cart.length > 0) this.openPaymentModal(); } // BAYAR (Pay)
            if (e.key === 'F4') { e.preventDefault(); this.showCustomerModal = true; } // Optional/Legacy

            if (e.key === 'Escape') {
                if (this.showPaymentModal) this.closePaymentModal();
                if (this.showCustomerModal) this.showCustomerModal = false;
            }
        });

        window.addEventListener('online', () => {
            this.isOnline = true;
            this.syncOfflineTransactions();
        });
        window.addEventListener('offline', () => {
            this.isOnline = false;
        });

        this.offlineTransactions = JSON.parse(localStorage.getItem('offlineTransactions') || '[]');
    },

    // Computed Properties
    get subtotal() {
        return this.cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
    },

    get tax() {
        // Standard PPN 11%
        return Math.round(this.subtotal * 0.11);
    },

    get serviceCharge() {
        // Optional 5% service charge
        return Math.round(this.subtotal * this.serviceChargeRate);
    },

    get discount() {
        let totalDiscount = 0;

        // 1. Product & Category Promotions
        this.cart.forEach(item => {
            let itemDiscount = 0;

            // Find applicable promotions
            const applicablePromos = this.promotions.filter(p => {
                // Check Product Scope
                if (p.product_id && p.product_id === item.id) return true;
                // Check Category Scope
                if (p.category_id && p.category_id === item.category_id) return true;
                // Check Global Scope (no specific product/category)
                if (!p.product_id && !p.category_id) return true;

                return false;
            });

            // Apply best promotion for this item (simplified: highest value)
            if (applicablePromos.length > 0) {
                // Sort by calculated discount value desc
                const bestPromo = applicablePromos.reduce((prev, current) => {
                    const prevVal = this.calculatePromoValue(prev, item);
                    const currVal = this.calculatePromoValue(current, item);
                    return (currVal > prevVal) ? current : prev;
                });

                itemDiscount = this.calculatePromoValue(bestPromo, item);
            }

            totalDiscount += itemDiscount;
        });

        // 2. Points Redemption
        totalDiscount += (this.redeemPoints * 100);

        return totalDiscount;
    },

    calculatePromoValue(promo, item) {
        if (promo.type === 'percentage') {
            return (item.price * item.quantity * promo.value) / 100;
        } else {
            // Fixed amount per unit
            return promo.value * item.quantity;
        }
    },

    get grandTotal() {
        return Math.max(0, this.subtotal + this.tax + this.serviceCharge - this.discount);
    },

    get remainingBalance() {
        if (this.paymentMethod !== 'split') return 0;
        const paid = this.splitPayments.reduce((sum, p) => sum + parseFloat(p.amount || 0), 0);
        return Math.max(0, this.grandTotal - paid);
    },

    get change() {
        if (this.paymentMethod === 'split') return 0;
        const received = parseFloat(this.cashReceived) || 0;
        return Math.max(0, received - this.grandTotal);
    },

    get cartItemCount() {
        return this.cart.reduce((sum, item) => sum + item.quantity, 0);
    },

    get filteredCustomers() {
        if (!this.customerSearchQuery) return this.customers.slice(0, 10);
        const lower = this.customerSearchQuery.toLowerCase();
        return this.customers.filter(c =>
            c.name.toLowerCase().includes(lower) ||
            c.phone.includes(lower)
        ).slice(0, 10);
    },

    // Actions
    focusSearch() {
        this.$nextTick(() => {
            const searchInput = document.querySelector('input[type="text"][placeholder*="Cari"]');
            if (searchInput) searchInput.focus();
        });
    },

    setProducts(products) {
        this.products = products;
    },

    addToCart(product) {
        const existing = this.cart.find(item => item.id === product.id);
        if (existing) {
            existing.quantity++;
        } else {
            this.cart.push({ ...product, quantity: 1 });
        }
    },

    removeFromCart(id) {
        this.cart = this.cart.filter(item => item.id !== id);
    },

    updateQuantity(id, change) {
        const item = this.cart.find(item => item.id === id);
        if (item) {
            item.quantity += change;
            if (item.quantity <= 0) this.removeFromCart(id);
        }
    },

    clearCart() {
        this.cart = [];
        this.selectedCustomer = null;
        this.redeemPoints = 0;
    },

    holdTransaction() {
        if (this.cart.length === 0) return;
        // Logic to save to local storage or backend as 'draft'
        const heldOrder = {
            cart: this.cart,
            customer: this.selectedCustomer,
            timestamp: new Date().toISOString()
        };
        let heldOrders = JSON.parse(localStorage.getItem('heldOrders') || '[]');
        heldOrders.push(heldOrder);
        localStorage.setItem('heldOrders', JSON.stringify(heldOrders));

        this.clearCart();
        alert('Transaction held successfully!');
    },

    openPaymentModal() {
        this.showPaymentModal = true;
        this.cashReceived = ''; // Reset
        this.$nextTick(() => document.getElementById('cash-input')?.focus());
    },

    closePaymentModal() {
        this.showPaymentModal = false;
    },

    selectCustomer(customer) {
        this.selectedCustomer = customer;
        this.showCustomerModal = false;
        this.customerSearchQuery = '';
    },

    setMaxPoints() {
        if (!this.selectedCustomer) return;
        // Max redeemable is balance, but also max discount <= grandTotal
        const maxValue = this.subtotal + this.tax;
        const maxPointsByValue = Math.ceil(maxValue / 100);
        this.redeemPoints = Math.min(this.selectedCustomer.points_balance, maxPointsByValue);
    },

    setPaymentMethod(method) {
        this.paymentMethod = method;
        if (method === 'split') {
            this.splitPayments = [];
        } else if (method === 'qris') {
            this.generateSimulatedQRIS();
        }
    },

    addSplitPayment(method, amount) {
        if (!amount || amount <= 0) return;
        this.splitPayments.push({
            method: method,
            amount: parseFloat(amount),
            reference: ''
        });
        this.cashReceived = ''; // Clear input if used
    },

    removeSplitPayment(index) {
        this.splitPayments.splice(index, 1);
    },

    generateSimulatedQRIS() {
        // Simulated payload for display
        const amountStr = String(Math.floor(this.grandTotal)).padStart(12, '0');
        this.qrisPayload = `00020101021226300016ID.CO.QRIS.WWW011893600523000000010215${amountStr}5802ID5911KelontongKu6005Depok62070703A016304` + Math.random().toString(36).substring(7).toUpperCase();
    },

    async processPayment() {
        if (this.isProcessingPayment) return;

        // Validation
        if (this.paymentMethod === 'split' && this.remainingBalance > 0) {
            alert('Still have Rp ' + this.formatPrice(this.remainingBalance) + ' remaining.');
            return;
        }

        if (this.paymentMethod === 'cash' && this.change < 0) {
            alert('Insufficient cash received.');
            return;
        }

        this.isProcessingPayment = true;

        const paymentItems = this.paymentMethod === 'split'
            ? this.splitPayments
            : [{
                method: this.paymentMethod,
                amount: this.grandTotal,
                reference: null
            }];

        const payload = {
            items: this.cart,
            customer_id: this.selectedCustomer?.id,
            redeem_points: parseInt(this.redeemPoints) || 0,
            payment: {
                method: this.paymentMethod,
                cashReceived: this.paymentMethod === 'cash' ? parseFloat(this.cashReceived) : null,
                change: this.change,
                items: paymentItems // [NEW] Detailed items for backend
            },
            totals: {
                subtotal: this.subtotal,
                tax: this.tax,
                serviceCharge: this.serviceCharge, // [NEW]
                discount: this.discount,
                grandTotal: this.grandTotal
            },
            timestamp: new Date().toISOString()
        };

        if (this.isOnline) {
            try {
                const response = await fetch('/sales', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
                    },
                    body: JSON.stringify(payload)
                });

                if (!response.ok) throw new Error('Transaction failed');

                const result = await response.json();

                // Success feedback
                alert('Transaction successful! Invoice: ' + result.invoice_number);
                this.clearCart();
                this.closePaymentModal();

                // Reload window to refresh stock/points (or handle strictly via JS)
                window.location.reload();

            } catch (error) {
                console.error('Online transaction failed:', error);
                alert('Error processing transaction. Saving offline.');
                this.saveOffline(payload);
                this.clearCart();
                this.closePaymentModal();
            }
        } else {
            this.saveOffline(payload);
            this.clearCart();
            this.closePaymentModal();
        }

        this.isProcessingPayment = false;
    },

    saveOffline(payload) {
        this.offlineTransactions.push(payload);
        localStorage.setItem('offlineTransactions', JSON.stringify(this.offlineTransactions));
        alert('Transaction saved offline.');
    },

    async syncOfflineTransactions() {
        if (this.offlineTransactions.length === 0) return;

        const pending = [...this.offlineTransactions];
        this.offlineTransactions = [];
        localStorage.setItem('offlineTransactions', '[]');

        for (const payload of pending) {
            try {
                await fetch('/sales', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
                    },
                    body: JSON.stringify(payload)
                });
            } catch (error) {
                console.error('Sync failed for one item, re-queueing:', error);
                this.offlineTransactions.push(payload); // Re-queue
            }
        }
        localStorage.setItem('offlineTransactions', JSON.stringify(this.offlineTransactions));
        if (this.offlineTransactions.length === 0) {
            alert('All offline transactions synced!');
        }
    },

    formatPrice(value) {
        return new Intl.NumberFormat('id-ID', {
            style: 'currency',
            currency: 'IDR',
            minimumFractionDigits: 0
        }).format(value);
    }
});
