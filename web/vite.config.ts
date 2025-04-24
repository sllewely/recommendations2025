import {sveltekit} from '@sveltejs/kit/vite';
import {defineConfig, loadEnv} from 'vite';
import tailwindcss from '@tailwindcss/vite'


export default defineConfig(({mode}) => {
    const env = loadEnv(mode, process.cwd());

    return {
        plugins: [sveltekit(), tailwindcss(),],
        server: {
            allowedHosts: JSON.parse(env.VITE_ALLOWED_HOSTS),
        },
        csrf: {
            checkOrigin: JSON.parse(env.VITE_CHECK_ORIGIN),
        }
    };
});

