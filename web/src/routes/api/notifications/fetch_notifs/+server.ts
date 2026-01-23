import * as api from "$lib/api_calls/api.svelte";
import { json } from "@sveltejs/kit";

// Fetch notifications for the current user
export async function GET({ url, cookies }) {
	const jwt = cookies.get("jwt");

	// TODO: error handling
	// Get page from URL query parameter, default to 1 if not provided
	const page = url.searchParams.get("page") ?? "1";

	const response = await api.get("notifications?page=" + page, jwt);

	return json(response);
}
