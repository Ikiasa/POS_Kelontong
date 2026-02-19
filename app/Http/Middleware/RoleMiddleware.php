<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class RoleMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next, ...$roles): Response
    {
        if (!auth()->check()) {
            return redirect('login');
        }

        $user = auth()->user();

        // Owner and Admin have access to everything
        if ($user->role === 'owner' || $user->role === 'admin') {
            return $next($request);
        }

        // Check if user's role is in the allowed roles list
        if (in_array($user->role, $roles)) {
            return $next($request);
        }

        abort(403, 'Unauthorized action.');
    }
}
