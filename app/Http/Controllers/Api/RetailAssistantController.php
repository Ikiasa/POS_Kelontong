<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\RetailAssistantService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class RetailAssistantController extends Controller
{
    protected $retailAssistant;

    public function __construct(RetailAssistantService $retailAssistant)
    {
        $this->retailAssistant = $retailAssistant;
    }

    public function dashboardSummary(Request $request)
    {
        $storeId = $this->getStoreId($request);

        return response()->json([
            'health_score' => $this->retailAssistant->getBusinessHealthScore($storeId),
            'expiry_risk' => $this->retailAssistant->getExpiryIntelligence($storeId),
            'insights' => $this->retailAssistant->getAiInsights($storeId),
        ]);
    }

    public function reorderSuggestions(Request $request)
    {
        $storeId = $this->getStoreId($request);
        $data = $this->retailAssistant->getSmartReorderSuggestions($storeId);
        return response()->json($data);
    }

    public function deadStock(Request $request)
    {
        $storeId = $this->getStoreId($request);
        $data = $this->retailAssistant->getDeadStockAnalysis($storeId);
        return response()->json($data);
    }

    public function expiryAlerts(Request $request)
    {
        $storeId = $this->getStoreId($request);
        $data = $this->retailAssistant->getExpiryMonitor($storeId);
        return response()->json($data);
    }

    public function healthScore(Request $request)
    {
        $storeId = $this->getStoreId($request);
        $data = $this->retailAssistant->getBusinessHealthScore($storeId);
        return response()->json($data);
    }

    public function insights(Request $request)
    {
        $storeId = $this->getStoreId($request);
        $data = $this->retailAssistant->getAiInsights($storeId);
        return response()->json($data);
    }

    private function getStoreId(Request $request)
    {
        // Assuming user is authenticated and belongs to a store
        // Or passed as a query param if admin viewing a specific store
        $user = Auth::user();
        if ($user && $user->store_id) {
            return $user->store_id;
        }

        // Fallback for demo/testing or multi-store admin
        return $request->input('store_id', 1);
    }
}
