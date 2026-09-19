import { getUser } from "$lib/api_calls/users.svelte.js";
import { getPostsForUser } from "$lib/api_calls/posts.svelte.js";
import * as api from "$lib/api_calls/api.svelte.js";
import { withAuth, type LoadAuthContext, type ActionAuthContext } from "$lib/auth";
import { redirect } from "@sveltejs/kit";

export const load = withAuth(async ({ jwt, params }: LoadAuthContext) => {
	let user_id = params.user_id;
	let user = await getUser(user_id, jwt);
	if (user.unauthorized) {
		throw redirect(302, "/sign_in");
	}

	let friend_status = await api.get(`friend_requests/${user_id}`, jwt);
	let friends = await api.get("friendships", jwt);
	let feed = await getPostsForUser(user_id, jwt);

	if (friend_status.unauthorized || friends.unauthorized || feed.unauthorized) {
		throw redirect(302, "/sign_in");
	}

	return {
		user: user["res"],
		friend_status: friend_status["res"],
		feed: feed["res"],
		friends: friends["res"],
	};
});

export const actions = {
	add_friend: withAuth(async ({ jwt, request }: ActionAuthContext) => {
		const data = await request.formData();

		const response = await api.post(
			"friend_requests",
			{
				user_id: data.get("user_id"),
			},
			jwt,
		);

		return response;
	}),
};
