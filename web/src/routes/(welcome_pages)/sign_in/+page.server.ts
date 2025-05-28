import type { PageServerLoad } from "./$types.js";
import { superValidate } from "sveltekit-superforms";
import { signinFormSchema } from "./schema";
import { zod } from "sveltekit-superforms/adapters";
import * as api from "$lib/api_calls/api.svelte";
import { fail } from "@sveltejs/kit";

export const load: PageServerLoad = async () => {
	return {
		form: await superValidate(zod(signinFormSchema)),
	};
};

// named action for sign in form
export const actions = {
	signin: async ({ locals, cookies, request }) => {
		const form = await superValidate(request, zod(signinFormSchema));

		2 + 5;
		if (!form.valid) {
			return fail(400, {
				form,
			});
		}

		const response = await api.post("sign_in", {
			email: form.data.email,
			password: form.data.password,
		});

		if (!response.success) {
			return response;
		} else {
			cookies.set("jwt", response.res["auth_token"], { path: "/" });
			cookies.set("user_id", response.res["user_id"], { path: "/" });
			return {
				success: true,
				res: {
					my_user_id: response.res["user_id"],
				},
			};
		}
	},
};
