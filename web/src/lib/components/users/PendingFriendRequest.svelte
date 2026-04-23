<script lang="ts">
	import { enhance } from "$app/forms";
	import Link from "$lib/components/text/Link.svelte";
	import PlusCircle from "$lib/components/posts/PlusCircle.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import FormButton from "$lib/components/form/FormButton.svelte";
	import Form from "$lib/components/form/Form.svelte";
	import { goto } from "$app/navigation";
	import { friends_map, fetch_friends_map } from "$lib/state/friends_map.svelte";
	import { parseAbsoluteToLocal } from "@internationalized/date";
	import type { PendingFriendRequest } from "$lib/api_calls/types";
	import UserCard from "$lib/components/users/UserCard.svelte";
	import { Button } from "$lib/components/ui/button";
	import { Spinner } from "$lib/components/ui/spinner";

	interface Props {
		pending_friend_request: PendingFriendRequest;
	}

	let { pending_friend_request }: Props = $props();

	let updating = $state(false);

	const localizedCreateTime = parseAbsoluteToLocal(pending_friend_request.created_at);
	const formattedCreateTime = new Intl.DateTimeFormat("en-US", {
		dateStyle: "medium",
		timeZone: localizedCreateTime.timeZone,
	}).format(localizedCreateTime.toDate());
</script>

<div class="p-4 border-1 border-gray-200 rounded-sm flex flex-row gap-4">
	<div class="flex flex-row justify-between w-100% grow">
		<UserCard user={pending_friend_request.incoming_friend} />
		<div>
			<p>{pending_friend_request.message}</p>
		</div>
		<div class="text-sm">{formattedCreateTime}</div>
	</div>

	<div>
		<form
			method="POST"
			action="?/accept_friend_request"
			use:enhance={() => {
				updating = true;

				return async ({ update, result }) => {
					await update();
					updating = false;
					let res = result.data;
					if (res.success) {
						newToast("Accepted friend request");
						await fetch_friends_map();
					} else {
						newToast("Error accepting friend request: " + res.message, ToastType.Error);
					}
					await goto("/friends");
				};
			}}
		>
			<input type="hidden" name="user_id" value={pending_friend_request["incoming_friend"]["id"]} />
			<Button
				type="submit"
				class="bg-transparent hover:bg-orange-500 text-teal-700 font-semibold hover:text-white py-2 px-4 border border-teal-500 hover:border-transparent rounded"
				disabled={updating}
			>
				{#if updating}
					<Spinner />
				{/if}
				Accept friend request
			</Button>
		</form>
	</div>
</div>
