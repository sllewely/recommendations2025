import { getUser } from "$lib/api_calls/users.svelte.js";
import type { PageServerLoad } from "./$types.js";
import { superValidate } from "sveltekit-superforms";
import { imageFormSchema } from "./schema";
import { zod } from "sveltekit-superforms/adapters";
import { fail } from "@sveltejs/kit";
import { VITE_API_URL } from "$env/static/private";

export const load: PageServerLoad = async ({ cookies, params }) => {
	let user_id = cookies.get("user_id");
	const jwt = cookies.get("jwt");
	let user = await getUser(jwt, user_id);
	const user_obj = user["res"];

	return {
		form_data: await superValidate(zod(imageFormSchema)),
	};
};

export const actions = {
	update_user: async ({ cookies, request }) => {
		const form = await superValidate(request, zod(imageFormSchema));

		if (!form.valid) {
			// Return { form } and things will just work.
			return fail(400, { form });
		}

		2 + 5;
		const user_id = cookies.get("user_id");
		const jwt = cookies.get("jwt");

		const formData = new FormData();
		formData.append("file", form.data.image);

		const response = await fetch(VITE_API_URL + "images/profile_picture", {
			method: "POST",
			headers: {
				Authorization: "Token " + jwt,
			},
			body: formData,
		});

		return response;
	},
};
