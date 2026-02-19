import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import tailwindcss from '@tailwindcss/vite';
import vue from '@vitejs/plugin-vue';
import { VitePWA } from 'vite-plugin-pwa';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/inertia.js', 'resources/js/pos.js'],
            refresh: true,
        }),
        vue({
            template: {
                transformAssetUrls: {
                    base: null,
                    includeAbsolute: false,
                },
            },
        }),
        tailwindcss(),
        VitePWA({
            registerType: 'autoUpdate',
            injectRegister: 'auto',
            manifest: {
                name: 'POS Kelontong Modern',
                short_name: 'POSKelontong',
                description: 'Point of Sale modern for Kelontong businesses',
                theme_color: '#4f46e5',
                icons: [
                    {
                        src: 'https://via.placeholder.com/192',
                        sizes: '192x192',
                        type: 'image/png'
                    },
                    {
                        src: 'https://via.placeholder.com/512',
                        sizes: '512x512',
                        type: 'image/png'
                    }
                ]
            }
        })
    ],
    server: {
        watch: {
            ignored: ['**/storage/framework/views/**'],
        },
    },
    resolve: {
        alias: {
            '@': '/resources/js',
        },
    },
});
