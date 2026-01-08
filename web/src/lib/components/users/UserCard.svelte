<script lang="ts">
	import type { User } from "$lib/api_calls/types";
	import { onMount } from "svelte";

	interface Props {
		user: User;
	}

	let { user }: Props = $props();
</script>

<div class="flex flex-row">
	<img src={user.profile_picture_presigned_get_url} alt="profile picture" />
	<a class="text-teal-400 hover:text-orange-400" href={`/users/${user.id}`}>{user.name}</a>
</div>
