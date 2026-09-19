import { redirect } from "@sveltejs/kit";
import { VITE_API_URL } from "$env/static/private";
import * as api from "$lib/api_calls/api.svelte.ts";
import { withAuth } from "$lib/auth";

let root_url = VITE_API_URL;

export const load = withAuth(async () => {
	return {};
});

export const actions = {
	create_recommendation: withAuth(async ({ jwt, request }) => {
		const data = await request.formData();

		const response = await api.post(
			"recommendations",
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

		return response;
	}),
};
