<script lang="ts">
	import H1 from "$lib/components/text/H1.svelte";
	import H2 from "$lib/components/text/H2.svelte";
	import { Badge } from "$lib/components/ui/badge";
	import { friends_map } from "$lib/state/friends_map.svelte";

	let { data } = $props();
	let user = data.user;
	const tags = user.tags;
	const is_friends = friends_map.friends_map[user.id];
</script>

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
			<div>friends</div>
		{:else}
			<div>not friends</div>
		{/if}
	</div>
	<div>{user.blurb}</div>
</div>
