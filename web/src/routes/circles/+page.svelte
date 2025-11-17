<script lang="ts">
	import type { PageData } from "./$types.js";
	import H1 from "$lib/components/text/H1.svelte";
	import H2 from "$lib/components/text/H2.svelte";
	import CircleForm from "./CircleForm.svelte";

	let { data }: { data: PageData } = $props();
</script>

<div>
	<H1>Circles!</H1>

	<div class="flex">
		<CircleForm {data} />
	</div>

	<div class="pt-4">
		<H2>Your Circles</H2>
		<div>// TODO: Show circles here</div>
	</div>
</div>
