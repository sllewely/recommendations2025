<script lang="ts">
	import type { Post } from "$lib/api_calls/types";
	import Item from "$lib/components/posts/Item.svelte";

	interface Props {
		feed_item: Post;
		truncate?: boolean;
	}

	let { feed_item, truncate = true }: Props = $props();
</script>

<Item {feed_item} description={feed_item.content} lines={6} {truncate} />
