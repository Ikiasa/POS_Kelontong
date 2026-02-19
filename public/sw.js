const CACHE_NAME = 'kelontongku-v1';
const ASSETS_TO_CACHE = [
    // '/pos', // HTML shell - disable in dev to avoid auth/redirect issues
    // '/css/app.css', // Disable in dev (Vite)
    // '/js/app.js',   // Disable in dev (Vite)
    // '/icons/icon-192x192.png', // Ensure these exist
    // '/icons/icon-512x512.png'
];

self.addEventListener('install', (event) => {
    event.waitUntil(
        caches.open(CACHE_NAME).then((cache) => {
            return cache.addAll(ASSETS_TO_CACHE);
        })
    );
});

self.addEventListener('fetch', (event) => {
    // Helper to determine if it's an API call
    if (event.request.url.includes('/api/')) {
        event.respondWith(
            fetch(event.request).catch(() => {
                // Return offline fallback if API fails
                return caches.match('/offline-api-fallback.json');
            })
        );
        return;
    }

    // IGNORE VITE DEV SERVER REQUESTS
    if (event.request.url.includes(':5173')) {
        return;
    }

    event.respondWith(
        caches.match(event.request).then((response) => {
            return response || fetch(event.request);
        })
    );
});
