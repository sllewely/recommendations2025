<script lang="ts">
	import type { PageData } from "./$types.js";
	import EventsForm from "../EventsForm.svelte";

	let { data }: { data: PageData } = $props();

	// TODO:
	// Privacy
</script>

<div>
	<EventsForm {data} />
</div>
