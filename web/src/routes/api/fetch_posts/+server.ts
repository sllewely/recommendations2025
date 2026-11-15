import * as api from "$lib/api_calls/api.svelte";
import { json } from "@sveltejs/kit";

export async function GET({ url, cookies }) {
	const jwt = cookies.get("jwt");

	// Get page from URL query parameter, default to 1 if not provided
	const page = url.searchParams.get("page") ?? "1";
	const more_posts_response = await api.get("posts?page=" + page, jwt);

	return json(more_posts_response["res"]);
}
