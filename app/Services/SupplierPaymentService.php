<?php

namespace App\Services;

use App\Models\PurchaseOrder;
use App\Models\SupplierPayment;
use App\Models\Supplier;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class SupplierPaymentService
{
    /**
     * Get all unpaid received orders for a supplier across all stores.
     */
    public function getOutstandingOrders(int $supplierId)
    {
        return PurchaseOrder::where('supplier_id', $supplierId)
            ->where('status', 'received')
            ->where('payment_status', 'pending')
            ->with('store')
            ->get();
    }

    /**
     * Process a consolidated payment for a supplier.
     */
    public function processConsolidatedPayment(array $data, int $userId): SupplierPayment
    {
        return DB::transaction(function () use ($data, $userId) {
            $supplierId = $data['supplier_id'];
            $orderIds = $data['order_ids'];

            // 1. Fetch orders and verify total
            $orders = PurchaseOrder::whereIn('id', $orderIds)
                ->where('supplier_id', $supplierId)
                ->where('payment_status', 'pending')
                ->lockForUpdate()
                ->get();

            if ($orders->isEmpty()) {
                throw new \Exception("No pending orders found for payment.");
            }

            $totalAmount = $orders->sum('total_amount');

            // 2. Create the Consolidated Payment Record
            $payment = SupplierPayment::create([
                'supplier_id' => $supplierId,
                'user_id' => $userId,
                'payment_number' => 'SPAY-' . strtoupper(Str::random(8)),
                'total_amount' => $totalAmount,
                'payment_method' => $data['payment_method'],
                'payment_date' => $data['payment_date'] ?? now(),
                'reference_number' => $data['reference_number'] ?? null,
                'notes' => $data['notes'] ?? null,
            ]);

            // 3. Mark Purchase Orders as Paid
            foreach ($orders as $order) {
                $order->update([
                    'payment_status' => 'paid',
                    'supplier_payment_id' => $payment->id
                ]);
            }

            return $payment;
        });
    }

    /**
     * Get orders due for specific payment cycle (e.g., Weekly, Bi-weekly).
     */
    public function getOrdersByCycle(int $supplierId, string $cycleType = 'weekly')
    {
        $query = PurchaseOrder::where('supplier_id', $supplierId)
            ->where('status', 'received')
            ->where('payment_status', 'pending');

        if ($cycleType === 'weekly') {
            $query->where('received_at', '<=', now()->subDays(7));
        }

        return $query->get();
    }
}
