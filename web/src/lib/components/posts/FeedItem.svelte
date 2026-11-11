<script lang="ts">
	import RecommendationCard from "$lib/components/posts/RecommendationCard.svelte";
	import PostCard from "$lib/components/posts/PostCard.svelte";
	import EventCard from "$lib/components/posts/EventCard.svelte";
	import UserCard from "$lib/components/users/UserCard.svelte";
	import ExpandableCommentable from "$lib/components/posts/ExpandableCommentable.svelte";
	import type { Post, Event, Recommendation } from "$lib/api_calls/types";
	import { parseAbsoluteToLocal } from "@internationalized/date";
	import Reactions from "$lib/components/reactions/Reactions.svelte";

	interface Props {
		feed_item: Post | Event | Recommendation;
	}

	let { feed_item }: Props = $props();

	let by_line = " posted";

	let border_color = "border-orange-500";
	if (feed_item.class_name === "Event") {
		border_color = "border-lime-500";
		by_line = " posted an upcoming event";
	} else if (feed_item.class_name === "Recommendation") {
		border_color = "border-yellow-500";
	}

	const localizedCreateTime = parseAbsoluteToLocal(feed_item.created_at);
	const formattedCreateTime = new Intl.DateTimeFormat("en-US", {
		dateStyle: "medium",
		timeStyle: "short",
		timeZone: localizedCreateTime.timeZone,
	}).format(localizedCreateTime.toDate());

	//TODO: Style the shadcn Button component to be a fun color!!
</script>

<div class="px-2 py-1 my-2 border-l-4 {border_color} rounded-r-lg shadow-md">
	<div class="flex flex-row justify-between">
		<div>
			<UserCard user={feed_item.user} />
		</div>
		<div>
			<span class="text-sm">posted at {formattedCreateTime}</span>
		</div>
	</div>

	{#if feed_item.class_name === "Recommendation"}
		<RecommendationCard {feed_item} in_feed />
	{:else if feed_item.class_name === "Post"}
		<PostCard {feed_item} in_feed />
	{:else}
		<EventCard {feed_item} in_feed />
	{/if}

	<Reactions feedable={feed_item} />
	<ExpandableCommentable comments={feed_item["comments"]} {feed_item} />
</div>
