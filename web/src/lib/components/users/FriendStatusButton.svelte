<script lang="ts">
	import { Button } from "$lib/components/ui/button";
	import { Badge } from "$lib/components/ui/badge";
	import type { User, FriendStatus } from "$lib/api_calls/types";

	interface Props {
		user: User;
		friend_status_prop: FriendStatus;
	}

	let { user, friend_status_prop }: Props = $props();

	let friend_status = $state(friend_status_prop);

	const send_friend_request = async () => {
		const response = await fetch("/api/friends/send_friend_request", {
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
			friend_status = "sent_friend_request";
		}
	};
</script>

{console.log("friend_status", friend_status_prop)}

<div>
	{#if friend_status === "self"}
		<Badge variant="secondary">It's you!</Badge>
	{:else if friend_status === "friends"}
		<div>
			<Badge variant="secondary">friends</Badge>
		</div>
	{:else if friend_status === "pending_friend_request"}
		<Button>Accept friend request</Button>
	{:else if friend_status === "sent_friend_request"}
		<Badge variant="secondary">Friend request pending</Badge>
	{:else}
		<Button type="submit" onclick={send_friend_request}>Add friend</Button>
	{/if}
</div>
