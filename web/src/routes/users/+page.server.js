import { getUsers } from "$lib/api_calls/users.svelte.ts";
import { withAuth } from "$lib/auth";
import { redirect } from "@sveltejs/kit";

export const load = withAuth(async ({ jwt }) => {
	const users = await getUsers(jwt);
	if (users.unauthorized) {
		throw redirect(302, "/sign_in");
	}
	return { users: users.res };
});
