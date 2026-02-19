<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('whatsapp_logs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('customer_id')->nullable()->constrained()->nullOnDelete();
            $table->string('phone');
            $table->text('message');
            $table->string('type'); // 'receipt', 'promo', 'reminder'
            $table->string('status')->default('queued'); // queued, sent, failed
            
            $table->timestamp('sent_at')->nullable();
            $table->text('error_message')->nullable();
            
            $table->timestamps();
            
            $table->index(['status', 'created_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('whatsapp_logs');
    }
};
