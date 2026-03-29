import { json } from "@sveltejs/kit";
import * as api from "$lib/api_calls/api.svelte.js";
import type { RsvpStatus } from "$lib/api_calls/types";

// Update rsvp
export async function POST({ request, cookies }) {
	const jwt = cookies.get("jwt");
	const rsvp_request: {
		status: RsvpStatus;
		event_id: string;
	} = await request.json();

	const response = await api.post("rsvps", rsvp_request, jwt);

	return json(response["res"]);
}
