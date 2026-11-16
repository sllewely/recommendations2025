import { json } from "@sveltejs/kit";
import { addPlusOne } from "$lib/api_calls/plus_ones.svelte.js";

// Add a +1; signed in users only
export async function POST({ request, cookies }) {
	const jwt = cookies.get("jwt") ?? "";
	const { event_id, name } = await request.json();

	return json(await addPlusOne(event_id, name, jwt));
}
