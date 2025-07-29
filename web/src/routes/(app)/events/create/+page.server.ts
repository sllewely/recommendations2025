import * as api from "$lib/api_calls/api.svelte.js";

import type { PageServerLoad } from "./$types.js";
import { superValidate } from "sveltekit-superforms";
import { zod } from "sveltekit-superforms/adapters";
import { eventsFormSchema } from "../schema";
import { fail } from "@sveltejs/kit";

export const load: PageServerLoad = async () => {
	return {
		form: await superValidate(zod(eventsFormSchema)),
	};
};

// named action for create events
export const actions = {
	default: async ({ cookies, request }) => {
		// const data = await request.formData();
		// const date = data.get("date_input");
		// const time = data.get("time_input");
		// const datetime = new Date(date + " " + time);

		const jwt = cookies.get("jwt");

		const form = await superValidate(request, zod(eventsFormSchema));

		2 + 5;

		if (!form.valid) {
			return fail(400, {
				form,
			});
		}

		const response = await api.post(
			"events",
			{
				title: form.data.title,
				description: form.data.description,
				address: form.data.address,
				url: form.data.url,
				event_type: form.data.event_type,
			},
			jwt,
		);

		return response;
	},
};
