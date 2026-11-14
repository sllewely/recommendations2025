<script lang="ts">
	import type { Event, Post, Recommendation } from "$lib/api_calls/types";
	import PostCard from "$lib/components/posts/PostCard.svelte";
	import EventCard from "$lib/components/posts/EventCard.svelte";
	import RecommendationCard from "$lib/components/posts/RecommendationCard.svelte";

	let { feed_item }: { feed_item: Post | Event | Recommendation } = $props();
</script>

{#if feed_item.class_name === "Event"}
	<EventCard feed_item={feed_item as Event} />
{:else if feed_item.class_name === "Recommendation"}
	<RecommendationCard feed_item={feed_item as Recommendation} />
{:else}
	<PostCard feed_item={feed_item as Post} />
{/if}
