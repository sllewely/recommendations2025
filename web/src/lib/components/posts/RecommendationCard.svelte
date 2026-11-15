<script lang="ts">
	import type { Recommendation } from "$lib/api_calls/types";
	import Item, { type Attribute } from "$lib/components/posts/Item.svelte";

	interface Props {
		feed_item: Recommendation;
		truncate?: boolean;
	}

	let { feed_item, truncate = true }: Props = $props();

	let stars = $derived(
		feed_item.rating > 0 ? "★".repeat(feed_item.rating) + "☆".repeat(5 - feed_item.rating) : "",
	);

	let attributes = $derived<Attribute[]>(
		[
			{ label: "am", value: feed_item.status },
			{ label: "from", value: feed_item.who_recommended },
			{ label: "is", value: feed_item.media_type },
			{ label: "see", value: feed_item.url, href: feed_item.url },
			{ label: "give it a", value: stars },
		].filter((attribute) => attribute.value),
	);
</script>

<Item {feed_item} {attributes} description={feed_item.notes} lines={4} {truncate} />
