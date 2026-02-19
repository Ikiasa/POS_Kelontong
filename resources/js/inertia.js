import '../css/app.css';
import { createApp, h } from 'vue';
import { createInertiaApp } from '@inertiajs/vue3';
import { resolvePageComponent } from 'laravel-vite-plugin/inertia-helpers';
import { createPinia } from 'pinia';
import { ZiggyVue } from 'ziggy-js';
import VueApexCharts from 'vue3-apexcharts';
import { injectSpeedInsights } from '@vercel/speed-insights';

const appName = import.meta.env.VITE_APP_NAME || 'POS System';

createInertiaApp({
    title: (title) => `${title} - ${appName}`,
    resolve: (name) => resolvePageComponent(`./Pages/${name}.vue`, import.meta.glob('./Pages/**/*.vue')),
    setup({ el, App, props, plugin }) {
        const pinia = createPinia();

        const app = createApp({ render: () => h(App, props) })
            .use(plugin)
            .use(ZiggyVue)
            .use(pinia)
            .use(VueApexCharts);

        app.mount(el);

        // Inject Speed Insights
        injectSpeedInsights();

        return app;
    },
    progress: {
        color: '#4B5563',
    },
});
