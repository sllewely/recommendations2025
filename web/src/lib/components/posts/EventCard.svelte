<script lang="ts">
	import { onMount } from "svelte";
	import type { Event } from "$lib/api_calls/types";
	import { formatWhen } from "$lib/format_date";
	import Item, { type Attribute } from "$lib/components/posts/Item.svelte";
	import RsvpList from "$lib/components/rsvp/RsvpList.svelte";

	interface Props {
		feed_item: Event;
		truncate?: boolean;
		panels?: boolean;
	}

	let { feed_item, truncate = true, panels = true }: Props = $props();
	let rsvps = $state(feed_item.rsvps ?? []);
	let start = $state("");

	onMount(() => {
		start = formatWhen(feed_item.start_date_time);
	});

	let attributes = $derived<Attribute[]>([
		{ label: "on", value: start },
		...(feed_item.address ? [{ label: "at", value: feed_item.address }] : []),
		...(feed_item.url ? [{ label: "see", value: feed_item.url, href: feed_item.url }] : []),
	]);
</script>

<Item
	{feed_item}
	{attributes}
	description={feed_item.description}
	lines={2}
	{truncate}
	{panels}
	rsvps={rsvps_panel}
	rsvp_count={rsvps.length}
/>

{#snippet rsvps_panel()}
	<RsvpList event_id={feed_item.id} bind:rsvps />
{/snippet}
