<script lang="ts">
	import type { Group } from "$lib/api_calls/types";
	import UserCard from "$lib/components/users/UserCard.svelte";

	interface Props {
		data: {
			group: Group;
		};
	}

	let { data }: Props = $props();
</script>

<div>
	<h1>{data.group.name}</h1>

	<h2>Members</h2>
	<div>
		{#each data.group.users as user}
			<UserCard {user} />
		{/each}
	</div>

	<h2>Posts</h2>
</div>
