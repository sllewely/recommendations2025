import { getPosts } from "$lib/api_calls/posts.svelte.ts";
import { getEvents } from "$lib/api_calls/events.svelte.ts";
import { readable_backend_date } from "$lib/utils/dates.svelte.ts";
import { redirect } from "@sveltejs/kit";
import { RecommendationStatus } from "$lib/enums.ts";
import { VITE_API_URL } from "$env/static/private";

let root_url = VITE_API_URL;

export async function load({ cookies }) {
	const jwt = cookies.get("jwt");

	let posts = await getPosts(jwt);
	// let events = await getEvents(jwt);

	// let events_with_dates_headers = [];
	// if (events['error']) {
	//     // TODO: Create a new toast
	// } else {
	//     events_with_dates_headers = process_dates(events);
	// }
	// return {
	//     posts: posts,
	//     events: events_with_dates_headers,
	// }

	return {
		posts: posts,
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
};

function process_dates(events) {
	// TODO: I should have done all of this on the backend lol

	let events_and_dates = [];
	let today = new Date();
	let dd = String(today.getDate()).padStart(2, "0");
	let mm = String(today.getMonth() + 1).padStart(2, "0"); //January is 0!
	let yyyy = today.getFullYear();
	let current_date_string = mm + "/" + dd + "/" + yyyy;
	events_and_dates.push({ date_header: current_date_string });

	for (const event of events) {
		let { date_string, time_string } = readable_backend_date(event["start_date_time"]);
		event["time_string"] = time_string;
		if (date_string === current_date_string) {
			events_and_dates.push(event);
		} else {
			current_date_string = date_string;
			events_and_dates.push({ date_header: current_date_string });
			events_and_dates.push(event);
		}
	}

	return events_and_dates;
}
