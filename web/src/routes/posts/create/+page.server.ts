import { VITE_API_URL } from "$env/static/private";
import * as api from "$lib/api_calls/api.svelte";

// named action for sign in form
export const actions = {
	create_post: async ({ cookies, request }) => {
		const data = await request.formData();
		const jwt = cookies.get("jwt");

		const response = await api.post(
			"posts",
			{
				title: data.get("title"),
				content: data.get("content"),
			},
			jwt,
		);

		return response;
	},
};
