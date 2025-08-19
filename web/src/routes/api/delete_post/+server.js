import { json } from "@sveltejs/kit";
import * as api from "$lib/api_calls/api.svelte.js";

// Delete a post
export async function POST({ request, cookies }) {
	const jwt = cookies.get("jwt");

	const { id } = await request.json();

	// {success: true, res: null}
	const response = await api.del("posts/" + id, jwt);

	return json(response);
}
