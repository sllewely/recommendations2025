<script lang="ts">
	import H1 from "$lib/components/text/H1.svelte";

	const { data } = $props();
</script>

<H1>Users</H1>
{#each data.users as user}
	<p>{user.name}</p>
{/each}
