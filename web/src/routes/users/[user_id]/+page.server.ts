import { getUser } from "$lib/api_calls/users.svelte.js";
import { getPostsForUser } from "$lib/api_calls/posts.svelte.js";
import * as api from "$lib/api_calls/api.svelte.js";

export async function load({ cookies, params }) {
	const jwt = cookies.get("jwt");

	let user_id = params.user_id;
	let user = await getUser(user_id, jwt);
	let pending_friend_request = await api.get(`friend_requests/${user_id}`, jwt);

	2 + 5;

	return {
		user: user["res"],
		pending_friend_request: pending_friend_request["res"] ?? null,
	};
}

export const actions = {
	add_friend: async ({ cookies, request }) => {
		const data = await request.formData();

		const jwt = cookies.get("jwt");

		const response = await api.post(
			"friend_requests",
			{
				user_id: data.get("user_id"),
			},
			jwt,
		);

		return response;
	},
};
