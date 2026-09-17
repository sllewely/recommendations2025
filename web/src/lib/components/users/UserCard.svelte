<script lang="ts">
	import type { User } from "$lib/api_calls/types";
	import bblogo from "$lib/assets/android-launchericon-72-72.png";
	import FriendshipBadge from "$lib/components/ui/badge/FriendshipBadge.svelte";

	interface Props {
		user: User;
		show_friendship_status?: boolean;
	}

	let { user, show_friendship_status = true }: Props = $props();
</script>

<div class="flex flex-row items-center">
	<div class="rounded-full w-12 h-12 overflow-hidden mr-2 shrink-0">
		{#if user.profile_photo_url}
			<img src={"https://" + user.profile_photo_url} alt="profile picture" />
		{:else}
			<img src={bblogo} alt="profile picture" />
		{/if}
	</div>
	<div class="flex flex-row items-center gap-2">
		<a class="text-teal-400 hover:text-orange-400 font-bold" href={`/users/${user.id}`}
			>{user.name}</a
		>
		{#if show_friendship_status && user.friendship_status}
			<FriendshipBadge status={user.friendship_status} />
		{/if}
	</div>
</div>
