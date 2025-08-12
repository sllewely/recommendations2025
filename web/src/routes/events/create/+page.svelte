<script lang="ts">
	import type { PageData } from "../../../../.svelte-kit/types/src/routes";
	import EventsForm from "../EventsForm.svelte";

	let { data }: { data: PageData } = $props();

	// TODO:
	// Privacy
</script>

<div>
	<EventsForm {data} />
</div>
