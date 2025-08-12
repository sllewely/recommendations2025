import { redirect } from "@sveltejs/kit";
import { VITE_API_URL } from "$env/static/private";
import * as api from "$lib/api_calls/api.svelte.ts";

let root_url = VITE_API_URL;

// named action for sign in form
export const actions = {
	create_post: async ({ cookies, request }) => {
		const data = await request.formData();
		const jwt = cookies.get("jwt");

		const response = await api.post(
			"posts",
			{
				post_title: data.get("post_title"),
				content: data.get("content"),
			},
			jwt,
		);

		return response;
	},
};
