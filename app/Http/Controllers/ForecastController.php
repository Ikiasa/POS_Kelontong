<?php

namespace App\Http\Controllers;

use App\Services\ForecastService;
use App\Services\PricingIntelligenceService;
use Illuminate\Http\Request;
use Inertia\Inertia;

class ForecastController extends Controller
{
    public function __construct(
        protected ForecastService $forecastService,
        protected PricingIntelligenceService $pricingService
    ) {}

    public function index()
    {
        $storeId = auth()->user()->store_id ?? 1;

        $forecast = $this->forecastService->getMonthlyForecast($storeId);
        // $suggestions = $this->pricingService->getPricingSuggestions($storeId); // Temporarily disabled if not needed for chart

        return Inertia::render('Forecast/Index', [
            'forecast' => $forecast
        ]);
    }

    public function applySuggestion(Request $request)
    {
        $request->validate(['product_id' => 'required|exists:products,id', 'price' => 'required|numeric']);
        
        \App\Models\Product::where('id', $request->product_id)->update(['price' => $request->price]);

        return back()->with('success', 'Price updated successfully.');
    }
}
