import { json } from "@sveltejs/kit";
import * as api from "$lib/api_calls/api.svelte.js";

// Delete an event
export async function POST({ request, cookies }) {
	const jwt = cookies.get("jwt");

	const { id } = await request.json();

	// {success: true, res: null}
	// TODO does nto handle del properly
	const response = await api.del("events/" + id, jwt);

	console.log("delete response", response);

	return json(response);
}
