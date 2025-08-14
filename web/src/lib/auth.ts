import { redirect } from "@sveltejs/kit";
import type { Cookies, RequestEvent } from "@sveltejs/kit";

/**
 * Gets the JWT token and user_id from cookies
 * @param {Cookies} cookies - The cookies object from SvelteKit
 * @returns {{ jwt: string | null, user_id: string | null }} An object with jwt and user_id or null if not found
 */
export function parseCookies(cookies: Cookies): { jwt: string | null; user_id: string | null } {
	const jwt = cookies.get("jwt") ?? null;
	const user_id = cookies.get("user_id") ?? null;
	return { jwt, user_id };
}

/**
 * Ensures the user is authenticated by checking for JWT
 * @param {Cookies} cookies - The cookies object from SvelteKit
 * @returns {{ jwt: string | null, user_id: string | null }} An object with jwt and user_id or null if not found
 * @throws {import("@sveltejs/kit").Redirect} Redirects to sign_in if no JWT found
 */
export function requireAuth(cookies: Cookies): { jwt: string; user_id: string } {
	const { jwt, user_id } = parseCookies(cookies);
	if (!jwt || !user_id) {
		throw redirect(302, "/sign_in");
	}
	return { jwt, user_id };
}

// Base type for any authenticated context
export type AuthContext = Pick<RequestEvent, "cookies" | "params">;

// Type for authenticated load functions
export type LoadAuthContext = AuthContext & { jwt: string; user_id: string };

// Type for authenticated action functions
export type ActionAuthContext = AuthContext &
	Pick<RequestEvent, "request"> & { jwt: string; user_id: string };

/**
 * Creates an authenticated API request handler
 * @param {Function} apiCall - The API function to call (e.g. get, post, etc.)
 * @returns {Function} A function that handles the authenticated API call
 */
export function withAuth<T extends AuthContext, R = unknown>(
	apiCall: (context: T & { jwt: string; user_id: string }) => Promise<R>,
) {
	return async (context: T): Promise<R> => {
		const { jwt, user_id } = requireAuth(context.cookies);
		return apiCall({ ...context, jwt, user_id });
	};
}
