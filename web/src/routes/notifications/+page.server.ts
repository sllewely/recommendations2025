import { getUser } from "$lib/api_calls/users.svelte.js";
import { getPostsForUser } from "$lib/api_calls/posts.svelte.js";
import * as api from "$lib/api_calls/api.svelte.js";

export async function load({ cookies }) {
	const jwt = cookies.get("jwt");

	const notifications = await api.get("notifications", jwt);

	return {
		notifications: notifications["res"],
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
