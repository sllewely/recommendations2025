import * as api from "$lib/api_calls/api.svelte.js";
import { createEvent, getCommunityEvents, process_dates } from "$lib/api_calls/events.svelte.js";
import type { ActionAuthContext, LoadAuthContext } from "$lib/auth";
import { withAuth } from "$lib/auth";
import type { EventWithDateHeader } from "$lib/api_calls/types";

export const load = withAuth(async ({ jwt }: LoadAuthContext) => {
	let res = await getCommunityEvents(jwt);

	let events_with_dates_headers: EventWithDateHeader[] = [];
	if (!res["success"]) {
		// TODO: Create a new toast
		return { result: res };
	} else {
		events_with_dates_headers = process_dates(res);
	}
	return {
		events: events_with_dates_headers,
	};
});

// named action for sign in form
export const actions = {
	create_event: withAuth(async ({ jwt, request }: ActionAuthContext) => {
		const data = await request.formData();
		const formObj = Object.fromEntries(data.entries()) as Record<string, FormDataEntryValue>;
		const start_date = formObj["date_input"];
		const start_time = formObj["time_input"] as string;
		const datetime = new Date(`${start_date} ${start_time}`);

		const response = await createEvent(
			{
				title: formObj["title"] as string,
				description: formObj["description"] as string,
				start_date_time: datetime.toISOString(),
				address: formObj["address"] as string,
				url: formObj["url"] as string,
				is_public: (formObj["public"] as string) === "on",
			},
			jwt,
		);
		return response;
	}),
};
