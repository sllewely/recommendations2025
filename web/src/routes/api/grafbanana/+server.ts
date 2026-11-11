import type { RequestHandler } from "./$types";

// Proxies Faro telemetry to Grafana so ad blockers don't drop it and no CORS setup is needed.
// Named blandly on purpose: blocker filter lists match paths like /collect and /telemetry.
const FARO_COLLECTOR_URL =
	"https://faro-collector-prod-us-east-2.grafana.net/collect/315eb106c6a079c67a84bb56a416230f";

const FORWARDED_REQUEST_HEADERS = [
	"content-type",
	"content-encoding",
	"x-faro-session-id",
	"idempotency-key",
	"user-agent",
];
const FORWARDED_RESPONSE_HEADERS = ["retry-after", "x-faro-session-status"];

export const POST: RequestHandler = async ({ request, getClientAddress }) => {
	const headers = new Headers({ "x-forwarded-for": getClientAddress() });
	for (const name of FORWARDED_REQUEST_HEADERS) {
		const value = request.headers.get(name);
		if (value) headers.set(name, value);
	}

	try {
		const upstream = await fetch(FARO_COLLECTOR_URL, {
			method: "POST",
			headers,
			body: await request.arrayBuffer(),
		});

		const responseHeaders = new Headers();
		for (const name of FORWARDED_RESPONSE_HEADERS) {
			const value = upstream.headers.get(name);
			if (value) responseHeaders.set(name, value);
		}
		return new Response(upstream.body, { status: upstream.status, headers: responseHeaders });
	} catch (error) {
		console.error("Faro proxy failed", error);
		return new Response(null, { status: 502 });
	}
};
