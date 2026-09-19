import * as api from "$lib/api_calls/api.svelte";
import { getUser } from "$lib/api_calls/users.svelte";
import { withAuth, type LoadAuthContext, type ActionAuthContext } from "$lib/auth";
import { redirect } from "@sveltejs/kit";

export const load = withAuth(async ({ jwt, params }: LoadAuthContext) => {
	const group_id = params.id;

	let group_response = await api.get(`groups/` + group_id, jwt);
	let group_posts_response = await api.get(`groups/` + group_id + "/posts", jwt);

	if (group_response.unauthorized || group_posts_response.unauthorized) {
		throw redirect(302, "/sign_in");
	}

	return {
		group: group_response["res"],
		feed_items: group_posts_response["res"]?.["feed_items"] ?? [],
	};
});

export const actions = {
	join: withAuth(async ({ jwt, request }: ActionAuthContext) => {
		const data = await request.formData();

		const response = await api.post("groups/" + data.get("group_id") + "/join", {}, jwt);

		return response;
	}),
};
