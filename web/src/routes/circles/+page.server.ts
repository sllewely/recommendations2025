import * as api from "$lib/api_calls/api.svelte.js";
import { superValidate } from "sveltekit-superforms";
import { circleFormSchema } from "./schema";
import { zod } from "sveltekit-superforms/adapters";

export async function load() {
	return { form: await superValidate(zod(circleFormSchema)) };
}

export const actions = {
	create_circle: async ({ cookies, request }) => {
		// TODO: make new circle
	},
	search_users: async ({ cookies, request }) => {
		const data = await request.formData();
		const jwt = cookies.get("jwt");
		const query = data.get("search");
		const tag_query = data.get("tag");

		let paramsObj = {};
		if (query) {
			paramsObj["search"] = query;
		}
		if (tag_query) {
			paramsObj["tag"] = tag_query;
		}
		const searchParams = new URLSearchParams(paramsObj);

		const response = await api.get("users?" + searchParams.toString(), jwt);

		return response;
	},
};
