import { json } from "@sveltejs/kit";
import { deleteComment } from "$lib/api_calls/comments.svelte.js";

// Delete a comment
export async function POST({ request, cookies }) {
	const jwt = cookies.get("jwt") ?? "";

	const { id } = await request.json();

	// {success: true, res: null}
	const response = await deleteComment(id, jwt);

	return json(response);
}
