import Dexie from 'dexie';
import axios from 'axios';

// Initialize Local Database
const db = new Dexie('POS_OfflineDB');
db.version(1).stores({
    transactions: '++id, status, timestamp',
    products: 'id, barcode, name'
});

class OfflineSyncService {
    constructor() {
        this.isOnline = navigator.onLine;
        window.addEventListener('online', () => this.handleOnline());
        window.addEventListener('offline', () => this.handleOffline());
    }

    handleOnline() {
        this.isOnline = true;
        this.syncPendingTransactions();
    }

    handleOffline() {
        this.isOnline = false;
    }

    async saveTransactionLocally(transaction) {
        return await db.transactions.add({
            ...transaction,
            status: 'pending',
            timestamp: new Date().toISOString()
        });
    }

    async getPendingTransactions() {
        return await db.transactions.where('status').equals('pending').toArray();
    }

    async syncPendingTransactions() {
        if (!this.isOnline) return;

        const pending = await this.getPendingTransactions();
        if (pending.length === 0) return;

        console.log(`Syncing ${pending.length} pending transactions...`);

        for (const tx of pending) {
            try {
                const response = await axios.post('/sales', tx);
                if (response.data.success) {
                    await db.transactions.delete(tx.id);
                }
            } catch (error) {
                console.error('Failed to sync transaction:', error);
                // Keep in DB to try again later
            }
        }
    }

    // Cache products for offline lookup
    async cacheProducts(products) {
        await db.products.clear();
        return await db.products.bulkAdd(products);
    }

    async searchProductOffline(query) {
        return await db.products
            .where('barcode').equals(query)
            .or('name').startsWithAnyOfIgnoreCase([query])
            .toArray();
    }
}

export const offlineSync = new OfflineSyncService();
export default offlineSync;
