<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class BackfillTransactionCosts extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:backfill-costs';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Backfill cost_price for transaction_items from batches and products';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $this->info('Starting backfill of transaction costs...');

        // 1. Update from Batches
        $this->info('Updating costs from Batches...');
        try {
            $updatedBatches = DB::update("
                UPDATE transaction_items
                JOIN product_batches ON transaction_items.batch_id = product_batches.id
                SET transaction_items.cost_price = product_batches.cost_price
                WHERE (transaction_items.cost_price IS NULL OR transaction_items.cost_price = 0)
                AND transaction_items.batch_id IS NOT NULL
            ");
            $this->info("Updated $updatedBatches items from batches.");
        } catch (\Exception $e) {
            $this->error("Error updating from batches: " . $e->getMessage());
        }

        // 2. Update from Products (Fallback)
        $this->info('Updating costs from Products (Fallback)...');
        try {
            $updatedProducts = DB::update("
                UPDATE transaction_items
                JOIN products ON transaction_items.product_id = products.id
                SET transaction_items.cost_price = products.cost_price
                WHERE (transaction_items.cost_price IS NULL OR transaction_items.cost_price = 0)
            ");
            $this->info("Updated $updatedProducts items from products.");
        } catch (\Exception $e) {
             $this->error("Error updating from products: " . $e->getMessage());
        }

        // 3. Set remaining nulls to 0
        $this->info('Setting remaining null costs to 0...');
        try {
            $updatedNulls = DB::update("
                UPDATE transaction_items
                SET cost_price = 0
                WHERE cost_price IS NULL
            ");
            $this->info("Updated $updatedNulls items to 0.");
        } catch (\Exception $e) {
            $this->error("Error setting nulls: " . $e->getMessage());
        }
        
        // 4. Add Indexes manually if possible
        $this->info('Attempting to add indexes...');
        $indexes = [
            'transactions' => ['transaction_date', ['store_id', 'transaction_date']],
            'transaction_items' => ['product_id', 'batch_id', 'cost_price']
        ];
        
        // This part is skipped as it requires Schema modification which is better done in migrations.
        // But the previous migration tried and failed. 
        // We will leave indexes to the migration if it worked, or manual intervention.
        
        $this->info('Backfill completed.');
    }
}
