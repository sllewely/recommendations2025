<script lang="ts">
	import DateHeader from "$lib/components/posts/DateHeader.svelte";
	import FeedItem from "$lib/components/posts/FeedItem.svelte";
	import H1 from "$lib/components/text/H1.svelte";
	import Link from "$lib/components/text/Link.svelte";
	import { Button, buttonVariants } from "$lib/components/ui/button";
	import { CalendarPlus2, MessageCircleHeart, MessageSquareText } from "@lucide/svelte";
	import type { PageProps } from "./$types.js";
	import { parseAbsoluteToLocal } from "@internationalized/date";
	import type { Event } from "$lib/api_calls/types";
	import { onMount } from "svelte";
	import { Spinner } from "$lib/components/ui/spinner/index.js";
	import ShouldShowNotificationSubscribeButtonCard from "$lib/components/notifications/push/ShouldShowNotificationSubscribeButtonCard.svelte";
	import EventCard from "$lib/components/posts/EventCard.svelte";
	import * as Collapsible from "$lib/components/ui/collapsible";
	import CalendarCopy from "$lib/CalendarCopy.svelte";

	let { data }: PageProps = $props();

	// Mobile toggle state
	let activeTab = $state<"posts" | "events">("posts");

	let feed_items = $state(data.posts_response.feed_items);
	const pagination = data.posts_response.pagy;
	let next_page = $state(pagination.next);

	let localized_dater = function (event_item: Event): string {
		const localizedStartTime = parseAbsoluteToLocal(event_item.start_date_time);
		return new Intl.DateTimeFormat("en-US", {
			weekday: "short",
			month: "short",
			day: "numeric",
			timeZone: localizedStartTime.timeZone,
		}).format(localizedStartTime.toDate());
	};

	// chunk dates into localized dates
	let events_and_date_headers = [];
	if (data.events && data.events.length > 0) {
		let current_date = localized_dater(data.events[0]);
		events_and_date_headers.push({ date_header: current_date });
		for (const event of data.events) {
			let date = localized_dater(event);
			if (date !== current_date) {
				current_date = date;
				events_and_date_headers.push({ date_header: current_date });
			}
			events_and_date_headers.push(event);
		}
	}

	let fetching_more_posts = $state(false);

	onMount(() => {
		async function fetch_posts() {
			// Show loading spinner and make fetch request to api
			const response = await fetch("/api/fetch_posts?page=" + next_page, {
				method: "GET",
				headers: {
					"Content-Type": "application/json",
				},
			});
			const res = await response.json();
			feed_items = feed_items.concat(res["feed_items"]);
			next_page = res["pagy"]["next"];
		}

		// Fetch more posts when you reach the bottom
		window.addEventListener("scroll", function () {
			if (window.innerHeight + window.scrollY >= document.body.offsetHeight) {
				console.log("you're at the bottom of the page");
				if (!fetching_more_posts && next_page !== null) {
					fetching_more_posts = true;
					fetch_posts();
					fetching_more_posts = false;
				}
			}
		});
	});
</script>

