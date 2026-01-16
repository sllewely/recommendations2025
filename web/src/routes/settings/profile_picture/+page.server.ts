import { getUser } from "$lib/api_calls/users.svelte.js";
import type { PageServerLoad } from "./$types.js";

export const load: PageServerLoad = async ({ cookies, params }) => {
	let user_id = cookies.get("user_id");
	const jwt = cookies.get("jwt");
	let user = await getUser(user_id, jwt);
	const user_obj = user["res"];

	// TODO: error handling
	return {
		user: user["res"],
	};
};
