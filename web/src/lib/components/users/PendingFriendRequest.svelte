<script lang="ts">
	import { enhance } from "$app/forms";
	import { onMount } from "svelte";
	import { invalidateAll } from "$app/navigation";
	import { HeartHandshake } from "@lucide/svelte";
	import FeedBadge, { ACCENTS } from "$lib/components/posts/FeedBadge.svelte";
	import { cn } from "$lib/utils.js";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import { fetch_friends_map } from "$lib/state/friends_map.svelte";
	import { refresh_unread } from "$lib/state/unread_notifications.svelte";
	import type { PendingFriendRequest } from "$lib/api_calls/types";
	import { formatWhen } from "$lib/format_date";
	import Button from "$lib/components/Button.svelte";
	import Comment from "$lib/components/posts/Comment.svelte";
	import UserCard from "$lib/components/users/UserCard.svelte";
	import { Spinner } from "$lib/components/ui/spinner";

	interface Props {
		pending_friend_request: PendingFriendRequest;
	}

	let { pending_friend_request }: Props = $props();

	let friend = $derived(pending_friend_request.incoming_friend);
	let message = $derived(pending_friend_request.message?.trim());
	let updating = $state<"accept" | "ignore" | null>(null);

	let when = $state("");
	onMount(() => {
		when = formatWhen(pending_friend_request.created_at);
	});
</script>

<div class={cn("flex w-full flex-row items-start gap-3 border-l-2 p-4", ACCENTS.yellow.bar)}>
	<FeedBadge icon={HeartHandshake} accent="yellow" />
	<div class="flex min-w-0 flex-1 flex-row flex-wrap items-start justify-between gap-3">
		<div class="flex min-w-0 flex-col gap-3">
			<span class="leading-tight text-zinc-900 dark:text-zinc-100">
				You have a new friend request
			</span>
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

		<form
			class="flex shrink-0 flex-row gap-2"
			method="POST"
			action="?/accept_friend_request"
			use:enhance={({ action }) => {
				const ignoring = action.search.includes("ignore");
				updating = ignoring ? "ignore" : "accept";
				return async ({ update, result }) => {
					await update();
					updating = null;
					const res = result.type === "success" ? result.data : undefined;
					if (res?.success) {
						newToast(ignoring ? "Ignored friend request" : "Accepted friend request");
						if (!ignoring) await fetch_friends_map();
						refresh_unread();
					} else {
						newToast(
							`Error ${ignoring ? "ignoring" : "accepting"} friend request: ` + res?.message,
							ToastType.Error,
						);
					}
					await invalidateAll();
				};
			}}
		>
			<input type="hidden" name="user_id" value={friend.id} />
			<input type="hidden" name="id" value={pending_friend_request.id} />
			<Button type="submit" disabled={!!updating}>
				{#if updating === "accept"}
					<Spinner />
				{/if}
				accept
			</Button>
			<Button type="submit" color="zinc" formaction="?/ignore_friend_request" disabled={!!updating}>
				{#if updating === "ignore"}
					<Spinner />
				{/if}
				ignore
			</Button>
		</form>
	</div>
</div>
