<?php

use Illuminate\Http\Request;

define('LARAVEL_START', microtime(true));

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

$app->handleRequest(Request::capture());
