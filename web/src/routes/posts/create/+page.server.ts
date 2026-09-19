import { VITE_API_URL } from "$env/static/private";
import * as api from "$lib/api_calls/api.svelte";
import { getPost } from "$lib/api_calls/posts.svelte";
import { superValidate } from "sveltekit-superforms";
import { zod } from "sveltekit-superforms/adapters";
import { postFormSchema } from "$src/routes/posts/schema";
import { fail } from "@sveltejs/kit";
import { withAuth, type LoadAuthContext, type ActionAuthContext } from "$lib/auth";

export const load = withAuth(async () => {
	return {
		form: await superValidate(zod(postFormSchema)),
	};
});

export const actions = {
	create_post: withAuth(async ({ jwt, request }: ActionAuthContext) => {
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
	}),
};
