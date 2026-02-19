<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // 1. Upgrade Categories for Hierarchical (8 levels)
        Schema::table('categories', function (Blueprint $table) {
            $table->foreignId('parent_id')->nullable()->constrained('categories')->nullOnDelete();
            $table->integer('depth')->default(0); // 0-7 for 8 levels
            $table->boolean('is_active')->default(true);
        });

        // 2. Upgrade Products for Enterprise Management
        Schema::table('products', function (Blueprint $table) {
            // Consignment logic
            $table->boolean('is_consignment')->default(false);
            $table->decimal('commission_rate', 5, 2)->default(0); // Percentage
            
            // Inventory Logic for Auto-PR
            $table->integer('min_stock')->default(5);
            $table->integer('suggested_order_qty')->default(20);
            
            // Scale / Fresh Food Integration
            $table->boolean('is_weighted')->default(false); // Weight-based items
            $table->string('unit_type')->default('pcs'); // pcs, kg, gr, etc
        });

        // 3. Create Purchase Requests Table
        Schema::create('purchase_requests', function (Blueprint $table) {
            $table->id();
            $table->foreignId('store_id')->constrained();
            $table->foreignId('user_id')->constrained();
            $table->string('pr_number')->unique();
            $table->string('status')->default('draft'); // draft, submitted, approved, converted_to_po
            $table->text('notes')->nullable();
            $table->timestamps();
        });

        Schema::create('purchase_request_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('purchase_request_id')->constrained()->cascadeOnDelete();
            $table->foreignId('product_id')->constrained();
            $table->integer('quantity');
            $table->decimal('estimated_cost', 15, 2)->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('purchase_request_items');
        Schema::dropIfExists('purchase_requests');
        Schema::table('products', function (Blueprint $table) {
            $table->dropColumn(['is_consignment', 'commission_rate', 'min_stock', 'suggested_order_qty', 'is_weighted', 'unit_type']);
        });
        Schema::table('categories', function (Blueprint $table) {
            $table->dropForeign(['parent_id']);
            $table->dropColumn(['parent_id', 'depth', 'is_active']);
        });
    }
};
