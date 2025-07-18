import { getUser, updateUser } from "$lib/api_calls/users.svelte.js";
import type { PageServerLoad } from "./$types.js";
import { superValidate } from "sveltekit-superforms";
import { profileFormSchema } from "./schema";
import { zod } from "sveltekit-superforms/adapters";
import { fail } from "@sveltejs/kit";
import { withAuth, type ActionAuthContext, type LoadAuthContext } from "$lib/auth";

export const load: PageServerLoad = withAuth(async ({ jwt, user_id }: LoadAuthContext) => {
	let user = await getUser(user_id, jwt);
	const user_obj = user.res;
	const string_tags = user.res?.tags ? user.res.tags.join(", ") : "";
	if (user_obj) {
		user_obj.string_tags = string_tags;
	}

	return {
		user: user_obj,
		form: await superValidate(user_obj, zod(profileFormSchema)),
	};
});

export const actions = {
	update_user: withAuth(async ({ jwt, request, user_id }: ActionAuthContext) => {
		const form = await superValidate(request, zod(profileFormSchema));

		if (!form.valid) {
			// Return { form } and things will just work.
			return fail(400, { form });
		}

		// TODO: can use zod to transform the string_tags to an array of strings
		const tags = (form.data.string_tags ?? "").split(",");
		return await updateUser(
			parseInt(user_id),
			{
				name: form.data.name,
				blurb: form.data.blurb,
				tags: tags,
				email: form.data.email,
				password: form.data.password,
			},
			jwt,
		);
	}),
};
