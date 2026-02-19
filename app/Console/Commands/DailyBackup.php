<?php

namespace App\Console\Commands;

use App\Services\BackupService;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Log;

class DailyBackup extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'backup:daily';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Run daily database backup';

    /**
     * Execute the console command.
     */
    public function handle(BackupService $backupService)
    {
        $this->info('Starting backup...');
        
        $result = $backupService->runBackup();
        
        if ($result['success']) {
            $this->info("Backup successful: " . $result['path']);
            Log::info("Daily Backup Successful: " . $result['path']);
        } else {
            $this->error("Backup failed: " . $result['message']);
            Log::error("Daily Backup Failed: " . $result['message']);
        }
    }
}
