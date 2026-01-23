<script lang="ts">
	import type { Notification, Pagy } from "$lib/api_calls/types";
	import * as Item from "$lib/components/ui/item/index.js";

	import NotificationItem from "$lib/components/notifications/NotificationItem.svelte";
	import { onMount } from "svelte";
	import { Spinner } from "$lib/components/ui/spinner";

	interface Props {
		data: {
			notifications: Notification[];
			pagy: Pagy;
		};
	}

	let { data }: Props = $props();

	let notifications = $state(data.notifications);
	let next_page = $state(data.pagy.next);
	let fetching_more_notifs = $state(false);

	onMount(() => {
		async function fetch_notifs() {
			// Show loading spinner and make fetch request to api
			const response = await fetch("/api/fetch_notifs?page=" + next_page, {
				method: "GET",
				headers: {
					"Content-Type": "application/json",
				},
			});
			const res = await response.json();
			notifications = notifications.concat(res["res"]["notifications"]);
			next_page = res["res"]["pagy"]["next"];
		}

		// Fetch more posts when you reach the bottom
		window.addEventListener("scroll", function () {
			if (window.innerHeight + window.scrollY >= document.body.offsetHeight) {
				console.log("you're at the bottom of the page");
				if (!fetching_more_notifs && next_page !== null) {
					fetching_more_notifs = true;
					fetch_notifs();
					fetching_more_notifs = false;
				}
			}
		});
	});
</script>

<div>
	<span>this page is a work in progress!! lmk what notif features you want</span>
	<Item.Group>
		{#each data.notifications as notification}
			<NotificationItem {notification} />
		{/each}
	</Item.Group>
	{#if fetching_more_notifs}
		<div class="flex justify-center pt-20">
			<Spinner class="size-24" />
		</div>
	{/if}
	{#if !next_page}
		<div class="flex justify-center pt-20">Reached the end of time :)</div>
	{/if}
</div>
