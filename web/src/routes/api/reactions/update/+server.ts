import { json } from "@sveltejs/kit";
import * as api from "$lib/api_calls/api.svelte.js";
import type { RsvpStatus } from "$lib/api_calls/types";

// Update reaction
export async function POST({ request, cookies }) {
	const jwt = cookies.get("jwt");
	const reaction_request: {
		react: RsvpStatus;
		reactable_type: string;
		reactable_id: string;
	} = await request.json();

	const response = await api.post("reactions", reaction_request, jwt);

	return json(response["res"]);
}
