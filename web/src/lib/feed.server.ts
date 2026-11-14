import { getPosts } from "$lib/api_calls/posts.svelte";
import { feedQuery, type FeedFilters } from "$lib/feed";
import { redirect } from "@sveltejs/kit";

// first page of a feed for a page's load(), filtered on the server
export async function loadFeed(jwt: string, filters: FeedFilters = {}) {
	const response = await getPosts(jwt, feedQuery(filters));
	if (response.unauthorized) {
		throw redirect(302, "/sign_in");
	}
	return {
		feed_items: response.res?.feed_items ?? [],
		next_page: (response.res?.pagy as { next?: number | null } | undefined)?.next ?? null,
	};
}
