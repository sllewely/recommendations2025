<script lang="ts">
	import { Button } from "$lib/components/ui/button";
	import { Badge } from "$lib/components/ui/badge";
	import * as Dialog from "$lib/components/ui/dialog/index.js";
	import { Textarea } from "$lib/components/ui/textarea/index.js";
	import type { User, FriendStatus } from "$lib/api_calls/types";

	interface Props {
		user: User;
		friend_status_prop: FriendStatus;
	}

	let { user, friend_status_prop }: Props = $props();

	let friend_status = $state(friend_status_prop);
	let message = $state("");

	const send_friend_request = async () => {
		const response = await fetch("/api/friends/send_friend_request", {
			method: "POST",
			headers: {
				"Content-Type": "application/json",
			},
			body: JSON.stringify({
				user_id: user.id,
				message: message,
			}),
		});
		const json = await response.json();
		if (json["errors"]) {
		} else {
			friend_status = "sent_friend_request";
		}
	};

	const accept_friend_request = async () => {
		const response = await fetch("/api/friends/accept_friend_request", {
			method: "POST",
			headers: {
				"Content-Type": "application/json",
			},
			body: JSON.stringify({
				user_id: user.id,
			}),
		});
		const json = await response.json();
		if (json["errors"]) {
		} else {
			friend_status = "friends";
		}
	};
</script>

<div>
	{#if friend_status === "self"}
		<Badge variant="secondary">It's you!</Badge>
	{:else if friend_status === "friends"}
		<div>
			<Badge variant="secondary">friends</Badge>
		</div>
	{:else if friend_status === "pending_friend_request"}
		<Button onclick={accept_friend_request}>Accept friend request</Button>
	{:else if friend_status === "sent_friend_request"}
		<Badge variant="secondary">Friend request pending</Badge>
	{:else}
		<Dialog.Root>
			<Dialog.Trigger>
				<Button>Add Friend</Button>
			</Dialog.Trigger>
			<Dialog.Content class="sm:max-w-md">
				<Dialog.Header>
					<Dialog.Title>Send a friend request</Dialog.Title>
					<Dialog.Description>Let them know how you know each other</Dialog.Description>
				</Dialog.Header>
				<div>
					<Textarea placeholder="Type your message here." bind:value={message} />
				</div>
				<Dialog.Footer class="sm:justify-center">
					<Button type="submit" onclick={send_friend_request}>Add friend</Button>
				</Dialog.Footer>
			</Dialog.Content>
		</Dialog.Root>
	{/if}
</div>
