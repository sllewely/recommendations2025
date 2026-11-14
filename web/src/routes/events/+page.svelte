<script lang="ts">
	import { onMount } from "svelte";
	import SubHeader from "$lib/components/SubHeader.svelte";
	import SubHeaderTitle from "$lib/components/SubHeaderTitle.svelte";
	import Button from "$lib/components/Button.svelte";
	import Feed from "$lib/components/posts/Feed.svelte";
	import EventCard from "$lib/components/posts/EventCard.svelte";
	import SectionHeading from "$lib/components/text/SectionHeading.svelte";
	import Link from "$lib/components/text/Link.svelte";
	import type { Event } from "$lib/api_calls/types";
	import { formatDay, localDayKey } from "$lib/format_date";
	import { feedCard, feedKey } from "$lib/feed";
	import type { PageProps } from "./$types.js";

	let { data }: PageProps = $props();

	let events = $derived(data.events ?? []);

	// days depend on the viewer's timezone, so group only in the browser
	let mounted = $state(false);
	onMount(() => {
		mounted = true;
	});

	let days = $derived.by(() => {
		if (!mounted) return [];
		const groups: { key: string; heading: string; events: Event[] }[] = [];
		for (const event of events) {
			const key = localDayKey(event.start_date_time);
			const last = groups.at(-1);
			if (last?.key === key) {
				last.events.push(event);
			} else {
				groups.push({ key, heading: formatDay(event.start_date_time), events: [event] });
			}
		}
		return groups;
	});
</script>

<SubHeader>
	<SubHeaderTitle title="events" />
	<Button href="/events/create">new</Button>
</SubHeader>

{#if events.length === 0}
	<div
		class="flex justify-center p-2 font-bold border-zinc-800 rounded-sm bg-lime-200 border dark:text-zinc-900"
	>
		<p>
			no upcoming events!
			<Link url="/events/create">create an event</Link>
		</p>
	</div>
{:else if mounted}
	<div class="flex flex-col gap-10">
		{#each days as day (day.key)}
			<section class="flex flex-col gap-5">
				<SectionHeading>{day.heading}</SectionHeading>
				<Feed items={day.events} key={feedKey} card={feedCard} content={event_card} />
			</section>
		{/each}
	</div>
{:else}
	<Feed items={events} key={feedKey} card={feedCard} content={event_card} />
{/if}

{#snippet event_card(event: Event)}
	<EventCard feed_item={event} />
{/snippet}
