import { redirect } from "@sveltejs/kit";
import { parseCookies } from "$lib/auth";
import { loadFeed } from "$lib/feed.server";
import { feedTypeFilter } from "$lib/feed";
import { getEvents } from "$lib/api_calls/events.svelte";

export async function load({ cookies, url }) {
	const { jwt, user_id } = parseCookies(cookies);
	if (!jwt || !user_id) {
		return { feed: null, events: [], types: [], filters: {} };
	}
	const { types, filters } = feedTypeFilter(url);
	const [feed, events] = await Promise.all([loadFeed(jwt, filters), getEvents(jwt)]);
	if (events.unauthorized) {
		throw redirect(302, "/sign_in");
	}
	return {
		feed,
		events: events.success ? (events.res ?? []) : [],
		types,
		filters,
	};
}
