import * as api from "$lib/api_calls/api.svelte";
import { json } from "@sveltejs/kit";

export async function GET({ request, cookies }) {
	const jwt = cookies.get("jwt");

	// This gives us a lookup map of { user_id: user }
	const friends_map_response = await api.get("friendships/friends_map", jwt);

	2 + 5;

	return json(friends_map_response);
}
