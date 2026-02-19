<?php

namespace App\Http\Controllers;

use App\Models\AuditLog;
use App\Models\FraudAlert;
use App\Models\User;
use Illuminate\Http\Request;

class AuditController extends Controller
{
    public function index(Request $request)
    {
        try {
            // 1. Fetch Fraud Alerts (Unresolved on top)
            $alerts = FraudAlert::with('user')->latest()->get();

            // 2. Fetch Audit Logs with Filtering
            $query = AuditLog::with('user')->latest();

            if ($request->has('user_id') && $request->user_id) {
                $query->where('user_id', $request->user_id);
            }

            if ($request->has('action') && $request->action) {
                $query->where('action', 'LIKE', "%{$request->action}%");
            }
            
            if ($request->has('date') && $request->date) {
                $query->whereDate('created_at', $request->date);
            }

            $logs = $query->paginate(20);
            $users = User::all();

            return \Inertia\Inertia::render('Admin/Audit/Index', [
                'logs' => $logs,
                'alerts' => $alerts,
                'users' => $users,
                'filters' => $request->only(['user_id', 'action', 'date'])
            ]);
        } catch (\Throwable $e) {
            \Illuminate\Support\Facades\Log::error("Audit Page 500: " . $e->getMessage());
            return \Inertia\Inertia::render('Admin/Audit/Index', [
                'logs' => ['data' => [], 'total' => 0],
                'alerts' => [],
                'users' => [],
                'filters' => [],
                'flash' => ['error' => 'Audit log schema sync required.']
            ]);
        }
    }

    public function resolveAlert($id)
    {
        $alert = FraudAlert::findOrFail($id);
        $alert->update([
            'resolved' => true,
            'resolved_at' => now(),
            'resolved_by' => auth()->id(),
        ]);

        return back()->with('success', 'Alert marked as resolved.');
    }
}