<div id="top_detector">
	<ShouldShowNotificationSubscribeButtonCard />
	<div
		class="flex justify-center p-2 mb-2 font-bold border-gray-800 rounded-sm bg-lime-200 border-1"
	>
		<Link url="/friends">Add friends!!</Link>
	</div>

	<CalendarCopy />

	<!-- Mobile toggle buttons -->
	<div class="md:hidden mb-4">
		<div class="flex bg-gray-200 rounded-lg p-1">
			<button
				class="flex-1 py-2 px-4 rounded-md font-medium transition-colors {activeTab === 'posts'
					? 'bg-white text-gray-900 shadow-sm'
					: 'text-gray-600 hover:text-gray-900'}"
				onclick={() => (activeTab = "posts")}
			>
				Posts
			</button>
			<button
				class="flex-1 py-2 px-4 rounded-md font-medium transition-colors {activeTab === 'events'
					? 'bg-white text-gray-900 shadow-sm'
					: 'text-gray-600 hover:text-gray-900'}"
				onclick={() => (activeTab = "events")}
			>
				Events
			</button>
		</div>
	</div>

	<!-- Desktop layout (unchanged) -->
	<div class="hidden md:grid md:grid-cols-3">
		<div class="flex flex-col col-span-2">
			<H1>Posts</H1>

			<div class="flex justify-center pt-2 pb-2 space-x-2">
				<Button href="/posts/create" class={buttonVariants({ variant: "post" })}>
					<MessageSquareText /> &nbsp; New post
				</Button>
				<Button
					href="/recommendations/create"
					class={buttonVariants({ variant: "recommendation" })}
				>
					<MessageCircleHeart /> &nbsp; Share a recommendation
				</Button>
			</div>
			{#if feed_items.length === 0}
				<div
					class="flex justify-center p-2 mb-2 font-bold border-gray-800 rounded-sm bg-lime-200 border-1"
				>
					<p>
						Your feed is empty!
						<Link url="/friends">Add friends!!</Link>
					</p>
				</div>
			{/if}
			<div>
				{#each feed_items as feed_item}
					<FeedItem feed_item={feed_item.feedable} />
				{/each}
			</div>
			{#if fetching_more_posts}
				<div class="flex justify-center pt-20">
					<Spinner class="size-24" />
				</div>
			{/if}

			{#if !next_page}
				<div class="flex justify-center pt-20">Reached the end of time :)</div>
			{/if}
		</div>
		<div class="flex flex-col pl-2">
			<H1>Events</H1>

			<div class="flex justify-center pt-2 pb-2">
				<Button href="/events/create" class={buttonVariants({ variant: "event" })}>
					<CalendarPlus2 /> &nbsp; Create event
				</Button>
			</div>
			{#if events_and_date_headers.length === 0}
				<div
					class="flex justify-center p-2 mb-2 font-bold border-gray-800 rounded-sm bg-lime-200 border-1 dark:text-gray-900"
				>
					<p>
						No upcoming events.
						<Link url="/events/create">Create a new event</Link>
					</p>
				</div>
			{/if}
			{#each events_and_date_headers as event_item}
				{#if !!event_item["date_header"]}
					<DateHeader {event_item} />
				{:else}
					<EventCard feed_item={event_item} />
				{/if}
			{/each}
		</div>
	</div>

	<!-- Mobile layout with toggle -->
	<div class="md:hidden">
		{#if activeTab === "posts"}
			<div class="flex flex-col">
				<H1>Posts</H1>

				<div class="flex justify-center pt-2 pb-2 space-x-2">
					<Button href="/posts/create" class={buttonVariants({ variant: "post" })}>
						<MessageSquareText /> &nbsp; New post
					</Button>
					<Button
						href="/recommendations/create"
						class={buttonVariants({ variant: "recommendation" })}
					>
						<MessageCircleHeart /> &nbsp; Share a recommendation
					</Button>
				</div>
				{#if feed_items.length === 0}
					<div
						class="flex justify-center p-2 mb-2 font-bold border-gray-800 rounded-sm bg-lime-200 border-1"
					>
						<p>
							Your feed is empty!
							<Link url="/friends">Add friends!!</Link>
						</p>
					</div>
				{/if}
				<div>
					{#each feed_items as feed_item}
						<FeedItem feed_item={feed_item.feedable} />
					{/each}
				</div>
				{#if fetching_more_posts}
					<div class="flex justify-center pt-20">
						<Spinner class="size-24" />
					</div>
				{/if}

				{#if !next_page}
					<div class="flex justify-center pt-20">Reached the end of time :)</div>
				{/if}
			</div>
		{:else}
			<div class="flex flex-col">
				<H1>Events</H1>

				<div class="flex justify-center pt-2 pb-2">
					<Button href="/events/create" class={buttonVariants({ variant: "event" })}>
						<CalendarPlus2 /> &nbsp; Create event
					</Button>
				</div>
				{#if events_and_date_headers.length === 0}
					<div
						class="flex justify-center p-2 mb-2 font-bold border-gray-800 rounded-sm bg-lime-200 border-1 dark:text-gray-900"
					>
						<p>
							No upcoming events.
							<Link url="/events/create">Create a new event</Link>
						</p>
					</div>
				{/if}
				{#each events_and_date_headers as event_item}
					{#if !!event_item["date_header"]}
						<DateHeader {event_item} />
					{:else}
						<EventCard feed_item={event_item} />
					{/if}
				{/each}
			</div>
		{/if}
	</div>
</div>
