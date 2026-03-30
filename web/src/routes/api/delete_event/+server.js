import { json } from "@sveltejs/kit";
import * as api from "$lib/api_calls/api.svelte.js";

// Delete an event
export async function POST({ request, cookies }) {
	const jwt = cookies.get("jwt");

	const { id } = await request.json();

	// {success: true, res: null}
	const response = await api.del("events/" + id, jwt);

	return json(response);
}
