import { initializeFaro, getWebInstrumentations } from "@grafana/faro-web-sdk";
import { TracingInstrumentation } from "@grafana/faro-web-tracing";

export const faro = initializeFaro({
	url: "https://faro-collector-prod-us-east-2.grafana.net/collect/315eb106c6a079c67a84bb56a416230f",
	app: {
		name: "bumblebeans-frontend",
		version: "0.0.1",
		environment: import.meta.env.MODE,
	},
	ignoreErrors: [
		// Layout quirks — harmless, not real errors
		/^ResizeObserver loop limit exceeded$/,
		/^ResizeObserver loop completed with undelivered notifications$/,
		// Cross-origin scripts with no useful stack
		/^Script error\.$/,
		// Browser extension interference
		/chrome-extension:\/\//,
		/moz-extension:\/\//,
	],
	ignoreUrls: [
		// Umami analytics
		/cloud\.umami\.is/,
		/api-gateway\.umami\.dev/,
		// Mapbox tiles, styles, and telemetry
		/mapbox\.com/,
	],
	instrumentations: [...getWebInstrumentations(), new TracingInstrumentation()],
});
