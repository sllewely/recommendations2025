<script lang="ts">
	import Card from "$lib/components/Card.svelte";
	import H2 from "$lib/components/text/H2.svelte";
	import Link from "$lib/components/text/Link.svelte";
	import { isSignedIn } from "$lib/state/current_user.svelte";
	import { parseAbsolute, parseAbsoluteToLocal } from "@internationalized/date";
	import { current_user } from "$lib/state/current_user.svelte.js";
	import type { Event } from "$lib/api_calls/types";
	import RsvpBadge from "$lib/components/ui/badge/RsvpBadge.svelte";
	import MarkedDownPost from "$lib/components/posts/MarkedDownPost.svelte";
	import * as Tooltip from "$lib/components/ui/tooltip/index.js";
	import { onMount } from "svelte";

	interface Props {
		feed_item: Event;
	}

	let { feed_item }: Props = $props();

	if (feed_item.class_name !== "Event") {
		console.error("not an event feed item");
	}

	let signed_in = isSignedIn();

	// TODO: Going should match on my id instead of current user rsvp
	// should be updateable state
	let current_user_rsvp = feed_item.rsvps.find((rsvp) => rsvp.user.id === current_user.id) ?? null;

	let localizedCreateTime = $state(parseAbsoluteToLocal(feed_item.created_at));
	let formattedCreateTime = $state();
	let localizedStartTime = $state(parseAbsoluteToLocal(feed_item.start_date_time));
	let formattedStartTime = $state();

	onMount(() => {
		localizedCreateTime = parseAbsoluteToLocal(feed_item.created_at);
		// console.log("localizedCreateTime", $state.snapshot(localizedCreateTime));

		formattedCreateTime = new Intl.DateTimeFormat("en-US", {
			dateStyle: "medium",
			timeStyle: "short",
			timeZone: localizedCreateTime.timeZone,
		}).format(localizedCreateTime.toDate());
		// console.log("formattedCreateTime", $state.snapshot(formattedCreateTime));

		console.log("original start date time", parseAbsolute(feed_item.start_date_time));
		localizedStartTime = parseAbsoluteToLocal(feed_item.start_date_time);
		console.log("localizedStartTime", $state.snapshot(localizedStartTime));
		formattedStartTime = new Intl.DateTimeFormat("en-US", {
			dateStyle: "medium",
			timeStyle: "short",
			timeZone: localizedCreateTime.timeZone,
		}).format(localizedStartTime.toDate());
		console.log("formattedStartTime", $state.snapshot(formattedStartTime));
		console.log("timezone", localizedCreateTime.timeZone);
	});
</script>

<div>
	<div class="flex flex-row justify-between">
		<!--        <svelte:boundary>-->
		<div>
			<span class="font-bold">
				<!-- I just broke this for the feed TODO SARAH -->
				<Link url="/users/{feed_item.user.id}">{feed_item.user.name}</Link>
			</span> posted an upcoming event
		</div>
		<!--        <div><span class="font-bold"><a class="text-teal-400 hover:text-orange-400" href="/users/{feed_item.creator_id}">{feed_item.creator_name}</a></span> posted an upcoming event</div>-->
		<!--        </svelte:boundary>-->
		<div>
			<span class="text-sm">at {formattedCreateTime}</span>
		</div>
	</div>
	<div class="p-2">
		<a href="/events/{feed_item.id}">
			<Card border_color="border-lime-500" hover_color="hover:bg-lime-100">
				<H2>{feed_item.title}</H2>
				{#if feed_item.description}
					<MarkedDownPost captured_text={feed_item.description} />
				{/if}
				<p>Happening {formattedStartTime}</p>
				{#if feed_item.address}
					<p>at {feed_item.address}</p>
				{/if}
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
				{#if feed_item.event_type}
					<p>{feed_item.event_type}</p>
				{/if}

				<div>
					<RsvpBadge rsvp={current_user_rsvp} />
				</div>
			</Card>
		</a>
	</div>
</div>
