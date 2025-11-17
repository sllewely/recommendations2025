<script lang="ts">
	import type { PageData } from "./$types.js";
	import H1 from "$lib/components/text/H1.svelte";
	import H2 from "$lib/components/text/H2.svelte";
	import CircleForm from "./CircleForm.svelte";

	let { data }: { data: PageData } = $props();

	let circles = $state(data.circles_response["res"] ?? []);
	$effect(() => {
		circles = data.circles_response["res"] ?? [];
	});
</script>

<div>
	<H1>Circles!</H1>

	<div class="flex">
		<CircleForm {data} />
	</div>

	<div class="pt-4">
		<H2>Your Circles</H2>
		{#if circles.length === 0}
			<p>You have no circles yet! Create a new one above :)</p>
		{/if}
		<div>
			{#each circles as circle}
				<p>{circle.name}</p>
			{/each}
		</div>
	</div>
</div>
