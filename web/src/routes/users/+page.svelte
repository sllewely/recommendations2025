<script lang="ts">
	import SubHeader from "$lib/components/SubHeader.svelte";
	import SubHeaderTitle from "$lib/components/SubHeaderTitle.svelte";
	const { data } = $props();
</script>

<SubHeader>
	<SubHeaderTitle title="users" />
</SubHeader>

{#each data.users as user}
	<p>{user.name}</p>
{/each}
