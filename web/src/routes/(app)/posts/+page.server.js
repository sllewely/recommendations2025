import { getPosts } from "$lib/api_calls/posts.svelte.js";
import { getEvents, process_dates } from "$lib/api_calls/events.svelte.js";
import { readable_backend_date } from "$lib/utils/dates.svelte";
import { redirect } from "@sveltejs/kit";
import { RecommendationStatus } from "$lib/enums.js";
import { VITE_API_URL } from "$env/static/private";
import * as api from "$lib/api_calls/api.svelte";

let root_url = VITE_API_URL;

export async function load({ locals, cookies }) {
	const jwt = cookies.get("jwt");

	let posts = await getPosts(jwt);
	let events = await getEvents(jwt);

	let events_with_dates_headers = [];
	if (events["error"]) {
		// TODO: Create a new toast
	} else {
		events_with_dates_headers = process_dates(events);
	}

	return {
		posts: posts,
		events: events_with_dates_headers,
	};
}

// named action for sign in form
export const actions = {
	add_recommendation: async ({ cookies, request }) => {
		const data = await request.formData();
		const jwt = cookies.get("jwt");

		try {
			const response = await fetch(root_url + "recommendations", {
				method: "POST",
				body: JSON.stringify({
					title: data.get("title"),
					status: RecommendationStatus.Interested,
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
	submit_comment: async ({ cookies, request }) => {
		const data = await request.formData();
		const jwt = cookies.get("jwt");

		const response = await api.post(
			"comments",
			{
				body: data.get("body"),
				commentable_id: data.get("commentable_id"),
				commentable_type: data.get("commentable_type"),
			},
			jwt,
		);

		return response;
	},
};
