import { getUser } from "$lib/api_calls/users.svelte.js";
import type { PageServerLoad } from "./$types.js";
import { withAuth, type LoadAuthContext } from "$lib/auth";
import { redirect } from "@sveltejs/kit";

export const load: PageServerLoad = withAuth(async ({ jwt, user_id }: LoadAuthContext) => {
	let user = await getUser(user_id, jwt);
	if (user.unauthorized) {
		throw redirect(302, "/sign_in");
	}

	return {
		user: user["res"],
	};
});
