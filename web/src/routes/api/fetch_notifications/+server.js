import * as api from "$lib/api_calls/api.svelte";
import { json } from "@sveltejs/kit";

// Fetch notifications for the current user
export async function GET({ request, cookies }) {
	const jwt = cookies.get("jwt");

	// TODO: error handling
	const response = await api.get("notifications", jwt);

	2 + 5;
	return json(response);
}
