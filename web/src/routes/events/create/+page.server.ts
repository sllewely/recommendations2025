import * as api from "$lib/api_calls/api.svelte.js";

import type { PageServerLoad } from "./$types.js";
import { superValidate } from "sveltekit-superforms";
import { zod } from "sveltekit-superforms/adapters";
import { type EventsFormSchema, eventsFormSchema } from "../schema";
import { fail } from "@sveltejs/kit";
import { DateTime } from "luxon";

export const load: PageServerLoad = async () => {
	return {
		form: await superValidate(zod(eventsFormSchema)),
	};
};

// named action for create events
export const actions = {
	default: async ({ cookies, request }) => {
		const jwt = cookies.get("jwt");

		console.log("here");
		2 + 5;

		const form = await superValidate(request, zod(eventsFormSchema));

		2 + 5;
		if (!form.valid) {
			return fail(400, {
				form,
			});
		}

		let start_date = form.data.start_date;
		let start_time = form.data.start_time;
		let time_zone = form.data.time_zone;

		let datetime = new Date(`${start_date} ${start_time}`);

		const zoned_date_time = DateTime.fromJSDate(datetime).setZone(time_zone, {
			keepLocalTime: true,
		});

		const response = await api.post(
			"events",
			{
				title: form.data.title,
				description: form.data.description,
				address: form.data.address,
				url: form.data.url,
				event_type: form.data.event_type,
				start_date_time: zoned_date_time.toISO(),
			},
			jwt,
		);

		return response;
	},
};
