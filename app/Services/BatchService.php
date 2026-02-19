<?php

namespace App\Services;

use App\Models\ProductBatch;
use Illuminate\Support\Facades\DB;
use Exception;

class BatchService
{
    /**
     * Add new stock batch.
     */
    public function addBatch(int $storeId, int $productId, int $quantity, float $costPrice, ?string $expiryDate = null): ProductBatch
    {
        // Generate Batch Number: BATCH-YYYYMM-SEQ
        $prefix = 'BATCH-' . date('Ym');
        $count = ProductBatch::where('batch_number', 'like', "$prefix%")->count() + 1;
        $batchNumber = $prefix . '-' . str_pad($count, 4, '0', STR_PAD_LEFT);

        return ProductBatch::create([
            'store_id' => $storeId,
            'product_id' => $productId,
            'batch_number' => $batchNumber,
            'expiry_date' => $expiryDate,
            'cost_price' => $costPrice,
            'initial_quantity' => $quantity,
            'current_quantity' => $quantity,
            'received_at' => now(),
        ]);
    }

    /**
     * Deduct stock using FIFO/FEFO logic.
     * Returns array of batches affected with cost analysis.
     */
    public function deductStock(int $storeId, int $productId, int $quantity): array
    {
        $affectedBatches = [];
        $remainingToDeduct = $quantity;

        // FEFO (First Expired First Out) prioritized, then FIFO (First In First Out)
        // [SAFETY] Lock rows to prevent race conditions
        $batches = ProductBatch::where('store_id', $storeId)
            ->where('product_id', $productId)
            ->where('current_quantity', '>', 0)
            ->orderByRaw('expiry_date IS NULL, expiry_date ASC') // Null expiry treated as last (or handle as per policy)
            ->orderBy('received_at', 'ASC')
            ->lockForUpdate()
            ->get();

        // [VALIDATION] Check total availability first
        if ($batches->sum('current_quantity') < $quantity) {
             // Fallback: If no batches exist (or insufficient), we might allow negative on a "default" virtual batch 
             // IF config allows. For now, strict mode.
            throw new Exception("Insufficient stock in batches for Product ID $productId. Requested: $quantity, Available: " . $batches->sum('current_quantity'));
        }

        foreach ($batches as $batch) {
            if ($remainingToDeduct <= 0) break;

            // [LOGIC] Don't sell expired batches? 
            // If strictly enforced:
            // if ($batch->expiry_date && $batch->expiry_date < now()) continue;

            $deduct = min($batch->current_quantity, $remainingToDeduct);
            
            $batch->decrement('current_quantity', $deduct);
            
            $affectedBatches[] = [
                'batch_id' => $batch->id,
                'batch_number' => $batch->batch_number,
                'quantity' => $deduct,
                'cost_price' => $batch->cost_price,
                'total_cost' => $deduct * $batch->cost_price
            ];

            $remainingToDeduct -= $deduct;
        }

        return $affectedBatches;
    }
}
