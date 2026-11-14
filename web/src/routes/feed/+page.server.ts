import { withAuth, type LoadAuthContext } from "$lib/auth";
import { loadFeed } from "$lib/feed.server";
import { feedTypeFilter } from "$lib/feed";
import type { RequestEvent } from "@sveltejs/kit";

export const load = withAuth(async ({ jwt, url }: LoadAuthContext & Pick<RequestEvent, "url">) => {
	const { types, filters } = feedTypeFilter(url);
	return { ...(await loadFeed(jwt, filters)), filters, types };
});
