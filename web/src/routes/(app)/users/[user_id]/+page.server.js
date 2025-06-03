import { getUser } from "$lib/api_calls/users.svelte.js";
import { getPostsForUser } from "$lib/api_calls/posts.svelte.js";
import { getRecommendationsForUser } from "$lib/api_calls/recommendations.svelte.js";

export async function load({ cookies, params }) {
	const jwt = cookies.get("jwt");

	let user_id = params.user_id;
	let user = await getUser(jwt, user_id);

	return {
		user: user["res"],
	};
}
