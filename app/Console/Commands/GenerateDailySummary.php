<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Services\DailySummaryService;
use App\Models\Store;
use Illuminate\Support\Facades\Log;

class GenerateDailySummary extends Command
{
    protected $signature = 'app:generate-summary {--store=} {--date=}';
    protected $description = 'Generate daily business summary for stores';

    public function handle(DailySummaryService $summaryService)
    {
        $storeId = $this->option('store');
        $date = $this->option('date') ?? now()->subDay()->toDateString();

        $stores = $storeId ? [Store::find($storeId)] : Store::all();

        foreach ($stores as $store) {
            $summary = $summaryService->generateDailySummary($store->id, $date);
            $message = $summaryService->formatForWhatsApp($summary);
            
            // In a real app, this would send to WhatsApp/Email
            $this->info("Summary generated for {$store->name} [{$date}]");
            Log::info("DAILY SUMMARY: " . $message);
        }

        return Command::SUCCESS;
    }
}
