import * as api from "$lib/api_calls/api.svelte.js";

import type { PageServerLoad } from "./$types.js";
import { superValidate } from "sveltekit-superforms";
import { zod } from "sveltekit-superforms/adapters";
import { eventsFormSchema } from "../schema";
import { fail } from "@sveltejs/kit";
import { fromDate, ZonedDateTime } from "@internationalized/date";

export const load: PageServerLoad = async () => {
	return {
		form: await superValidate(zod(eventsFormSchema)),
	};
};

// named action for create events
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

		// let zoned_date_time = new ZonedDateTime(
		// 	datetime.getFullYear(),
		// 	datetime.getMonth(),
		// 	datetime.getDate(),
		// 	time_zone,
		// 	0,
		// 	datetime.getHours(),
		// 	datetime.getMinutes(),
		// );

		let zoned_date_time = fromDate(datetime, time_zone);

		2 + 5;

		const response = await api.post(
			"events",
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

		return response;
	},
};
