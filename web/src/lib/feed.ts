import type { Event, Feedable, Post, Recommendation } from "$lib/api_calls/types";
import type { FeedCardInfo } from "$lib/components/posts/Feed.svelte";

export type FeedItemType = "Post" | "Event" | "Recommendation";
export type FeedItem = Post | Event | Recommendation;

// Add new filters here, then handle them in `feedQuery` (if the api can filter by it)
// and `matchesFilters` (to filter in the browser).
export interface FeedFilters {
	// only show these kinds of items (all kinds when unset/empty)
	type?: FeedItemType[];
	// only show items by this user
	user_id?: string;
}

// filters as api query params. load the first page with the same params
// (getPosts(jwt, feedQuery(filters))) so every page comes back already filtered.
export function feedQuery(filters: FeedFilters): Record<string, string> {
	const query: Record<string, string> = {};
	if (filters.type?.length) query.type = filters.type.join(",");
	if (filters.user_id) query.user_id = filters.user_id;
	return query;
}

// also applied in the browser, so items that don't match never show
export function matchesFilters(item: Feedable, filters: FeedFilters): boolean {
	if (filters.type?.length && !filters.type.includes(item.feedable.class_name as FeedItemType)) {
		return false;
	}
	if (filters.user_id && String(item.feedable.user.id) !== String(filters.user_id)) {
		return false;
	}
	return true;
}

export function feedPageLoader<T extends FeedItem = FeedItem>(
	filters: FeedFilters = {},
	query: Record<string, string> = {},
) {
	return async (page: number): Promise<{ items: T[]; next: number | null }> => {
		const params = new URLSearchParams({ ...query, ...feedQuery(filters), page: String(page) });
		const response = await fetch("/api/fetch_posts?" + params);
		const res = await response.json();
		return {
			items: ((res["feed_items"] ?? []) as Feedable[])
				.filter((item) => matchesFilters(item, filters))
				.map((item) => item.feedable as T),
			next: res["pagy"]?.["next"] ?? null,
		};
	};
}

const FEED_CARDS = {
	Post: { verb: "made a", kind: "post", accent: "sky", path: "/posts/" },
	Event: { verb: "created an", kind: "event", accent: "lime", path: "/events/" },
	Recommendation: {
		verb: "shared a",
		kind: "recommendation",
		accent: "fuchsia",
		path: "/recommendations/",
	},
} as const;

export const feedKey = (item: FeedItem) => item.class_name + item.id;

export function feedCard(item: FeedItem): FeedCardInfo {
	const kind = FEED_CARDS[item.class_name as FeedItemType];
	return {
		href: kind.path + item.id,
		title: item.title?.trim(),
		label: "open " + item.class_name.toLowerCase(),
		user: item.user,
		posted_at: item.created_at,
		verb: kind.verb,
		kind: kind.kind,
		accent: kind.accent,
	};
}

export const FEED_TYPE_OPTIONS = [
	{ value: "Post", label: "posts" },
	{ value: "Event", label: "events" },
	{ value: "Recommendation", label: "recommendations" },
];

const FEED_TYPES: FeedItemType[] = ["Post", "Event", "Recommendation"];

export function feedTypeFilter(url: URL): { types: FeedItemType[]; filters: FeedFilters } {
	const asked = (url.searchParams.get("type") ?? "").split(",");
	const types = FEED_TYPES.filter((t) => asked.includes(t));
	const some = types.length > 0 && types.length < FEED_TYPES.length;
	return { types: some ? types : [], filters: some ? { type: types } : {} };
}

export function feedTypeUrl(path: string, types: string[]): string {
	return types.length ? `${path}?type=${types.join(",")}` : path;
}
