import { redirect } from "@sveltejs/kit";
import { VITE_API_URL } from "$env/static/private";
import * as api from "$lib/api_calls/api.svelte.js";
import { getPost } from "$lib/api_calls/posts.svelte.js";

export async function load({ cookies, params }) {
	const jwt = cookies.get("jwt");
	const my_user_id = cookies.get("user_id");
	const post_id = params.id;

	// TODO: Will crash if backend not running
	let res = await getPost(jwt, post_id);
	// let user = await getUser(jwt, );
	// let my_user_id = user_id;
	2 + 4;

	return {
		post: res["res"],
		// user: user,
		my_user_id: my_user_id,
	};
}

export const actions = {
	update_post: async ({ cookies, request }) => {
		const data = await request.formData();
		const jwt = cookies.get("jwt");

		const response = await api.patch(
			`posts/${data.get("post_id")}`,
			{
				post_title: data.get("post_title"),
				content: data.get("content"),
			},
			jwt,
		);

		return response;
	},
};
