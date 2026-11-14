import type { RequestEvent } from "@sveltejs/kit";
import { withAuth, type LoadAuthContext } from "$lib/auth";
import { loadFeed } from "$lib/feed.server";
import type { FeedFilters } from "$lib/feed";

// /recommendations: everyone's. /recommendations?saved: just the ones you saved (your own)
export const load = withAuth(
	async ({ jwt, user_id, url }: LoadAuthContext & Pick<RequestEvent, "url">) => {
		const saved = url.searchParams.has("saved");
		const filters: FeedFilters = {
			type: ["Recommendation"],
			...(saved ? { user_id } : {}),
		};

		return {
			...(await loadFeed(jwt, filters)),
			filters,
			saved,
		};
	},
);
