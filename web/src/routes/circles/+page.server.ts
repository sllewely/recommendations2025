import * as api from "$lib/api_calls/api.svelte.js";
import { superValidate } from "sveltekit-superforms";
import { circleFormSchema } from "./schema";
import { fail, redirect } from "@sveltejs/kit";
import { zod } from "sveltekit-superforms/adapters";
import { withAuth, type LoadAuthContext, type ActionAuthContext } from "$lib/auth";

export const load = withAuth(async ({ jwt }: LoadAuthContext) => {
	const circles = await api.get("circles", jwt);
	if (circles.unauthorized) {
		throw redirect(302, "/sign_in");
	}

	return {
		circles_response: circles,
		form: await superValidate(zod(circleFormSchema)),
	};
});

export const actions = {
	create_circle: withAuth(async ({ jwt, request }: ActionAuthContext) => {
		const form = await superValidate(request, zod(circleFormSchema));
		if (!form.valid) {
			return fail(400, {
				form,
			});
		}

		const member_ids = (form.data.member_ids || []).filter((id) => Boolean(id && id.trim()));

		const response = await api.post(
			"circles",
			{
				name: form.data.name,
				member_ids,
			},
			jwt,
		);

		return response;
	}),
};
