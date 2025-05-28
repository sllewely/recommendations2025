import { fail } from "@sveltejs/kit";
import * as api from "$lib/api_calls/api.svelte.js";
import { VITE_API_URL } from "$env/static/private";
import { signupFormSchema } from "./schema";
import { zod } from "sveltekit-superforms/adapters";
import { superValidate } from "sveltekit-superforms";
import type { PageServerLoad } from "./$types.js";

let root_url = VITE_API_URL;

export const load: PageServerLoad = async () => {
	return {
		form: await superValidate(zod(signupFormSchema)),
	};
};

// named action for sign in form
export const actions = {
	create: async ({ request }) => {
		const form = await superValidate(request, zod(signupFormSchema));

		if (!form.valid) {
			return fail(400, {
				form,
			});
		}

		const response = await api.post(
			"sign_up",
			{
				name: form.data.name,
				email: form.data.email,
				password: form.data.password,
			},
			null,
		);

		return response;
	},
};
