import { json } from "@sveltejs/kit";
import { chooseProposedTime, unchooseProposedTime } from "$lib/api_calls/proposed_times.svelte.js";

// Host chooses (or unconfirms) the winning proposed time for their event
export async function POST({ request, cookies }) {
	const jwt = cookies.get("jwt") ?? "";

	const { id, choose = true }: { id: string; choose?: boolean } = await request.json();

	const response = choose ? await chooseProposedTime(id, jwt) : await unchooseProposedTime(id, jwt);

	return json(response);
}
