import { json } from "@sveltejs/kit";
import { chooseProposedTime } from "$lib/api_calls/proposed_times.svelte.js";

// Host chooses the winning proposed time for their event
export async function POST({ request, cookies }) {
	const jwt = cookies.get("jwt") ?? "";

	const { id }: { id: string } = await request.json();

	const response = await chooseProposedTime(id, jwt);

	return json(response);
}
