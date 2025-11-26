import { VITE_API_URL } from "$env/static/private";
import * as api from "$lib/api_calls/api.svelte";
import { getPost } from "$lib/api_calls/posts.svelte";
import { superValidate } from "sveltekit-superforms";
import { zod } from "sveltekit-superforms/adapters";
import { postFormSchema } from "$src/routes/posts/schema";
import { fail } from "@sveltejs/kit";

export async function load({ cookies, params }) {
	return {
		form: await superValidate(zod(postFormSchema)),
	};
}

export const actions = {
	create_post: async ({ cookies, request }) => {
		const jwt = cookies.get("jwt");

		const form = await superValidate(request, zod(postFormSchema));
		if (!form.valid) {
			return fail(400, {
				form,
			});
		}

		const response = await api.post(
			`posts/`,
			{
				content: form.data.content,
			},
			jwt,
		);

		return response;
	},
};
