<?php

use Illuminate\Http\Request;

define('LARAVEL_START', microtime(true));

// 1. Force error reporting (Verbose)
ini_set('display_errors', '1');
ini_set('display_startup_errors', '1');
error_reporting(E_ALL);

// 2. Validate Vercel Environment Variables
if (isset($_ENV['VERCEL'])) {
    $missingVars = [];
    $requiredVars = ['APP_KEY', 'DB_HOST', 'DB_DATABASE', 'DB_USERNAME', 'DB_PASSWORD'];
    
    foreach ($requiredVars as $var) {
        if (!getenv($var) && empty($_SERVER[$var]) && empty($_ENV[$var])) {
            $missingVars[] = $var;
        }
    }

    if (!empty($missingVars)) {
        http_response_code(500);
        echo "<div style='font-family: sans-serif; padding: 2rem; max-width: 600px; margin: 0 auto;'>";
        echo "<h1 style='color: #ef4444;'>Deployment Configuration Error</h1>";
        echo "<p>The following Environment Variables are missing in Vercel:</p>";
        echo "<ul style='background: #f4f4f5; padding: 1rem 2rem; border-radius: 8px;'>";
        foreach ($missingVars as $var) {
            echo "<li><strong>{$var}</strong></li>";
        }
        echo "</ul>";
        echo "<p>Please add them in <strong>Settings > Environment Variables</strong> on your Vercel Dashboard.</p>";
        echo "<p><em>Note: You cannot use localhost settings. You must use a cloud database (e.g. Neon, Supabase).</em></p>";
        echo "</div>";
        exit;
    }
}

// Determine if the application is in maintenance mode...
if (file_exists($maintenance = __DIR__.'/../storage/framework/maintenance.php')) {
    require $maintenance;
}

// Register the Composer autoloader...
require __DIR__.'/../vendor/autoload.php';

// Bootstrap Laravel and handle the request...
$app = require_once __DIR__.'/../bootstrap/app.php';

// Vercel specific adjustments
if (isset($_ENV['VERCEL'])) {
    $app->useStoragePath('/tmp/storage');
    
    // Ensure directories exist
    if (!is_dir('/tmp/storage')) {
        mkdir('/tmp/storage', 0755, true);
        mkdir('/tmp/storage/framework/views', 0755, true);
        mkdir('/tmp/storage/framework/cache', 0755, true);
        mkdir('/tmp/storage/framework/sessions', 0755, true);
        mkdir('/tmp/storage/logs', 0755, true);
    }
}

// Wrap in try-catch to debug Vercel 500
try {
    $app->handleRequest(Request::capture());
} catch (\Throwable $e) {
    http_response_code(500);
    echo "<h1>🔥 Vercel Error 500</h1>";
    echo "<p><strong>Message:</strong> " . htmlspecialchars($e->getMessage()) . "</p>";
    echo "<p><strong>File:</strong> " . htmlspecialchars($e->getFile()) . ":" . $e->getLine() . "</p>";
    echo "<pre>" . htmlspecialchars($e->getTraceAsString()) . "</pre>";
    exit;
}
