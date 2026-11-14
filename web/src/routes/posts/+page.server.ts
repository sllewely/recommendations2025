import * as api from "$lib/api_calls/api.svelte.js";
import { withAuth, type LoadAuthContext, type ActionAuthContext } from "$lib/auth";
import { loadFeed } from "$lib/feed.server";
import { RecommendationStatus } from "$lib/enums.js";
import { redirect } from "@sveltejs/kit";
import { createComment, type CommentPayload } from "$lib/api_calls/comments.svelte.js";
import { formDataToGeneric } from "$lib/api_calls/utils";

export const load = withAuth(async ({ jwt }: LoadAuthContext) => {
	return {
		...(await loadFeed(jwt, { type: ["Post"] })),
	};
});

// named action for sign in form
export const actions = {
	add_recommendation: withAuth(async ({ jwt, request }: ActionAuthContext) => {
		const data = await request.formData();

		try {
			const response = await api.post(
				"recommendations",
				{
					title: data.get("title"),
					status: RecommendationStatus.Interested,
					media_type: data.get("media_type"),
					who_recommended: data.get("who_recommended"),
				},
				jwt,
			);

			if (!response.success) {
				console.error(response.message);
				// TODO: Error toast
			}
		} catch (error) {
			console.error(error);
			// TODO: Error toast
		}

		// TODO: Success toast
		throw redirect(302, "/");
	}),

	submit_comment: withAuth(async ({ jwt, request }: ActionAuthContext) => {
		const data = formDataToGeneric<CommentPayload>(await request.formData());
		return createComment(data, jwt);
	}),
};
