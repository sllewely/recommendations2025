<script lang="ts" module>
	import type { FriendStatus, User } from "$lib/api_calls/types";

	// Accepting a friend request (no dialog needed). Used by FriendRequest and anywhere else.
	export async function acceptFriendRequest(user: User): Promise<boolean> {
		const response = await fetch("/api/friends/accept_friend_request", {
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify({ user_id: user.id }),
		});
		const json = await response.json().catch(() => ({}));
		return response.ok && !json?.["errors"];
	}
</script>

<script lang="ts">
	// The one way to add a friend: the "how do you know each other" message dialog, then the
	// request. Bind `open` to show it; `onsent` runs once the request went through.
	//   <FriendRequest {user} bind:open onsent={() => (status = "sent_friend_request")} />
	import Dialog from "$lib/components/Dialog.svelte";
	import Button from "$lib/components/Button.svelte";
	import { Spinner } from "$lib/components/ui/spinner";
	import TextField from "$lib/components/TextField.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte";

	interface Props {
		user: User;
		open?: boolean;
		onsent?: (status: FriendStatus) => void;
	}

	let { user, open = $bindable(false), onsent }: Props = $props();

	let message = $state("");
	let sending = $state(false);

	const send = async () => {
		sending = true;
		try {
			const response = await fetch("/api/friends/send_friend_request", {
				method: "POST",
				headers: { "Content-Type": "application/json" },
				body: JSON.stringify({ user_id: user.id, message }),
			});
			const json = await response.json().catch(() => ({}));
			if (!response.ok || json?.["errors"]) {
				newToast("Couldn't send the friend request", ToastType.Error);
				return;
			}
			open = false;
			message = "";
			onsent?.("sent_friend_request");
		} finally {
			sending = false;
		}
	};
</script>

<Dialog
	bind:open
	title="send {user.name} a friend request"
	description="let them know how you know each other"
>
	<TextField multiline placeholder="we met at..." bind:value={message} />
	{#snippet actions()}
		<Button onclick={send} disabled={sending}>
			{#if sending}
				<Spinner />
			{/if}
			send request
		</Button>
	{/snippet}
</Dialog>
