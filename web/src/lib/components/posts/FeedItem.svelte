<script lang="ts">
	import RecommendationCard from "$lib/components/posts/RecommendationCard.svelte";
	import PostCard from "$lib/components/posts/PostCard.svelte";
	import EventCard from "$lib/components/posts/EventCard.svelte";
	import UserCard from "$lib/components/users/UserCard.svelte";
	import ExpandableCommentable from "$lib/components/posts/ExpandableCommentable.svelte";
	import type { Post, Event, Recommendation } from "$lib/api_calls/types";
	import { parseAbsoluteToLocal } from "@internationalized/date";
	import Reactions from "$lib/components/reactions/Reactions.svelte";
	import PrivacyIcon from "$lib/components/posts/PrivacyIcon.svelte";
	import { ACCENTS, CARD, FEED_ACCENTS } from "$lib/components/posts/feed_styles";
	import { cn } from "$lib/utils.js";

	interface Props {
		feed_item: Post | Event | Recommendation;
	}

	let { feed_item }: Props = $props();

	let type_name = "a post";
	if (feed_item.class_name === "Event") {
		type_name = "an event";
	} else if (feed_item.class_name === "Recommendation") {
		type_name = "a recommendation";
	}
	const accent = ACCENTS[FEED_ACCENTS[feed_item.class_name] ?? "sky"];

	const localizedCreateTime = parseAbsoluteToLocal(feed_item.created_at);
	const formattedCreateTime = new Intl.DateTimeFormat("en-US", {
		month: "short",
		day: "numeric",
		timeZone: localizedCreateTime.timeZone,
	}).format(localizedCreateTime.toDate());
</script>

<div class="my-2 flex flex-col">
	<div class="mb-1 flex h-12 flex-row items-stretch gap-1.5">
		<div aria-hidden="true" class="flex aspect-square h-full shrink-0">
			<div
				class="mt-auto ml-auto size-[calc(50%+1px)] rounded-tl-xl border-t-2 border-l-2 border-dashed border-zinc-500 dark:border-zinc-400"
			></div>
		</div>
		<UserCard user={feed_item.user} subtitle="Posted">
			{#snippet subtitle_extra()}
				<span class={cn("font-bold", accent.text)}>{type_name}</span>
				{formattedCreateTime}
				<PrivacyIcon visibility={feed_item.visibility} />
			{/snippet}
		</UserCard>
	</div>

	<article
		class={cn(
			"relative flex flex-col gap-1 border border-dashed border-transparent",
			CARD,
			accent.hover,
		)}
	>
		{#if feed_item.class_name === "Recommendation"}
			<RecommendationCard {feed_item} in_feed />
		{:else if feed_item.class_name === "Post"}
			<PostCard {feed_item} in_feed />
		{:else}
			<EventCard {feed_item} in_feed />
		{/if}

		<ExpandableCommentable comments={feed_item["comments"]} {feed_item}>
			{#snippet actions()}
				<Reactions feedable={feed_item} />
			{/snippet}
		</ExpandableCommentable>
	</article>
</div>
