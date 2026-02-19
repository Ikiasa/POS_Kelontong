<?php

namespace App\Jobs;

use App\Services\ReorderService;
use App\Models\Store;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Cache;

class CalculateReorderNeeds implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public function handle(ReorderService $service): void
    {
        // For each store, calculate and cache suggestions
        Store::all()->each(function ($store) use ($service) {
            $suggestions = $service->getReorderSuggestions($store->id);
            
            // Cache for dashboard widget to consume quickly
            Cache::put("reorder_suggestions_{$store->id}", $suggestions, now()->addDay());
            
            // Optional: Send email/notification if critical
            if ($suggestions->isNotEmpty()) {
                // Notification logic here
            }
        });
    }
}
