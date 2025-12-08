<script lang="ts">
	import Link from "$lib/components/text/Link.svelte";
	import RecommendationCard from "$lib/components/posts/RecommendationCard.svelte";
	import PostCard from "$lib/components/posts/PostCard.svelte";
	import EventCard from "$lib/components/posts/EventCard.svelte";
	import { Textarea } from "$lib/components/ui/textarea";
	import { Button } from "$lib/components/ui/button";

	import { MessageCircleMore } from "@lucide/svelte";
	import Commentable from "$lib/components/posts/Commentable.svelte";

	let { feed_item } = $props();

	let by_line = " posted";

	let border_color = "border-orange-500";
	if (feed_item.class_name === "Event") {
		border_color = "border-blue-500";
		by_line = " posted an upcoming event";
	} else {
		border_color = "border-orange-500";
	}

	//TODO: Style the shadcn Button component to be a fun color!!
</script>

<div class="p-2 my-2 border-bottom-2 border-gray-600 rounded-lg shadow-md">
	{#if feed_item.class_name === "Recommendation"}
		<RecommendationCard {feed_item} />
	{:else if feed_item.class_name === "Post"}
		<PostCard {feed_item} />
	{:else}
		<div>
			<EventCard {feed_item} />
		</div>
	{/if}
	<Commentable comments={feed_item["comments"]} {feed_item} />
</div>
