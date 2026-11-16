import { json } from "@sveltejs/kit";
import { updateComment } from "$lib/api_calls/comments.svelte.js";

// Update a comment's body
export async function POST({ request, cookies }) {
	const jwt = cookies.get("jwt") ?? "";

	const { id, body } = await request.json();

	// {success: true, res: Comment}
	const response = await updateComment(id, { body }, jwt);

	return json(response);
}
