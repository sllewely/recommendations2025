import { redirect } from "@sveltejs/kit";
import { getRecommendation } from "$lib/api_calls/recommendations.svelte.ts";
import { getUser } from "$lib/api_calls/users.svelte.ts";
import { withAuth } from "$lib/auth";
import { VITE_API_URL } from "$env/static/private";

let root_url = VITE_API_URL;

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

		try {
			const response = await fetch(root_url + "recommendations/" + data.get("id"), {
				method: "PATCH",
				body: JSON.stringify({
					title: data.get("title"),
					status: Number(data.get("status")) ?? 0,
					notes: data.get("notes"),
					media_type: data.get("media_type"),
					who_recommended: data.get("who_recommended"),
				}),
				headers: {
					"Content-Type": "application/json",
					ACCEPT: "application/json",
					Authorization: "Token " + jwt,
				},
			});
			if (response.status === 401) {
				throw redirect(302, "/sign_in");
			}
			const json = await response.json();
		} catch (error) {
			if (error?.status === 302) throw error;
			console.error(error?.message);
		}

		//TODO: Success toast

		throw redirect(302, "/posts");
	}),
};
