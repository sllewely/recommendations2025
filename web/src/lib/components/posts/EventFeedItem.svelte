<script lang="ts">
	import Card from "$lib/components/Card.svelte";
	import Link from "$lib/components/text/Link.svelte";
	import H2 from "$lib/components/text/H2.svelte";
	import { parseAbsoluteToLocal } from "@internationalized/date";
	import { current_user } from "$lib/state/current_user.svelte";
	import RsvpBadge from "$lib/components/ui/badge/RsvpBadge.svelte";
	import type { Event } from "$lib/api_calls/types";
	import MarkedDownPost from "$lib/components/posts/MarkedDownPost.svelte";

	interface Props {
		event_item: Event;
	}
	let { event_item }: Props = $props();

	let current_user_rsvp = event_item.rsvps.find((rsvp) => rsvp.user.id === current_user.id) ?? null;

	const localizedStartTime = parseAbsoluteToLocal(event_item.start_date_time);
	const formattedStartTime = new Intl.DateTimeFormat("en-US", {
		dateStyle: "medium",
		timeStyle: "short",
		timeZone: localizedStartTime.timeZone,
	}).format(localizedStartTime.toDate());
</script>

<div class="p-2">
	<div class="p-2 my-2 border-bottom-2 border-gray-600 rounded-lg shadow-md">
		<p>posted by <Link url="/users/{event_item.user.id}">{event_item.user.name}</Link></p>

		<div class="p-2">
			<a href="/events/{event_item.id}">
				<Card border_color="border-lime-500" hover_color="hover:bg-lime-100">
					<H2>{event_item.title}</H2>
					{#if event_item.description}
						<MarkedDownPost captured_text={event_item.description} />
					{/if}
					<p>At {formattedStartTime}</p>
					{#if event_item.address}
						<p>at {event_item.address}</p>
					{/if}
					{#if event_item.url}
						<Link url={event_item.url}>{event_item.url}</Link>
					{/if}
					{#if event_item.event_type}
						<p>{event_item.event_type}</p>
					{/if}

					<div>
						<RsvpBadge rsvp={current_user_rsvp} />
					</div>
				</Card>
			</a>
		</div>
	</div>
</div>
