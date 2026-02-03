<script lang="ts">
	import EventsForm from "../../EventsForm.svelte";
	import type { PageData } from "./$types.js";
	import H1 from "$lib/components/text/H1.svelte";

	let { data }: { data: PageData } = $props();
</script>

<div>
	<Card.Root>
		<Card.Header>
			<Card.Title>Edit Event</Card.Title>
		</Card.Header>
		<Card.Content>
			<EventsForm {data} />
		</Card.Content>
	</Card.Root>
</div>
