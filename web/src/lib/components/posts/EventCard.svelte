<script lang="ts">
	import { parseAbsolute, parseAbsoluteToLocal } from "@internationalized/date";
	import { current_user } from "$lib/state/current_user.svelte";
	import type { Event } from "$lib/api_calls/types";
	import RsvpBadge from "$lib/components/ui/badge/RsvpBadge.svelte";
	import MarkedDownPost from "$lib/components/posts/MarkedDownPost.svelte";
	import TruncatedContent from "$lib/components/posts/TruncatedContent.svelte";
	import * as Card from "$lib/components/ui/card/index.js";
	import { onMount } from "svelte";
	import { CalendarDays } from "@lucide/svelte";
	import UserCard from "$lib/components/users/UserCard.svelte";

	interface Props {
		feed_item: Event;
		// inside a FeedItem, which supplies the border; otherwise (the calendar) the card
		// draws its own left border and shows a truncated description
		in_feed?: boolean;
	}

	let { feed_item, in_feed = false }: Props = $props();

	// TODO: Going should match on my id instead of current user rsvp
	// should be updateable state
	let current_user_rsvp = $derived(
		feed_item.rsvps.find((rsvp) => rsvp.user.id === current_user.id) ?? null,
	);

	let localizedCreateTime = $state(parseAbsoluteToLocal(feed_item.created_at));
	let formattedCreateTime = $state();
	let localizedStartTime = $state(parseAbsoluteToLocal(feed_item.start_date_time));
	let briefStartDateTime = $state();

	onMount(() => {
		localizedCreateTime = parseAbsoluteToLocal(feed_item.created_at);

		formattedCreateTime = new Intl.DateTimeFormat("en-US", {
			dateStyle: "medium",
			timeStyle: "short",
			timeZone: localizedCreateTime.timeZone,
		}).format(localizedCreateTime.toDate());

		localizedStartTime = parseAbsoluteToLocal(feed_item.start_date_time);
		// e.g. "7PM Mon Sept 28" or "7:30PM Mon Sept 28"
		const start = localizedStartTime.toDate();
		const briefTime = new Intl.DateTimeFormat("en-US", {
			hour: "numeric",
			minute: localizedStartTime.minute === 0 ? undefined : "2-digit",
			hour12: true,
			timeZone: localizedStartTime.timeZone,
		})
			.format(start)
			.replace(/\s/g, "");
		const dateParts = new Intl.DateTimeFormat("en-US", {
			weekday: "short",
			month: "short",
			day: "numeric",
			timeZone: localizedStartTime.timeZone,
		}).formatToParts(start);
		const part = (type: string) => dateParts.find((p) => p.type === type)?.value;
		const month = part("month") === "Sep" ? "Sept" : part("month");
		briefStartDateTime = `${briefTime} ${part("weekday")} ${month} ${part("day")}`;
	});
</script>

<div class={in_feed ? "py-1" : "px-2 py-1 my-2 border-l-4 border-lime-500 rounded-r-lg shadow-md"}>
	{#if !in_feed}
		<UserCard user={feed_item.user} />
	{/if}
	<a href="/events/{feed_item.id}">
		<Card.Root
			class="border-0 shadow-none dark:bg-gray-900 dark:text-gray-200 hover:bg-lime-100 dark:hover:bg-emerald-950"
		>
			<Card.Header class="px-3 pt-2 pb-2 space-y-0.5">
				{#if feed_item.title}
					<Card.Title class="flex flex-row items-center gap-2">
						<CalendarDays class="size-5 shrink-0 text-lime-500" />
						{feed_item.title}
					</Card.Title>
				{/if}
				<div class="flex flex-row items-center justify-between gap-2">
					<Card.Description>
						Happening {briefStartDateTime}
					</Card.Description>
					<RsvpBadge rsvp={current_user_rsvp} />
				</div>
			</Card.Header>
			{#if !in_feed && feed_item.description}
				<Card.Content class="px-3 pt-0 pb-2">
					<!-- ~2 lines: two 1.5rem lines plus the paragraph's top margin -->
					<TruncatedContent
						text={feed_item.description}
						thresholdLength={120}
						thresholdLines={2}
						collapsedClass="max-h-[3.25rem]"
						buttonClass="text-xs leading-none"
					>
						<MarkedDownPost captured_text={feed_item.description} />
					</TruncatedContent>
				</Card.Content>
			{/if}
		</Card.Root>
	</a>
</div>
