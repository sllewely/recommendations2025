<script lang="ts">
	import type { Notification, Pagy, PendingFriendRequest } from "$lib/api_calls/types";
	import PendingFriendRequestComponent from "$lib/components/users/PendingFriendRequest.svelte";

	import NotificationItem from "$lib/components/notifications/NotificationItem.svelte";
	import { onMount } from "svelte";
	import { Spinner } from "$lib/components/ui/spinner";
	import WebNotificationsToggle from "$lib/components/notifications/push/WebNotificationsToggle.svelte";
	import SubHeader from "$lib/components/SubHeader.svelte";
	import SubHeaderTitle from "$lib/components/SubHeaderTitle.svelte";
	import Button from "$lib/components/Button.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import { refresh_unread } from "$lib/state/unread_notifications.svelte";

	interface Props {
		data: {
			notifications: Notification[];
			pagy: Pagy;
			friend_requests: PendingFriendRequest[];
		};
	}

	let { data }: Props = $props();

	let notifications = $state(data.notifications);
	let next_page = $state(data.pagy.next);
	let fetching_more_notifs = $state(false);

	let any_unread = $derived(notifications.some((n) => n.active));

	let friend_requests = $derived(data.friend_requests);
	type Row =
		| { kind: "notification"; at: number; notification: Notification }
		| { kind: "friend_request"; at: number; friend_request: PendingFriendRequest };
	let rows = $derived.by((): Row[] => {
		const oldest_loaded =
			next_page == null ? -Infinity : Date.parse(notifications.at(-1)?.created_at ?? "");
		return [
			...notifications.map((notification): Row => ({
				kind: "notification",
				at: Date.parse(notification.created_at),
				notification,
			})),
			...friend_requests
				.map((friend_request): Row => ({
					kind: "friend_request",
					at: Date.parse(friend_request.created_at),
					friend_request,
				}))
				.filter((row) => row.at >= oldest_loaded),
		].sort((a, b) => b.at - a.at);
	});
	let reading_all = $state(false);

	const read_all = async () => {
		reading_all = true;
		try {
			const response = await fetch("/api/notifications/read_all", { method: "POST" });
			if (!response.ok) {
				newToast("Couldn't mark notifications read", ToastType.Error);
				return;
			}
			for (const n of notifications) n.active = false;
			await refresh_unread();
		} finally {
			reading_all = false;
		}
	};

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
					fetch_notifs().finally(() => (fetching_more_notifs = false));
				}
			}
		});
	});
</script>

<SubHeader>
	<SubHeaderTitle
		title="notifications"
		caption="i worked hard on web push notifications, so please enable them!!"
	/>
	<div class="flex flex-row flex-wrap items-center gap-3">
		{#if any_unread}
			<Button color="zinc" onclick={read_all} disabled={reading_all}>read all</Button>
		{/if}
		<WebNotificationsToggle />
	</div>
</SubHeader>

<ul class="flex flex-col gap-2.5">
	{#each rows as row (row.kind === "notification" ? `n:${row.notification.id}` : `fr:${row.friend_request.id}`)}
		<li>
			{#if row.kind === "notification"}
				<NotificationItem notification={row.notification} />
			{:else}
				<PendingFriendRequestComponent pending_friend_request={row.friend_request} />
			{/if}
		</li>
	{/each}
	{#if fetching_more_notifs}
		<div class="flex justify-center pt-20">
			<Spinner class="size-24" />
		</div>
	{/if}
	{#if !next_page}
		<div class="flex justify-center pt-10 italic text-zinc-500 dark:text-zinc-400">
			Reached the end of time :)
		</div>
	{/if}
</ul>
