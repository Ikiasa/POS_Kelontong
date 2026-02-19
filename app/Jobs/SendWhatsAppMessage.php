<?php

namespace App\Jobs;

use App\Models\WhatsAppLog;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;

class SendWhatsAppMessage implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    /**
     * Create a new job instance.
     */
    public function __construct(protected WhatsAppLog $log) {}

    /**
     * Execute the job.
     */
    public function handle(): void
    {
        // Simulate API call to 3rd party (Twilio, Wavbox, etc.)
        try {
            // Simulate network delay
            sleep(1);

            // Mock Success
            // In real world: Http::post('https://api.whatsapp.provider/send', ...)
            
            Log::info("WhatsApp Sent to {$this->log->phone}: {$this->log->message}");

            $this->log->update([
                'status' => 'sent',
                'sent_at' => now(),
            ]);

        } catch (\Exception $e) {
            $this->log->update([
                'status' => 'failed',
                'error_message' => $e->getMessage(),
            ]);
            
            Log::error("WhatsApp Failed: " . $e->getMessage());
        }
    }
}
