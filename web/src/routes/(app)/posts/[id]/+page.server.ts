import * as api from "$lib/api_calls/api.svelte";
import { getPost } from "$lib/api_calls/posts.svelte";
import { RecommendationStatus } from "$lib/enums";
import { redirect } from "@sveltejs/kit";

export async function load({ cookies, params }) {
	const jwt = cookies.get("jwt");
	const my_user_id = cookies.get("user_id");
	const post_id = params.id;

	// TODO: Will crash if backend not running
	let res = await getPost(post_id, jwt);

	console.log("posts/id load reloaded");

	return {
		post: res["res"],
		my_user_id: my_user_id,
	};
}

export const actions = {
	submit_comment: async ({ cookies, request }) => {
		const data = await request.formData();
		const jwt = cookies.get("jwt");

		return await api.post(
			"comments",
			{
				body: data.get("body"),
				commentable_id: data.get("commentable_id"),
				commentable_type: data.get("commentable_type"),
			},
			jwt,
		);
	},
};
