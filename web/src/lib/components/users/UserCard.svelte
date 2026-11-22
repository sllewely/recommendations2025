<script lang="ts">
	import type { User } from "$lib/api_calls/types";
	import Avatar from "$lib/components/users/Avatar.svelte";
	import FriendshipBadge from "$lib/components/ui/badge/FriendshipBadge.svelte";
	import type { Snippet } from "svelte";

	interface Props {
		user: User;
		show_friendship_status?: boolean;
		subtitle?: string;
		// shown inline after the subtitle
		subtitle_extra?: Snippet;
	}

	let { user, show_friendship_status = true, subtitle, subtitle_extra }: Props = $props();
</script>

<div class="flex flex-row items-center">
	<Avatar {user} class="mr-2" />
	<div class="flex flex-col">
		<div class="flex flex-row items-center gap-2">
			<a class="text-teal-400 hover:text-orange-400 font-bold" href={`/users/${user.id}`}
				>{user.name}</a
			>
			{#if show_friendship_status && user.friendship_status}
				<FriendshipBadge status={user.friendship_status} />
			{/if}
		</div>
		{#if subtitle}
			<span class="flex flex-row items-center gap-1.5 text-sm text-gray-500 dark:text-gray-400">
				{subtitle}
				{@render subtitle_extra?.()}
			</span>
		{/if}
	</div>
</div>
