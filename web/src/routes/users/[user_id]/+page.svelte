<script lang="ts">
	import H1 from "$lib/components/text/H1.svelte";
	import H2 from "$lib/components/text/H2.svelte";
	import { current_user } from "$lib/state/current_user.svelte.js";
	import { Badge } from "$lib/components/ui/badge";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { Button } from "$lib/components/ui/button";
	import { enhance } from "$app/forms";
	import type { User, FriendStatus } from "$lib/api_calls/types";
	import FriendStatusButton from "$lib/components/users/FriendStatusButton.svelte";

	interface Props {
		data: {
			user: User;
			friend_status: { status: FriendStatus };
		};
	}

	let { data }: Props = $props();
	let user = data.user;
	const tags = user.tags;
</script>

{console.log("data", data)}

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
		<FriendStatusButton user={data.user} friend_status_prop={data.friend_status.status} />
	</div>
	<div>{user.blurb}</div>
</div>
