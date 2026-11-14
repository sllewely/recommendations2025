<script lang="ts">
	import SubHeader from "$lib/components/SubHeader.svelte";
	import SubHeaderTitle from "$lib/components/SubHeaderTitle.svelte";
	import Button from "$lib/components/Button.svelte";
	import Feed from "$lib/components/posts/Feed.svelte";
	import PostCard from "$lib/components/posts/PostCard.svelte";
	import EventCard from "$lib/components/posts/EventCard.svelte";
	import RecommendationCard from "$lib/components/posts/RecommendationCard.svelte";
	import Link from "$lib/components/text/Link.svelte";
	import { feedCard, feedKey, feedPageLoader } from "$lib/feed";
	import type { Event, Post, Recommendation } from "$lib/api_calls/types";
	import type { PageProps } from "./$types.js";

	let { data }: PageProps = $props();
</script>

<SubHeader>
	{#if data.feed}
		<SubHeaderTitle title="feed" />
		<div class="flex flex-row gap-5">
			<Button href="/posts/create">new post</Button>
			<Button href="/events/create">new event</Button>
			<Button href="/recommendations/create">new rec</Button>
		</div>
	{:else}
		<SubHeaderTitle caption="welcome to my app!!!">
			<span class="text-yellow-400">bumblebeans</span> by
			<span class="text-amber-400">celery</span>
		</SubHeaderTitle>
	{/if}
</SubHeader>

<svelte:head>
	<title>Home</title>
	<meta name="description" content="Bumblebeans" />
</svelte:head>

{#if data.feed}
	<div class="flex flex-col gap-5">
		<Feed
			items={data.feed.feed_items.map((item) => item.feedable)}
			key={feedKey}
			card={feedCard}
			next_page={data.feed.next_page}
			load_page={feedPageLoader()}
		>
			{#snippet content(item)}
				{#if item.class_name === "Event"}
					<EventCard feed_item={item as Event} />
				{:else if item.class_name === "Recommendation"}
					<RecommendationCard feed_item={item as Recommendation} />
				{:else}
					<PostCard feed_item={item as Post} />
				{/if}
			{/snippet}
			{#snippet empty()}
				<div
					class="flex justify-center p-2 font-bold border-zinc-800 rounded-sm bg-lime-200 border dark:text-zinc-900"
				>
					<p>
						Your feed is empty!
						<Link url="/friends">Add friends!!</Link>
					</p>
				</div>
			{/snippet}
		</Feed>
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
