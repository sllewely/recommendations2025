import { json } from "@sveltejs/kit";
import * as api from "$lib/api_calls/api.svelte.js";

// Log out the user
export async function POST({ request, cookies }) {
	const jwt = cookies.get("jwt");
	const friend_request_request: { user_id: String } = await request.json();

	const response = await api.post(
		"friend_requests",
		{ user_id: friend_request_request.user_id },
		jwt,
	);

	return json(response["res"]);
}
