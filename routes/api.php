<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

use App\Http\Controllers\Api\RetailAssistantController;

Route::prefix('assistant')->group(function () {
    Route::get('/dashboard-summary', [RetailAssistantController::class, 'dashboardSummary']);
    Route::get('/reorder', [RetailAssistantController::class, 'reorderSuggestions']);
    Route::get('/dead-stock', [RetailAssistantController::class, 'deadStock']);
    Route::get('/expiry', [RetailAssistantController::class, 'expiryAlerts']);
    Route::get('/health-score', [RetailAssistantController::class, 'healthScore']);
    Route::get('/insights', [RetailAssistantController::class, 'insights']);
});
