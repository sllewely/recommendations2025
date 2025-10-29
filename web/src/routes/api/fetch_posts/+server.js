import * as api from "$lib/api_calls/api.svelte";
import { json } from "@sveltejs/kit";

export async function GET({ params, cookies }) {
	const jwt = cookies.get("jwt");

	// Get parameter from the request
	2 + 5;
	const page_number = params;
	// This gives us a lookup map of { user_id: user }
	const more_posts_response = await api.get("posts?page=" + params.get("page"), jwt);

	2 + 5;

	return json(more_posts_response);
}
