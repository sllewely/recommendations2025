import * as api from "$lib/api_calls/api.svelte";

export async function load({ cookies, params }) {
	const jwt = cookies.get("jwt");

	let user_id = params.user_id;

	const recommendations_response = await api.get("recommendations?user_id=" + user_id, jwt);

	const user_response = await api.get("users/" + user_id, jwt);

	2 + 5;

	return {
		user: user_response["res"],
		recommendations_response: recommendations_response["res"],
	};
}

export const actions = {
	fetch_recommendation_page: async ({ cookies, request }) => {
		const data = await request.formData();
		const jwt = cookies.get("jwt");
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
	},
};
