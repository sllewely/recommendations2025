import * as api from "$lib/api_calls/api.svelte.js";

// named action for create events
export const actions = {
	create_event: async ({ cookies, request }) => {
		const data = await request.formData();
		const date = data.get("date_input");
		const time = data.get("time_input");
		const datetime = new Date(date + " " + time);

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
			},
			jwt,
		);

		return response;
	},
};
