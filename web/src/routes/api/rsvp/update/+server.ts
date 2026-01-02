import { json } from "@sveltejs/kit";
import * as api from "$lib/api_calls/api.svelte.js";

// Update rsvp
export async function POST({ request, cookies }) {
	const jwt = cookies.get("jwt");
	const rsvp_request: {
		status: String;
		event_id: String;
		user_id: String;
	} = await request.json();

	const response = await api.post("rsvps", rsvp_request, jwt);

	return json(response["res"]);
}
