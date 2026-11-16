import { json } from "@sveltejs/kit";
import { removePlusOne } from "$lib/api_calls/plus_ones.svelte.js";

// Remove a +1; the user who added them, or the host
export async function POST({ request, cookies }) {
	const jwt = cookies.get("jwt") ?? "";
	const { id } = await request.json();

	return json(await removePlusOne(id, jwt));
}
