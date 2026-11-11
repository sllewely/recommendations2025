// src/hooks.client.ts
// Faro must be imported first so it captures errors from the moment the app loads
import { faro } from "./faro";
import type { HandleClientError } from "@sveltejs/kit";

// SvelteKit catches errors from load functions and rendering, so forward them to Faro
export const handleError: HandleClientError = ({ error, status, message }) => {
	if (status !== 404) {
		faro.api.pushError(error instanceof Error ? error : new Error(String(error)), {
			context: { status: String(status), message },
		});
	}
	return { message };
};
