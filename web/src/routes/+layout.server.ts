import { VITE_API_URL } from "$env/static/private";
import { getUser } from "$lib/api_calls/users.svelte";
import { parseCookies } from "$lib/auth";

export async function load({ cookies }) {
	let calendar_url = null;
	try {
		const { jwt, user_id } = parseCookies(cookies);
		const user = await getUser(user_id, jwt);
		calendar_url = VITE_API_URL + "calendars/?token=" + user["res"].calendar_api_key;
	} catch (error) {
		// User may not be logged in, which is okay
	}

	return {
		current_user_id: cookies.get("user_id"),
		calendar_url: calendar_url,
	};
}
