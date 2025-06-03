<script lang="ts">
	import H1 from "$lib/components/text/H1.svelte";
	import H2 from "$lib/components/text/H2.svelte";
	import { Badge } from "$lib/components/ui/badge";
	import { friends_map } from "$lib/state/friends_map.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import { Button } from "$lib/components/ui/button";
	import { enhance } from "$app/forms";

	let { data } = $props();
	let user = data.user;
	const tags = user.tags;
	const is_friends = user.id in friends_map.friends_map;
	const friend_request = data.pending_friend_request["friend_request"];
	let updating = $state(false);
</script>

{console.log(is_friends)}

<div>
	<div class="flex space-x-2 mb-4 items-baseline">
		<H1>{user.name}</H1>
		{#if tags}
			<div class="space-x-2 mb-4">
				{#each tags as tag}
					<Badge>{tag}</Badge>
				{/each}
			</div>
		{/if}
	</div>
	<div>
		{#if is_friends}
			<div>
				<Badge variant="secondary">friends</Badge>
			</div>
		{:else}
			<div>
				<form
					method="POST"
					action="?/add_friend"
					use:enhance={() => {
						updating = true;
						return async ({ update, result }) => {
							await update();
							updating = false;
							let res = result.data;
							if (res.success) {
								newToast("Sent a new friend request");
							} else {
								newToast("Error sending friend request: " + res.message, ToastType.Error);
							}
						};
					}}
				>
					<input type="hidden" name="user_id" value={user.id} />
					{#if friend_request !== null}
						<Button type="button" disabled>Friend request pending</Button>
					{:else}
						<Button type="submit">Add friend</Button>
					{/if}
				</form>
			</div>
		{/if}
	</div>
	<div>{user.blurb}</div>
</div>
