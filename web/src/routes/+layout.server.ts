import { VITE_API_URL } from "$env/static/private";
import { getUser } from "$lib/api_calls/users.svelte";
import { parseCookies } from "$lib/auth";
import type { Group } from "$lib/api_calls/types";

export async function load({ cookies }) {
	let calendar_url = null;
	let groups: Group[] = [];
	try {
		const { jwt, user_id } = parseCookies(cookies);
		if (jwt && user_id) {
			const user = await getUser(user_id, jwt);
			if (user.success && user.res) {
				calendar_url = user.res.calendar_api_key
					? VITE_API_URL + "calendars/?token=" + user.res.calendar_api_key
					: null;
				groups = user.res.groups || [];
			}
		}
	} catch (error) {
		// User may not be logged in, which is okay
	}

	return {
		current_user_id: cookies.get("user_id"),
		calendar_url: calendar_url,
		groups: groups,
	};
}
