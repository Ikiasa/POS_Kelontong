<?php

namespace App\Jobs;

use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;

class CalculateBusinessIntelligence implements ShouldQueue
{
    use Queueable;

    /**
     * Create a new job instance.
     */
    public function __construct()
    {
        //
    }

    public function handle(
        \App\Services\BusinessHealthService $healthService,
        \App\Services\ProfitLeakService $leakService
    ): void {
        $stores = \App\Models\Store::all();

        foreach ($stores as $store) {
            $healthService->calculate($store->id);
            $leakService->analyzeStore($store->id);
        }

        // Also analyze employees (top 10 active)
        $employees = \App\Models\User::where('role', 'cashier')->take(10)->get();
        foreach ($employees as $employee) {
            $leakService->analyzeEmployee($employee->id);
        }
    }
}
