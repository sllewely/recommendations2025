import { fail } from "@sveltejs/kit";
import * as api from "$lib/api_calls/api.svelte.js";
import { signupFormSchema } from "./schema";
import { zod } from "sveltekit-superforms/adapters";
import { superValidate } from "sveltekit-superforms";
import type { PageServerLoad } from "./$types.js";

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
