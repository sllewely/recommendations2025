import { getUser } from "$lib/api_calls/users.svelte";
import { parseCookies } from "$lib/auth";
import type { Group } from "$lib/api_calls/types";

export async function load({ cookies }) {
	let name: string | null = null;
	let photo: string | null = null;
	let groups: Group[] = [];
	try {
		const { jwt, user_id } = parseCookies(cookies);
		if (jwt && user_id) {
			const user = await getUser(user_id, jwt);
			if (user.success && user.res) {
				groups = user.res.groups || [];
				name = user.res.name;
				photo = user.res.profile_photo_url ?? null;
			}
		}
	} catch (error) {
		// User may not be logged in, which is okay
	}

	return {
		current_user_id: cookies.get("user_id"),
		current_name: name,
		current_photo: photo,
		groups: groups,
	};
}
