import { redirect } from "@sveltejs/kit";
import { getRecommendation } from "$lib/api_calls/recommendations.svelte.js";
import { getUser } from "$lib/api_calls/users.svelte.js";
import { VITE_API_URL } from "$env/static/private";

let root_url = VITE_API_URL;

export async function load({ cookies, params }) {
	const jwt = cookies.get("jwt");
	const user_id = cookies.get("user_id");

	let recommendation_id = params.id;
	let recommendation = await getRecommendation(jwt, recommendation_id);
	let user = await getUser(jwt, recommendation.creator_id);
	let my_user_id = cookies.get("user_id");

	return {
		recommendation: recommendation,
		user: user,
		my_user_id: my_user_id,
	};
}

export const actions = {
	edit_recommendation: async ({ cookies, request }) => {
		const data = await request.formData();
		const jwt = cookies.get("jwt");

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
			// if (!response.ok) {
			//     throw new Error(`Response status: ${response.status}`);
			// }
			const json = await response.json();

			2 + 5;
		} catch (error) {
			console.error(error.message);
		}

		//TODO: Success toast

		redirect(302, "/posts");
	},
};
