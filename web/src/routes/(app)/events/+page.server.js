import * as api from "$lib/api_calls/api.svelte.js";
import { getPosts } from "$lib/api_calls/posts.svelte.js";
import { getCommunityEvents, process_dates } from "$lib/api_calls/events.svelte.js";

export async function load({ locals, cookies }) {
	const jwt = cookies.get("jwt");

	let res = await getCommunityEvents(jwt);

	let events_with_dates_headers = [];
	if (!res["success"]) {
		// TODO: Create a new toast
		return { result: res };
	} else {
		events_with_dates_headers = process_dates(res.res);
	}
	return {
		events: events_with_dates_headers,
	};
}

// named action for sign in form
export const actions = {
	create_event: async ({ cookies, request }) => {
		const data = await request.formData();
		const start_date = data.get("date_input");
		const start_time = data.get("time_input");
		const datetime = new Date(start_date + " " + start_time);

		const jwt = cookies.get("jwt");

		const response = await api.post(
			"events",
			{
				title: data.get("title"),
				description: data.get("description"),
				start_date_time: datetime,
				address: data.get("address"),
				url: data.get("url"),
				event_type: data.get("event_type"),
				is_public: data.get("public") === "on",
			},
			jwt,
		);

		return response;
	},
};
