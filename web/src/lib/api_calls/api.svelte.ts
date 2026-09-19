import { VITE_API_URL } from "$env/static/private";
import type { ApiError, ApiResponse } from "./types";

const root_url = VITE_API_URL;
type HttpMethod = "GET" | "POST" | "PUT" | "DELETE" | "PATCH";

interface RequestOptions<T = unknown> {
	method: HttpMethod;
	path: string;
	data?: T;
	token?: string;
}

/**
 * Checks if an API response indicates the user is not logged in / unauthorized
 */
export function isUnauthorized(response?: ApiResponse<unknown> | null): boolean {
	if (!response) return false;
	return Boolean(response.unauthorized || response.status === 401);
}

export function isNotLoggedIn(response?: ApiResponse<unknown> | null): boolean {
	return isUnauthorized(response);
}

/**
 * Sends an HTTP request to the API
 * @throws {Error} If the request fails
 */
async function send<T = unknown, D = unknown>({
	method,
	path,
	data,
	token,
}: RequestOptions<D>): Promise<ApiResponse<T>> {
	const headers = new Headers();

	const opts: RequestInit = {
		method,
		headers,
	};

	if (data) {
		headers.set("Content-Type", "application/json");
		opts.body = JSON.stringify(data);
	}

	if (token) {
		headers.set("Authorization", `Token ${token}`);
	}

	try {
		const res = await fetch(`${root_url}/${path}`, opts);

		// Del returns 204 and no body
		if (method === "DELETE" && res.ok) {
			return { success: true, res: null as T, status: res.status };
		}

		let json: any = null;
		const text = await res.text();
		try {
			json = text ? JSON.parse(text) : null;
		} catch {
			json = null;
		}

		if (res.ok) {
			return { success: true, res: (json ?? null) as T, status: res.status };
		} else {
			const isUnauth = res.status === 401;
			const error = json as ApiError | null;
			return {
				success: false,
				status: res.status,
				unauthorized: isUnauth,
				message:
					error?.exception ??
					error?.error ??
					(isUnauth ? "Not logged in" : text || "Network error occurred"),
			};
		}
	} catch (e) {
		return {
			success: false,
			message: e instanceof Error ? e.message : "Network error occurred",
		};
	}
}

/**
 * Makes a GET request to the API
 */
export function get<T = unknown>(path: string, token?: string): Promise<ApiResponse<T>> {
	return send<T>({ method: "GET", path, token });
}

/**
 * Makes a DELETE request to the API
 */
export function del<T = unknown>(path: string, token?: string): Promise<ApiResponse<T>> {
	return send<T>({ method: "DELETE", path, token });
}

/**
 * Makes a POST request to the API
 */
export function post<T = unknown, D = unknown>(
	path: string,
	data: D,
	token?: string,
): Promise<ApiResponse<T>> {
	return send<T, D>({ method: "POST", path, data, token });
}

/**
 * Makes a PUT request to the API
 */
export function put<T = unknown, D = unknown>(
	path: string,
	data: D,
	token?: string,
): Promise<ApiResponse<T>> {
	return send<T, D>({ method: "PUT", path, data, token });
}

/**
 * Makes a PATCH request to the API
 */
export function patch<T = unknown, D = unknown>(
	path: string,
	data: D,
	token?: string,
): Promise<ApiResponse<T>> {
	return send<T, D>({ method: "PATCH", path, data, token });
}
