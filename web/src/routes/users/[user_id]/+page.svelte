<script lang="ts">
	import H1 from "$lib/components/text/H1.svelte";
	import { Badge } from "$lib/components/ui/badge";
	import type { User, FriendStatus, Feedable } from "$lib/api_calls/types";
	import FriendStatusButton from "$lib/components/users/FriendStatusButton.svelte";
	import FeedItem from "$lib/components/posts/FeedItem.svelte";
	import { Spinner } from "$lib/components/ui/spinner/index.js";
	import { onMount } from "svelte";
	import bblogo from "$lib/assets/android-launchericon-72-72.png";

	interface Props {
		data: {
			user: User;
			friend_status: { status: FriendStatus };
			feed: {
				feed_items: Feedable[];
				pagy: any;
			};
		};
	}

	let { data }: Props = $props();
	let user = data.user;
	const tags = user.tags;

	let feed_items = $state(data.feed.feed_items);
	let fetching_more_posts = $state(false);
	const pagination = data.feed.pagy;
	let next_page = $state(pagination.next);

	onMount(async () => {
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

		// Reload the page when you scroll to the top
		window.addEventListener("scroll", function () {
			if (window.scrollY == 0) {
				console.log("you're at the top of the page");
				window.location.reload();
			}
		});
	});
</script>

{console.log("data", data)}

<div>
	<div class="flex space-x-2 mb-4 items-baseline">
		<div class="flex flex-row">
			<div class="rounded-full w-12 h-12 overflow-hidden mr-2">
				{#if user.presigned_url}
					<img src={user.presigned_url} alt="profile picture" />
				{:else}
					<img src={bblogo} />
				{/if}
			</div>
			<H1>{user.name}</H1>
		</div>
		{#if tags}
			<div class="space-x-2 mb-4">
				{#each tags as tag}
					<Badge>{tag}</Badge>
				{/each}
			</div>
		{/if}
	</div>
	<div>
		<FriendStatusButton user={data.user} friend_status_prop={data.friend_status.status} />
	</div>
	<div>{user.blurb}</div>

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
