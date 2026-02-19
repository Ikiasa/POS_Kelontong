<?php

namespace App\Services;

use App\Models\AuditLog;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Request;

class AuditService
{
    /**
     * Log a critical action.
     */
    public function log(
        string $action,
        Model $target,
        ?array $oldValues = null,
        ?array $newValues = null
    ): void {
        AuditLog::create([
            'user_id' => auth()->id(),
            'action' => $action,
            'target_type' => get_class($target),
            'target_id' => $target->getKey(), // Handles UUID or ID
            'old_values' => $oldValues,
            'new_values' => $newValues,
            'ip_address' => Request::ip(),
            'user_agent' => Request::userAgent(),
        ]);
    }

    public function logLogin($user)
    {
        $this->log('login', $user, null, ['ip' => Request::ip()]);
    }
}
