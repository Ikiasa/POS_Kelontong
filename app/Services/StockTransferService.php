<?php

namespace App\Services;

use App\Models\StockTransfer;
use App\Models\StockTransferItem;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Exception;

class StockTransferService
{
    public function __construct(protected StockMovementService $stockService) {}

    /**
     * Create a draft transfer.
     */
    public function createTransfer(int $sourceStoreId, int $destStoreId, array $items, ?string $notes = null): StockTransfer
    {
        return DB::transaction(function () use ($sourceStoreId, $destStoreId, $items, $notes) {
            $transfer = StockTransfer::create([
                'transfer_number' => 'TRF-' . strtoupper(Str::random(8)),
                'source_store_id' => $sourceStoreId,
                'dest_store_id' => $destStoreId,
                'created_by' => auth()->id(),
                'status' => 'pending',
                'notes' => $notes,
            ]);

            foreach ($items as $item) {
                StockTransferItem::create([
                    'stock_transfer_id' => $transfer->id,
                    'product_id' => $item['product_id'],
                    'request_quantity' => $item['quantity'],
                ]);
            }

            return $transfer;
        });
    }

    /**
     * Ship the transfer (Deduct from Source).
     */
    public function shipTransfer(int $transferId): StockTransfer
    {
        return DB::transaction(function () use ($transferId) {
            $transfer = StockTransfer::with('items')->lockForUpdate()->find($transferId);

            if ($transfer->status !== 'pending') {
                throw new Exception("Transfer must be pending to ship.");
            }

            foreach ($transfer->items as $item) {
                // Deduct from Source Store
                $this->stockService->recordMovement(
                    $transfer->source_store_id,
                    $item->product_id,
                    -$item->request_quantity,
                    'transfer_out',
                    $transfer->id, // String ID supported now
                    "Shipped to Store #{$transfer->dest_store_id}"
                );

                $item->update(['shipped_quantity' => $item->request_quantity]);
            }

            $transfer->update([
                'status' => 'in_transit',
                'shipped_at' => now(),
            ]);

            return $transfer;
        });
    }

    /**
     * Receive the transfer (Add to Dest).
     */
    public function receiveTransfer(int $transferId, array $receivedQuantities): StockTransfer
    {
        return DB::transaction(function () use ($transferId, $receivedQuantities) {
            $transfer = StockTransfer::with('items')->lockForUpdate()->find($transferId);

            if ($transfer->status !== 'in_transit') {
                throw new Exception("Transfer must be in_transit to receive.");
            }

            foreach ($transfer->items as $item) {
                $qty = $receivedQuantities[$item->id] ?? $item->shipped_quantity;

                // Add to Destination Store
                $this->stockService->recordMovement(
                    $transfer->dest_store_id,
                    $item->product_id,
                    $qty,
                    'transfer_in',
                    $transfer->id,
                    "Received from Store #{$transfer->source_store_id}"
                );

                $item->update(['received_quantity' => $qty]);
            }

            $transfer->update([
                'status' => 'received',
                'received_at' => now(),
                'received_by' => auth()->id(),
            ]);

            return $transfer;
        });
    }
}
