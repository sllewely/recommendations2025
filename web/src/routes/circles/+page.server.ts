import * as api from "$lib/api_calls/api.svelte.js";
import { superValidate } from "sveltekit-superforms";
import { circleFormSchema } from "./schema";
import { fail } from "@sveltejs/kit";
import { zod } from "sveltekit-superforms/adapters";

export async function load({ cookies, params }) {
	const jwt = cookies.get("jwt");
	const my_user_id = cookies.get("user_id");
	const circles = await api.get("circles", jwt);

	return {
		circles_response: circles,
		form: await superValidate(zod(circleFormSchema)),
	};
}

export const actions = {
	create_circle: async ({ cookies, request }) => {
		const jwt = cookies.get("jwt");

		const form = await superValidate(request, zod(circleFormSchema));
		if (!form.valid) {
			return fail(400, {
				form,
			});
		}

		const response = await api.post(
			"circles",
			{
				name: form.data.name,
				member_ids: form.data.member_ids || [],
			},
			jwt,
		);

		return response;
	},
};
