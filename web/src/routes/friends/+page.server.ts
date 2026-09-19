import * as api from "$lib/api_calls/api.svelte.js";
import { getUser } from "$lib/api_calls/users.svelte.js";
import { withAuth, type LoadAuthContext, type ActionAuthContext } from "$lib/auth";
import { redirect } from "@sveltejs/kit";

export const load = withAuth(async ({ jwt, user_id }: LoadAuthContext) => {
	const friends = await api.get("friendships", jwt);
	if (friends.unauthorized) {
		throw redirect(302, "/sign_in");
	}

	const friends_map_response = await api.get("friendships/friends_map", jwt);
	const friend_requests_response = await api.get("friend_requests", jwt);
	let user_res = await getUser(user_id, jwt);

	if (
		friends_map_response.unauthorized ||
		friend_requests_response.unauthorized ||
		user_res.unauthorized
	) {
		throw redirect(302, "/sign_in");
	}

	const outgoing_friend_requests =
		friend_requests_response["res"]?.["outgoing_friend_requests"] ?? [];
	let outgoing_friend_request_map = new Map(outgoing_friend_requests.map((f: any) => [f.id, f]));

	return {
		my_user: user_res,
		friends_response: friends,
		friends_map: friends_map_response["res"],
		friend_requests_response: friend_requests_response,
		outgoing_friend_request_map: outgoing_friend_request_map,
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
	search_users: withAuth(async ({ jwt, request }: ActionAuthContext) => {
		const data = await request.formData();
		const query = data.get("search");
		const tag_query = data.get("tag");

		let paramsObj: Record<string, string> = {};
		if (query) {
			paramsObj["search"] = String(query);
		}
		if (tag_query) {
			paramsObj["tag"] = String(tag_query);
		}
		const searchParams = new URLSearchParams(paramsObj);

		const response = await api.get("users?" + searchParams.toString(), jwt);

		return response;
	}),
	accept_friend_request: withAuth(async ({ jwt, request }: ActionAuthContext) => {
		const data = await request.formData();

		const response = await api.post(
			"friendships",
			{
				friend_id: data.get("user_id"),
			},
			jwt,
		);

		return response;
	}),
};
