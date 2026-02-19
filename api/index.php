<?php

use Illuminate\Http\Request;

define('LARAVEL_START', microtime(true));

// 1. Force error reporting (Verbose)
ini_set('display_errors', '1');
ini_set('display_startup_errors', '1');
error_reporting(E_ALL);

// 2. Validate Vercel Environment Variables
// We check for VERCEL env var or just assume we are in Vercel if the file is being hit locally via vercel dev
$isVercel = getenv('VERCEL') || isset($_ENV['VERCEL']);

if ($isVercel) {
    $missingVars = [];
    $requiredVars = ['APP_KEY', 'DB_HOST', 'DB_DATABASE', 'DB_USERNAME', 'DB_PASSWORD'];
    
    foreach ($requiredVars as $var) {
        if (!getenv($var) && empty($_SERVER[$var]) && empty($_ENV[$var])) {
            $missingVars[] = $var;
        }
    }

    if (!empty($missingVars)) {
        // Return 200 to ensure browser displays the message (Chrome hides 500s sometimes)
        http_response_code(200);
        echo "<div style='font-family: sans-serif; padding: 2rem; max-width: 600px; margin: 0 auto; border: 2px solid #ef4444; border-radius: 8px;'>";
        echo "<h1 style='color: #ef4444;'>❌ Deployment Configuration Error</h1>";
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
    
    // Validate APP_KEY length
    $appKey = getenv('APP_KEY');
    if ($appKey && str_starts_with($appKey, 'base64:')) {
        $key = base64_decode(substr($appKey, 7));
        if (strlen($key) !== 32) {
             http_response_code(200);
             echo "<div style='font-family: sans-serif; padding: 2rem; max-width: 600px; margin: 0 auto; border: 2px solid #f59e0b; border-radius: 8px;'>";
             echo "<h1 style='color: #f59e0b;'>⚠️ APP_KEY Configuraton Error</h1>";
             echo "<p>Your <strong>APP_KEY</strong> seems valid base64 but its length is incorrect.</p>";
             echo "<p>Required: <strong>32 bytes</strong> (for AES-256-CBC)</p>";
             echo "<p>Actual: <strong>" . strlen($key) . " bytes</strong></p>";
             echo "<p>Please regenerate it: <code>php artisan key:generate --show</code> and update Vercel Settings.</p>";
             echo "</div>";
             exit;
        }
    }

    // 3. Configure Cache Paths for Vercel (Read-Only Filesystem Fix)
    // Set these BEFORE bootstrap
    $tmpCache = '/tmp/cache';
    if (!is_dir($tmpCache)) mkdir($tmpCache, 0755, true);
    
    putenv("APP_PACKAGES_CACHE={$tmpCache}/packages.php");
    putenv("APP_SERVICES_CACHE={$tmpCache}/services.php");
    putenv("APP_ROUTES_CACHE={$tmpCache}/routes-v7.php");
    putenv("APP_EVENTS_CACHE={$tmpCache}/events.php");
    putenv("APP_CONFIG_CACHE={$tmpCache}/config.php");
    
    // Also set via $_ENV just in case
    $_ENV['APP_PACKAGES_CACHE'] = "{$tmpCache}/packages.php";
    $_ENV['APP_SERVICES_CACHE'] = "{$tmpCache}/services.php";
    $_ENV['APP_ROUTES_CACHE'] = "{$tmpCache}/routes-v7.php";
    $_ENV['APP_EVENTS_CACHE'] = "{$tmpCache}/events.php";
    $_ENV['APP_CONFIG_CACHE'] = "{$tmpCache}/config.php";
}

// Register the Composer autoloader...
require __DIR__.'/../vendor/autoload.php';

// Bootstrap Laravel and handle the request...
$app = require_once __DIR__.'/../bootstrap/app.php';

if ($isVercel) {
    $app->useStoragePath('/tmp/storage');
    
    // Ensure storage directories exist
    $storagePath = '/tmp/storage';
    if (!is_dir($storagePath)) {
        mkdir($storagePath, 0755, true);
        mkdir("{$storagePath}/framework/views", 0755, true);
        mkdir("{$storagePath}/framework/cache", 0755, true);
        mkdir("{$storagePath}/framework/sessions", 0755, true);
        mkdir("{$storagePath}/logs", 0755, true);
    }
}

// Wrap in try-catch to debug Vercel 500
try {
    $app->handleRequest(Request::capture());
} catch (\Throwable $e) {
    http_response_code(200);
    echo "<h1>🔥 Vercel Error 500</h1>";
    echo "<p><strong>Message:</strong> " . htmlspecialchars($e->getMessage()) . "</p>";
    echo "<p><strong>File:</strong> " . htmlspecialchars($e->getFile()) . ":" . $e->getLine() . "</p>";
    if ($prev = $e->getPrevious()) {
        echo "<hr><h3 style='color: orange'>Root Cause (Previous Exception):</h3>";
        echo "<p><strong>Message:</strong> " . htmlspecialchars($prev->getMessage()) . "</p>";
        echo "<p><strong>File:</strong> " . htmlspecialchars($prev->getFile()) . ":" . $prev->getLine() . "</p>";
        echo "<pre>" . htmlspecialchars($prev->getTraceAsString()) . "</pre>";
    }
    echo "<hr><h3>Stack Trace:</h3>";
    echo "<pre>" . htmlspecialchars($e->getTraceAsString()) . "</pre>";
    exit;
}
