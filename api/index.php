<?php

use Illuminate\Http\Request;

define('LARAVEL_START', microtime(true));

// Force error reporting for debugging Vercel 500
ini_set('display_errors', '1');
ini_set('display_startup_errors', '1');
ini_set('log_errors', '1');
ini_set('error_log', 'php://stderr');
error_reporting(E_ALL);

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
