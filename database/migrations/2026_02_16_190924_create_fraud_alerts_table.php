<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\Schema;

class CreateFraudAlertsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('fraud_alerts', function (Blueprint $table) {
            $table->id();
            $table->string('reference_id')->nullable()->index(); // e.g., Transaction ID (UUID)
            $table->string('model_type')->nullable(); // e.g., 'App\Models\Transaction'
            
            $table->string('rule_name'); // e.g., 'High Discount', 'Negative Margin'
            $table->text('description');
            $table->string('severity')->default('medium'); // low, medium, high, critical
            
            $table->foreignId('user_id')->nullable()->constrained('users')->nullOnDelete(); // Who triggered it
            $table->boolean('resolved')->default(false);
            $table->timestamp('resolved_at')->nullable();
            $table->foreignId('resolved_by')->nullable()->constrained('users')->nullOnDelete();
            
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('fraud_alerts');
    }
}
