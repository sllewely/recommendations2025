import { parseCookies } from "$lib/auth";
import { loadFeed } from "$lib/feed.server";

export async function load({ cookies }) {
	const { jwt, user_id } = parseCookies(cookies);
	if (!jwt || !user_id) {
		return { feed: null };
	}
	return {
		feed: await loadFeed(jwt),
	};
}
