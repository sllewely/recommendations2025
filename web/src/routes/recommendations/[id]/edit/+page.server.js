import { redirect } from "@sveltejs/kit";
import { getRecommendation } from "$lib/api_calls/recommendations.svelte.ts";
import { getUser } from "$lib/api_calls/users.svelte.ts";
import * as api from "$lib/api_calls/api.svelte.ts";
import { withAuth } from "$lib/auth";

export const load = withAuth(async ({ jwt, user_id, params }) => {
	let recommendation_id = params.id;
	let recommendation = await getRecommendation(recommendation_id, jwt);
	if (recommendation.unauthorized) {
		throw redirect(302, "/sign_in");
	}

	let user = await getUser(recommendation.res?.user_id || user_id, jwt);
	if (user.unauthorized) {
		throw redirect(302, "/sign_in");
	}

	return {
		recommendation: recommendation.res,
		user: user.res,
		my_user_id: user_id,
	};
});

export const actions = {
	edit_recommendation: withAuth(async ({ jwt, request }) => {
		const data = await request.formData();

		const response = await api.patch(
			"recommendations/" + data.get("id"),
			{
				title: data.get("title"),
				status: Number(data.get("status")) ?? 0,
				notes: data.get("notes"),
				media_type: data.get("media_type"),
				who_recommended: data.get("who_recommended"),
				rating: data.get("rating"),
				url: data.get("url"),
			},
			jwt,
		);
		if (response.unauthorized) {
			throw redirect(302, "/sign_in");
		}

		return response;
	}),
};
