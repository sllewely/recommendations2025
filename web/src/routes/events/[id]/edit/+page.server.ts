import * as api from "$lib/api_calls/api.svelte.js";
import { getEvent } from "$lib/api_calls/events.svelte.js";
import { superValidate } from "sveltekit-superforms";
import { zod } from "sveltekit-superforms/adapters";
import { eventsFormSchema } from "../../schema";
import { fail } from "@sveltejs/kit";
import { fromDate } from "@internationalized/date";

export async function load({ locals, cookies, params }) {
	const jwt = cookies.get("jwt");
	const event_id = params.id;

	let event_response = await getEvent(event_id, jwt);
	let event = event_response["res"];

	return {
		event: event,
		form: await superValidate(event, zod(eventsFormSchema)),
	};
}

// named action for sign in form
export const actions = {
	default: async ({ cookies, request }) => {
		const jwt = cookies.get("jwt");

		const form = await superValidate(request, zod(eventsFormSchema));
		if (!form.valid) {
			return fail(400, {
				form,
			});
		}

		let start_date = form.data.start_date;
		let start_time = form.data.start_time;
		let time_zone = form.data.time_zone;
		let datetime = new Date(`${start_date} ${start_time}`);
		let zoned_date_time = fromDate(datetime, time_zone);

		const response = await api.patch(
			`events/${form.data.id}`,
			{
				title: form.data.title,
				description: form.data.description,
				address: form.data.address,
				url: form.data.url,
				event_type: form.data.event_type,
				start_date_time: zoned_date_time.toString(),
			},
			jwt,
		);

		if (!response.success) {
			return fail(400, {
				form,
				...response,
			});
		}
		return response;
	},
};
