<script lang="ts">
	import { enhance } from "$app/forms";
	import * as Card from "$lib/components/ui/card/index.js";
	import Link from "$lib/components/text/Link.svelte";
	import H2 from "$lib/components/text/H2.svelte";
	import PlusCircle from "$lib/components/posts/PlusCircle.svelte";
	import TruncatedContent from "$lib/components/posts/TruncatedContent.svelte";
	import { current_user } from "$lib/state/current_user.svelte";
	import type { Recommendation } from "$lib/api_calls/types";
	import { parseAbsoluteToLocal } from "@internationalized/date";
	import {
		Book,
		BookmarkPlus,
		Clapperboard,
		Gamepad2,
		Link as LinkIcon,
		MessageCircleHeart,
		MonitorPlay,
		Shapes,
		Soup,
		Star,
	} from "@lucide/svelte";

	const media_type_icons: Record<string, typeof Book> = {
		book: Book,
		movie: Clapperboard,
		tv_show: MonitorPlay,
		video_game: Gamepad2,
		restaurant: Soup,
		url: LinkIcon,
	};

	interface Props {
		feed_item: Recommendation;
		in_feed?: boolean;
	}

	let { feed_item, in_feed = false }: Props = $props();

	let by_line = $derived.by(() => {
		if (feed_item.status === "watching") return " is watching";
		if (feed_item.status === "recommend") return " recommends";
		return " is interested in";
	});

	if (feed_item.class_name !== "Recommendation") {
		console.error("not a recommendation feed item");
	}

	let border_color = "border-yellow-500";

	const localizedCreateTime = parseAbsoluteToLocal(feed_item.created_at);
	const formattedCreateTime = new Intl.DateTimeFormat("en-US", {
		dateStyle: "medium",
		timeStyle: "short",
		timeZone: localizedCreateTime.timeZone,
	}).format(localizedCreateTime.toDate());

	let MediaIcon = $derived(media_type_icons[feed_item.media_type] ?? Shapes);

	let creating = $state(false);
</script>

<div>
	<div>
		{#if !in_feed && current_user.id !== feed_item.user.id}
			<div class="float-right relative">
				<div class="absolute top-0 right-0">
					<form
						method="POST"
						action="?/add_recommendation"
						use:enhance={() => {
							creating = true;
							return async ({ update }) => {
								await update();
								creating = false;
							};
						}}
					>
						<input type="hidden" name="title" value={feed_item.title} />
						<input type="hidden" name="media_type" value={feed_item.media_type} />
						<input type="hidden" name="who_recommended" value={feed_item.user.name} />
						<button type="submit">
							<PlusCircle />
						</button>
					</form>
				</div>
			</div>
		{/if}
		<div class="py-1">
			<a href="/recommendations/{feed_item.id}">
				<Card.Root
					class="{in_feed
						? 'border-0 shadow-none'
						: 'border-yellow-500 border-2'} hover:bg-yellow-100 dark:hover:bg-yellow-950 dark:bg-gray-900 dark:text-gray-200"
				>
					{#if in_feed}
						<div class="flex flex-row items-center gap-2 px-3 py-2">
							<MessageCircleHeart class="size-5 shrink-0 text-yellow-500" />
							<MediaIcon class="size-5 shrink-0" />
							<span class="truncate font-semibold">{feed_item.title}</span>
							<div class="ml-auto flex flex-row shrink-0">
								{#if feed_item.status === "interested"}
									<BookmarkPlus class="size-5" />
								{:else}
									{#each [1, 2, 3, 4, 5] as star}
										<Star class="size-4" fill={feed_item.rating >= star ? "yellow" : "none"} />
									{/each}
								{/if}
							</div>
						</div>
					{:else}
						<Card.Header class="px-3 pt-2">
							<Card.Title>{feed_item.title}</Card.Title>
						</Card.Header>
						<Card.Content class="px-3 py-1">
							<p>{feed_item.media_type}</p>
							{#if feed_item.notes}
								<TruncatedContent text={feed_item.notes}>
									<p>{feed_item.notes}</p>
								</TruncatedContent>
							{/if}
							{#if feed_item.url}
								<p class="truncate">
									<Link url={feed_item.url}>{feed_item.url}</Link>
								</p>
							{/if}
						</Card.Content>
					{/if}
				</Card.Root>
			</a>
		</div>
	</div>
</div>
