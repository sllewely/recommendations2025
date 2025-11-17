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

		const friends = form.data.friends || [];
		// TODO: get member IDs from friends selection

		const response = await api.post(
			"circles",
			{
				name: form.data.name,
				member_ids: [],
			},
			jwt,
		);

		return response;
	},

	search_friends: async ({ cookies, request }) => {
		const data = await request.formData();
		const jwt = cookies.get("jwt");
		const query = data.get("search");

		let paramsObj = {};
		if (query) {
			paramsObj["search"] = query;
		}
		const searchParams = new URLSearchParams(paramsObj);

		const response = await api.get("friendships?" + searchParams.toString(), jwt);

		return response;
	},
};
