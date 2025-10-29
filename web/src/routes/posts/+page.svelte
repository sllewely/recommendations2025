<script lang="ts">
	import DateHeader from "$lib/components/posts/DateHeader.svelte";
	import EventFeedItem from "$lib/components/posts/EventFeedItem.svelte";
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

	let { data }: PageProps = $props();

	const feed_items = data.posts_response.feed_items;
	const pagination = data.posts_response.pagy;

	let localized_dater = function (event_item: Event): string {
		const localizedStartTime = parseAbsoluteToLocal(event_item.start_date_time);
		return new Intl.DateTimeFormat("en-US", {
			dateStyle: "medium",
			timeZone: localizedStartTime.timeZone,
		}).format(localizedStartTime.toDate());
	};

	// chunk dates into localized dates
	let events_and_date_headers = [];
	if (data.events) {
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
		let next_page = pagination.next;

		async function fetch_posts() {
			// Show loading spinner and make fetch request to api
			const response = await fetch("/api/fetch_posts?page=" + next_page, {
				method: "GET",
				headers: {
					"Content-Type": "application/json",
				},
			});
			const res = await response.json();
		}
		window.addEventListener("scroll", function () {
			if (window.innerHeight + window.scrollY >= document.body.offsetHeight) {
				console.log("you're at the bottom of the page");
				if (!fetching_more_posts) {
					fetching_more_posts = true;
					fetch_posts();
					fetching_more_posts = false;
				}
			}
		});
	});
</script>

<div>
	<div
		class="flex justify-center p-2 mb-2 font-bold border-gray-800 rounded-sm bg-lime-200 border-1"
	>
		<Link url="/friends">Add friends!!</Link>
	</div>

	<div class="grid grid-cols-3">
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
			<div class="flex justify-center pt-20">
				{#if fetching_more_posts}
					<Spinner class="size-24" />
				{/if}
			</div>
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
					class="flex justify-center p-2 mb-2 font-bold border-gray-800 rounded-sm bg-lime-200 border-1"
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
					<EventFeedItem {event_item} />
				{/if}
			{/each}
		</div>
	</div>
</div>
