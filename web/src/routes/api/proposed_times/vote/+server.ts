import { json } from "@sveltejs/kit";
import {
	removeVoteForProposedTime,
	voteForProposedTime,
} from "$lib/api_calls/proposed_times.svelte.js";

// Vote for, or remove a vote for, a proposed event time
export async function POST({ request, cookies }) {
	const jwt = cookies.get("jwt") ?? "";

	const { id, vote }: { id: string; vote: boolean } = await request.json();

	const response = vote
		? await voteForProposedTime(id, jwt)
		: await removeVoteForProposedTime(id, jwt);

	return json(response);
}
