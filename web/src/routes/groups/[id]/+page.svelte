<script lang="ts">
	import type { Group, Feedable } from "$lib/api_calls/types";
	import UserCard from "$lib/components/users/UserCard.svelte";
	import * as Collapsible from "$lib/components/ui/collapsible";
	import Link from "$lib/components/text/Link.svelte";
	import { Button } from "$lib/components/ui/button";
	import { Spinner } from "$lib/components/ui/spinner";
	import { enhance } from "$app/forms";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import { current_user, isSignedIn } from "$lib/state/current_user.svelte";
	import FeedItem from "$lib/components/posts/FeedItem.svelte";

	interface Props {
		data: {
			group: Group;
			feed_items: Feedable[];
		};
	}

	// TODO: pagination

	let { data }: Props = $props();

	let joining = $state(false);
	let is_member = $derived(data.group.users.some((user) => user.id === current_user.id));
</script>

<div>
	<div class="flex flex-row justify-between items-center">
		<h1 class="text-2xl font-bold">{data.group.name}</h1>

		{#if is_member}
			<Button>Member</Button>
		{:else}
			<form
				method="POST"
				action="?/join"
				use:enhance={() => {
					joining = true;
					return async ({ update, result }) => {
						await update();
						joining = false;
						console.log("response", result.data);
						if (result.data.success) {
							newToast("Joined group!", ToastType.Success);
						} else {
							newToast("Error joining group: " + result.data.message, ToastType.Error);
						}
					};
				}}
			>
				<input type="hidden" name="group_id" value={data.group.id} />
				<Button type="submit" disabled={joining}>
					{#if joining}
						<Spinner />
					{/if}
					Join
				</Button>
			</form>
		{/if}
	</div>

	<Collapsible.Root>
		<Collapsible.Trigger>
			<Link>
				<h2 class="text-xl font-bold">{data.group.users.length} Members...</h2>
			</Link>
		</Collapsible.Trigger>
		<Collapsible.Content>
			<div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
				{#each data.group.users as user}
					<UserCard {user} />
				{/each}
			</div>
		</Collapsible.Content>
	</Collapsible.Root>

	<h2>Posts</h2>

	<div>
		{#each data.feed_items as feed_item}
			<FeedItem feed_item={feed_item.feedable} />
		{/each}
	</div>
</div>
