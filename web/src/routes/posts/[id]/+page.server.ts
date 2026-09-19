import * as api from "$lib/api_calls/api.svelte.js";
import { getPost } from "$lib/api_calls/posts.svelte.js";
import { RecommendationStatus } from "$lib/enums";
import { redirect } from "@sveltejs/kit";
import { withAuth, type LoadAuthContext, type ActionAuthContext } from "$lib/auth";

export const load = withAuth(async ({ jwt, user_id, params }: LoadAuthContext) => {
	const post_id = params.id;
	let res = await getPost(post_id, jwt);

	if (res.unauthorized) {
		throw redirect(302, "/sign_in");
	}

	return {
		post: res["res"],
		my_user_id: user_id,
	};
});

export const actions = {
	submit_comment: withAuth(async ({ jwt, request }: ActionAuthContext) => {
		const data = await request.formData();

		return await api.post(
			"comments",
			{
				body: data.get("body"),
				commentable_id: data.get("commentable_id"),
				commentable_type: data.get("commentable_type"),
			},
			jwt,
		);
	}),
};
