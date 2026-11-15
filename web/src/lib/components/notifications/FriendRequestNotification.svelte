<script lang="ts">
	import { enhance } from "$app/forms";
	import { onMount } from "svelte";
	import { HeartHandshake } from "@lucide/svelte";
	import type { Notification, NotificationFriendRequest } from "$lib/api_calls/types";
	import FeedBadge, { ACCENTS } from "$lib/components/posts/FeedBadge.svelte";
	import Button from "$lib/components/Button.svelte";
	import Comment from "$lib/components/posts/Comment.svelte";
	import UserCard from "$lib/components/users/UserCard.svelte";
	import { Spinner } from "$lib/components/ui/spinner";
	import { cn } from "$lib/utils.js";
	import { formatWhen } from "$lib/format_date";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import { fetch_friends_map } from "$lib/state/friends_map.svelte";
	import { refresh_unread } from "$lib/state/unread_notifications.svelte";

	interface Props {
		notification: Notification & { friend_request: NotificationFriendRequest };
	}

	let { notification }: Props = $props();

	let request = $derived(notification.friend_request);
	let friend = $derived(request.user);
	let message = $derived(request.message?.trim());

	let cleared = $state(false);
	let active = $derived(notification.active && !cleared);
	let answered = $state<"accepted" | "ignored" | null>(null);
	let status = $derived(answered ?? request.status);
	let updating = $state<"accept" | "ignore" | null>(null);

	let when = $state("");
	onMount(() => {
		when = formatWhen(notification.created_at);
	});

	const clear_notif = () => {
		if (!active) return;
		cleared = true;
		fetch("/api/clear_notification", {
			method: "POST",
			body: JSON.stringify({ id: notification.id }),
			headers: { "Content-Type": "application/json" },
		}).then(refresh_unread);
	};
</script>

<div
	class={cn(
		"flex w-full flex-row items-start gap-3 p-4",
		"border border-dashed border-transparent",
		active
			? cn("border-l-2 [border-left-style:solid]", ACCENTS.yellow.bar, ACCENTS.yellow.border)
			: cn("pl-[calc(--spacing(4)+1px)]", ACCENTS.zinc.border),
	)}
>
	<FeedBadge icon={HeartHandshake} accent="yellow" />
	<div class="flex min-w-0 flex-1 flex-row flex-wrap items-start justify-between gap-3">
		<div class="flex min-w-0 flex-col gap-1">
			<a
				href="/users/{friend.id}"
				onclick={clear_notif}
				class="leading-tight text-zinc-900 hover:underline dark:text-zinc-100"
			>
				You have a new friend request
			</a>
			<span class="text-sm leading-none text-zinc-500 dark:text-zinc-400">{when}</span>
			{#if message}
				<Comment user={friend} body={message} caption="wants to be friends!" class="pt-2" />
			{:else}
				<div class="flex flex-row flex-wrap items-center gap-1.5 pt-2 text-sm">
					<UserCard user={friend} size="xs" />
					<span class="text-zinc-500 dark:text-zinc-400">wants to be friends!</span>
				</div>
			{/if}
		</div>

		{#if status === "pending"}
			<form
				class="flex shrink-0 flex-row gap-2"
				method="POST"
				action="?/accept_friend_request"
				use:enhance={({ action }) => {
					const ignoring = action.search.includes("ignore");
					updating = ignoring ? "ignore" : "accept";
					return async ({ result }) => {
						updating = null;
						const res = result.type === "success" ? result.data : undefined;
						if (res?.success) {
							answered = ignoring ? "ignored" : "accepted";
							cleared = true;
							newToast(ignoring ? "Ignored friend request" : "Accepted friend request");
							if (!ignoring) await fetch_friends_map();
							refresh_unread();
						} else {
							newToast(
								`Error ${ignoring ? "ignoring" : "accepting"} friend request: ` + res?.message,
								ToastType.Error,
							);
						}
					};
				}}
			>
				<input type="hidden" name="user_id" value={friend.id} />
				<input type="hidden" name="id" value={request.id} />
				<Button type="submit" disabled={!!updating}>
					{#if updating === "accept"}
						<Spinner />
					{/if}
					accept
				</Button>
				<Button
					type="submit"
					color="zinc"
					formaction="?/ignore_friend_request"
					disabled={!!updating}
				>
					{#if updating === "ignore"}
						<Spinner />
					{/if}
					ignore
				</Button>
			</form>
		{:else if status}
			<span class="shrink-0 text-sm text-zinc-500 dark:text-zinc-400">{status}</span>
		{/if}
	</div>
</div>
