<script lang="ts">
	import FeedItem from "$lib/components/posts/FeedItem.svelte";
	import Link from "$lib/components/text/Link.svelte";
	import Button from "$lib/components/Button.svelte";
	import { MessageCircleHeart } from "@lucide/svelte";
	import type { PageProps } from "./$types.js";
	import { parseAbsoluteToLocal } from "@internationalized/date";
	import type { Event } from "$lib/api_calls/types";
	import { onMount } from "svelte";
	import { Spinner } from "$lib/components/ui/spinner/index.js";
	import EventCard from "$lib/components/posts/EventCard.svelte";
	import { CalendarDays, CalendarPlus, NotebookPen } from "lucide-svelte";

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

{#snippet feed_column()}
	<section class="flex min-w-0 flex-col">
		<div class="flex flex-row flex-wrap items-center justify-between gap-3">
			<h2 class="text-lg font-bold leading-tight">posts</h2>
			<div class="flex flex-row flex-wrap gap-2">
				<Button href="/posts/create">
					<NotebookPen />
					new post
				</Button>
				<Button href="/events/create">
					<CalendarPlus />
					new event
				</Button>
				<Button href="/recommendations/create">
					<MessageCircleHeart />
					new rec
				</Button>
			</div>
		</div>

		{#if feed_items.length === 0}
			<p class="mt-5 text-zinc-500 dark:text-zinc-400">
				your feed is empty! <Link url="/friends">add friends!!</Link>
			</p>
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
			<div class="flex justify-center pt-10 italic text-zinc-500 dark:text-zinc-400">
				Reached the end of time :)
			</div>
		{/if}
	</section>
{/snippet}

{#snippet calendar_column()}
	<section class="flex min-w-0 flex-col">
		<div class="flex flex-row flex-wrap items-center justify-between gap-3">
			<h2 class="text-lg font-bold leading-tight">calendar</h2>
			<Button href="/events/create">
				<CalendarPlus />
				new event
			</Button>
		</div>

		{#if events_and_date_headers.length === 0}
			<p class="mt-5 text-sm text-zinc-500 dark:text-zinc-400">
				no upcoming events. <Link url="/events/create">create a new event</Link>
			</p>
		{/if}
		{#each events_and_date_headers as event_item}
			{#if !!event_item["date_header"]}
				<h3 class="mt-5 text-sm font-bold text-zinc-500 dark:text-zinc-400">
					{event_item.date_header}
				</h3>
			{:else}
				<EventCard feed_item={event_item} />
			{/if}
		{/each}
	</section>
{/snippet}

<div>
	<!-- Mobile toggle buttons -->
	<div class="md:hidden mb-6 flex flex-row gap-2">
		<Button
			variant={activeTab === "posts" ? "filled" : "dashed"}
			color={activeTab === "posts" ? "yellow" : "zinc"}
			aria-pressed={activeTab === "posts"}
			class="flex-1"
			onclick={() => (activeTab = "posts")}
		>
			<NotebookPen />
			posts
		</Button>
		<Button
			variant={activeTab === "events" ? "filled" : "dashed"}
			color={activeTab === "events" ? "yellow" : "zinc"}
			aria-pressed={activeTab === "events"}
			class="flex-1"
			onclick={() => (activeTab = "events")}
		>
			<CalendarDays />
			calendar
		</Button>
	</div>

	<!-- Desktop layout -->
	<div class="hidden md:grid md:grid-cols-3 md:gap-10">
		<div class="col-span-2">
			{@render feed_column()}
		</div>
		{@render calendar_column()}
	</div>

	<!-- Mobile layout with toggle -->
	<div class="md:hidden">
		{#if activeTab === "posts"}
			{@render feed_column()}
		{:else}
			{@render calendar_column()}
		{/if}
	</div>
</div>
