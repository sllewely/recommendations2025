<script lang="ts">
	import EventsForm from "../../EventsForm.svelte";
	import type { PageData } from "./$types.js";
	import H1 from "$lib/components/text/H1.svelte";

	let { data }: { data: PageData } = $props();
</script>

<div>
	<H1>Edit Event {data.event.title}</H1>

	<EventsForm {data} />
</div>
