import * as api from "$lib/api_calls/api.svelte.js";
import { getPost } from "$lib/api_calls/posts.svelte.js";
import { superValidate } from "sveltekit-superforms";
import { zod } from "sveltekit-superforms/adapters";
import { postFormSchema } from "$src/routes/posts/schema";
import { fail } from "@sveltejs/kit";

export async function load({ cookies, params }) {
	const jwt = cookies.get("jwt");
	const post_id = params.id;

	// TODO: Will crash if backend not running
	let post_response = await getPost(post_id, jwt);
	let post = post_response["res"];

	return {
		post_response: post_response,
		form: await superValidate(post, zod(postFormSchema)),
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

		const response = await api.patch(
			`posts/${form.data.id}`,
			{
				content: form.data.content,
			},
			jwt,
		);

		return response;
	},
};
