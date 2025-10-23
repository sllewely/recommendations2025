<script lang="ts">
	import DateHeader from "$lib/components/posts/DateHeader.svelte";
	import EventFeedItem from "$lib/components/posts/EventFeedItem.svelte";
	import FeedItem from "$lib/components/posts/FeedItem.svelte";
	import H1 from "$lib/components/text/H1.svelte";
	import Link from "$lib/components/text/Link.svelte";
	import { Button, buttonVariants } from "$lib/components/ui/button";
	import { CalendarPlus2, MessageCircleHeart, MessageSquareText } from "@lucide/svelte";
	import type { PageProps } from "./$types.js";

	let { data }: PageProps = $props();

	const feed_items = data.posts_response.feed_items;
	const pagination = data.posts_response.pagy;

	// SARAH!!
</script>

{console.log(feed_items)}

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
			{#each feed_items as feed_item}
				<FeedItem feed_item={feed_item.feedable} />
			{/each}
		</div>
		<div class="flex flex-col pl-2">
			<H1>Events</H1>

			<div class="flex justify-center pt-2 pb-2">
				<Button href="/events/create" class={buttonVariants({ variant: "event" })}>
					<CalendarPlus2 /> &nbsp; Create event
				</Button>
			</div>
			{#if data.events.length === 0}
				<div
					class="flex justify-center p-2 mb-2 font-bold border-gray-800 rounded-sm bg-lime-200 border-1"
				>
					<p>
						No upcoming events.
						<Link url="/events/create">Create a new event</Link>
					</p>
				</div>
			{/if}
			{#each data.events as event_item}
				{#if !!event_item["date_header"]}
					<DateHeader {event_item} />
				{:else}
					<EventFeedItem {event_item} />
				{/if}
			{/each}
		</div>
	</div>
</div>
