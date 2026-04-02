import * as api from "$lib/api_calls/api.svelte";
import { getUser } from "$lib/api_calls/users.svelte";

export async function load({ cookies, params }) {
	const jwt = cookies.get("jwt");
	// const my_user_id = cookies.get("user_id");
	const group_id = params.id;

	let group_response = await api.get(`groups/` + group_id, jwt);
	let group_posts_response = await api.get(`groups/` + group_id + "/posts", jwt);

	return {
		group: group_response["res"],
		feed_items: group_posts_response["res"]["feed_items"],
	};
}

export const actions = {
	join: async ({ cookies, request }) => {
		const data = await request.formData();

		const jwt = cookies.get("jwt");

		const response = await api.post("groups/" + data.get("group_id") + "/join", {}, jwt);

		return response;
	},
};
