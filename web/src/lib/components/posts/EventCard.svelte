<script lang="ts">
	import Link from "$lib/components/text/Link.svelte";
	import { parseAbsolute, parseAbsoluteToLocal } from "@internationalized/date";
	import { current_user } from "$lib/state/current_user.svelte";
	import type { Event } from "$lib/api_calls/types";
	import RsvpBadge from "$lib/components/ui/badge/RsvpBadge.svelte";
	import MarkedDownPost from "$lib/components/posts/MarkedDownPost.svelte";
	import * as Tooltip from "$lib/components/ui/tooltip/index.js";
	import * as Card from "$lib/components/ui/card/index.js";
	import { onMount } from "svelte";

	interface Props {
		feed_item: Event;
	}

	let { feed_item }: Props = $props();

	if (feed_item.class_name !== "Event") {
		console.error("not an event feed item");
	}

	// TODO: Going should match on my id instead of current user rsvp
	// should be updateable state
	let current_user_rsvp = $derived(
		feed_item.rsvps.find((rsvp) => rsvp.user.id === current_user.id) ?? null,
	);

	let localizedCreateTime = $state(parseAbsoluteToLocal(feed_item.created_at));
	let formattedCreateTime = $state();
	let localizedStartTime = $state(parseAbsoluteToLocal(feed_item.start_date_time));
	let formattedStartTime = $state();

	onMount(() => {
		localizedCreateTime = parseAbsoluteToLocal(feed_item.created_at);

		formattedCreateTime = new Intl.DateTimeFormat("en-US", {
			dateStyle: "medium",
			timeStyle: "short",
			timeZone: localizedCreateTime.timeZone,
		}).format(localizedCreateTime.toDate());

		localizedStartTime = parseAbsoluteToLocal(feed_item.start_date_time);
		formattedStartTime = new Intl.DateTimeFormat("en-US", {
			dateStyle: "medium",
			timeStyle: "short",
			timeZone: localizedCreateTime.timeZone,
		}).format(localizedStartTime.toDate());
	});
</script>

<div>
	<div class="p-2">
		<a href="/events/{feed_item.id}">
			<Card.Root
				class="dark:bg-gray-900 dark:text-gray-200 border-lime-500 hover:bg-lime-100 border-2 dark:hover:bg-emerald-950"
			>
				<Card.Header>
					{#if feed_item.title}
						<Card.Title>{feed_item.title}</Card.Title>
					{/if}
					<Card.Description>Happening {formattedStartTime}</Card.Description>
				</Card.Header>
				<Card.Content>
					{#if feed_item.description}
						<MarkedDownPost captured_text={feed_item.description} />
					{/if}
					<div class="text-sm text-gray-500">
						{#if feed_item.address}
							<p>at {feed_item.address}</p>
						{/if}
					</div>
					<div class="flex flex-row justify-between">
						<div>
							<RsvpBadge rsvp={current_user_rsvp} />
						</div>
						{#if feed_item.url}
							<Tooltip.Provider>
								<Tooltip.Root>
									<Tooltip.Trigger>
										<Link url={feed_item.url}>link</Link>
									</Tooltip.Trigger>
									<Tooltip.Content>
										<p>{feed_item.url}</p>
									</Tooltip.Content>
								</Tooltip.Root>
							</Tooltip.Provider>
						{/if}
					</div>
				</Card.Content>
			</Card.Root>
		</a>
	</div>
</div>
