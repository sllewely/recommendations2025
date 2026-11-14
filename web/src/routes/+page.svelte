<script lang="ts">
	import SubHeader from "$lib/components/SubHeader.svelte";
	import SubHeaderTitle from "$lib/components/SubHeaderTitle.svelte";
	import SectionHeading from "$lib/components/text/SectionHeading.svelte";
	import Feed from "$lib/components/posts/Feed.svelte";
	import AnyCard from "$lib/components/posts/AnyCard.svelte";
	import CalendarStrip from "$lib/components/posts/CalendarStrip.svelte";
	import Button from "$lib/components/Button.svelte";
	import FilterGroup from "$lib/components/form/FilterGroup.svelte";
	import Link from "$lib/components/text/Link.svelte";
	import { goto } from "$app/navigation";
	import { onMount } from "svelte";
	import { FEED_TYPE_OPTIONS, feedCard, feedKey, feedPageLoader, feedTypeUrl } from "$lib/feed";
	import { current_user } from "$lib/state/current_user.svelte";
	import type { PageProps } from "./$types.js";

	let { data }: PageProps = $props();

	// phones get feed and calendar as separate pages instead of stacked
	onMount(() => {
		if (data.feed && window.matchMedia("(max-width: 767px)").matches) {
			goto("/feed" + location.search, { replaceState: true });
		}
	});

	const RSVPS = [
		{ value: "going", label: "going" },
		{ value: "interested", label: "interested" },
		{ value: "invited", label: "invited" },
	];
	let rsvp = $state<string[]>([]);

	const filter_feed = (types: string[]) =>
		goto(feedTypeUrl("/", types), { noScroll: true, keepFocus: true });
	let load_page = $derived(feedPageLoader(data.filters));
	let all_events = $state(data.events.map((event) => ({ ...event, rsvps: event.rsvps ?? [] })));
	let events = $derived(
		rsvp.length
			? all_events.filter((event) =>
					rsvp.includes(event.rsvps.find((r) => r.user?.id === current_user.id)?.status ?? ""),
				)
			: all_events,
	);
</script>

<SubHeader>
	{#if data.feed}
		<SubHeaderTitle title="home" />
		<div class="flex flex-row gap-5">
			<Button href="/posts/create">new post</Button>
			<Button href="/events/create">new event</Button>
			<Button href="/recommendations/create">new rec</Button>
		</div>
	{:else}
		<SubHeaderTitle caption="welcome to my app!!!">
			<span class="text-yellow-500 dark:text-yellow-400">bumblebeans</span> by
			<span class="text-amber-500 dark:text-amber-400">celery</span>
		</SubHeaderTitle>
	{/if}
</SubHeader>

<svelte:head>
	<title>Home</title>
	<meta name="description" content="Bumblebeans" />
</svelte:head>

{#if data.feed}
	<div class="flex flex-col gap-10">
		<section class="flex min-w-0 flex-col gap-3">
			<div class="flex flex-row flex-wrap items-center justify-between gap-3">
				<SectionHeading><a href="/calendar" class="hover:underline">calendar</a></SectionHeading>
				<FilterGroup label="rsvp" options={RSVPS} bind:value={rsvp} class="justify-end" />
			</div>
			<CalendarStrip {events} />
		</section>

		<section class="flex flex-col gap-3">
			<div class="flex flex-row flex-wrap items-center justify-between gap-3">
				<SectionHeading><a href="/feed" class="hover:underline">feed</a></SectionHeading>
				<FilterGroup
					label="show"
					options={FEED_TYPE_OPTIONS}
					value={data.types}
					onchange={filter_feed}
					class="justify-end"
				/>
			</div>
			{#key data.types.join()}
				<Feed
					items={data.feed.feed_items.map((item) => item.feedable)}
					key={feedKey}
					card={feedCard}
					next_page={data.feed.next_page}
					{load_page}
				>
					{#snippet content(item)}
						<AnyCard feed_item={item} />
					{/snippet}
					{#snippet empty()}
						<p class="text-zinc-500 dark:text-zinc-400">
							your feed is empty! <Link url="/users/{current_user.id}">add friends</Link>
						</p>
					{/snippet}
				</Feed>
			{/key}
		</section>
	</div>
{:else}
	<section>
		<p>demo instructions</p>

		<ul>
			<li>- on your phone</li>
			<li>- create an account</li>
			<li>- sign in!</li>
			<li>- enable notifications</li>
			<li>- add friends :)</li>
			<li>- make a post!!!</li>
			<li>- create an event or save a book, movie, etc you want to remember or share</li>
			<li>- download the app as a pwa</li>
		</ul>
	</section>
{/if}
