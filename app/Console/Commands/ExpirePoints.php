<?php

namespace App\Console\Commands;

use App\Models\Customer;
use App\Models\LoyaltyLog;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

class ExpirePoints extends Command
{
    protected $signature = 'loyalty:expire';
    protected $description = 'Expire points older than 12 months';

    public function handle()
    {
        $threshold = now()->subMonths(12);

        // Find customers whose points are potentially old
        // Accurate expiry requires tracking per 'earn' log.
        // For simplicity, we deduct points that were earned more than 12 months ago
        // and haven't been 'expired' yet.
        
        $logs = LoyaltyLog::where('type', 'earn')
            ->where('created_at', '<', $threshold)
            ->where('is_expired', false)
            ->get();

        foreach ($logs as $log) {
            // Check if the customer still has these points (simplified)
            $pointsToExpire = min($log->points, $log->customer->points_balance);
            
            if ($pointsToExpire > 0) {
                DB::transaction(function () use ($log, $pointsToExpire) {
                    $log->customer->decrement('points_balance', $pointsToExpire);
                    
                    LoyaltyLog::create([
                        'customer_id' => $log->customer_id,
                        'points' => -$pointsToExpire,
                        'type' => 'expire',
                        'description' => "Expired points from purchase on " . $log->created_at->format('Y-m-d'),
                    ]);

                    $log->update(['is_expired' => true]);
                });
            } else {
                $log->update(['is_expired' => true]); // Already used
            }
        }

        $this->info('Points expiry processed.');
    }
}
