<?php

namespace App\Http\Controllers;

use App\Services\InsightEngineService;
use Illuminate\Http\Request;

class AIInsightController extends Controller
{
    public function approve($id, InsightEngineService $service)
    {
        $service->approveInsight($id);
        $service->applyInsight($id);
        return response()->json(['success' => true]);
    }

    public function dismiss($id)
    {
        \App\Models\AIInsight::findOrFail($id)->update(['status' => 'dismissed']);
        return response()->json(['success' => true]);
    }
}
