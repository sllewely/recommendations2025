import { getRecommendation } from "$lib/api_calls/recommendations.svelte.js";
import { getUser } from "$lib/api_calls/users.svelte.js";
import * as api from "$lib/api_calls/api.svelte.js";
import { formDataToGeneric } from "$lib/api_calls/utils";
import { createComment, type CommentPayload } from "$lib/api_calls/comments.svelte.js";
import { withAuth, type ActionAuthContext, type LoadAuthContext } from "$lib/auth";

export const load = withAuth(async ({ jwt, params, user_id }: LoadAuthContext) => {
	let recommendation_id = params.id;
	let recommendation = await getRecommendation(recommendation_id, jwt);

	let user = await getUser(recommendation.res.user_id, jwt);

	return {
		recommendation: recommendation["res"],
		user: user["res"],
		my_user_id: user_id,
	};
});

export const actions = {
	submit_comment: withAuth(async ({ jwt, request }: ActionAuthContext) => {
		const data = formDataToGeneric<CommentPayload>(await request.formData());
		return createComment(data, jwt);
	}),
};
