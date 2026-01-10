<script lang="ts">
	import type { User } from "$lib/api_calls/types";
	import bblogo from "$lib/assets/android-launchericon-72-72.png";

	interface Props {
		user: User;
	}

	let { user }: Props = $props();
</script>

<div class="flex flex-row">
	<div class="rounded-full w-12 h-12 overflow-hidden mr-2">
		{#if user.profile_picture_presigned_get_url}
			<img src={user.profile_picture_presigned_get_url} alt="profile picture" />
		{:else}
			<img src={bblogo} />
		{/if}
	</div>
	<a class="text-teal-400 hover:text-orange-400 font-bold" href={`/users/${user.id}`}>{user.name}</a
	>
</div>
