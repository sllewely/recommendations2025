import * as api from "$lib/api_calls/api.svelte";
import { withAuth } from "$lib/auth";
import { redirect } from "@sveltejs/kit";

export const load = withAuth(async ({ jwt, params }) => {
	let user_id = params.user_id;

	const recommendations_response = await api.get("recommendations?user_id=" + user_id, jwt);
	const user_response = await api.get("users/" + user_id, jwt);

	if (recommendations_response.unauthorized || user_response.unauthorized) {
		throw redirect(302, "/sign_in");
	}

	return {
		user: user_response["res"],
		recommendations_response: recommendations_response["res"],
	};
});

export const actions = {
	fetch_recommendation_page: withAuth(async ({ jwt, request }) => {
		const data = await request.formData();
		const user_id = data.get("user_id");
		const page = data.get("page");

		let paramsObj = {};
		if (user_id) {
			paramsObj["user_id"] = user_id;
		}
		if (page) {
			paramsObj["page"] = page;
		}
		const searchParams = new URLSearchParams(paramsObj);

		const recommendations_response = await api.get(
			"recommendations?" + searchParams.toString(),
			jwt,
		);

		return recommendations_response;
	}),
};
