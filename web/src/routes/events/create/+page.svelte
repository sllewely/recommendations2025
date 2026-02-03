<script lang="ts">
	import type { PageData } from "./$types.js";
	import EventsForm from "../EventsForm.svelte";
	import * as Card from "$lib/components/ui/card/index.js";

	let { data }: { data: PageData } = $props();

	// TODO:
	// Privacy
</script>

<div>
	<Card.Root>
		<Card.Header>
			<Card.Title>Create Event</Card.Title>
		</Card.Header>
		<Card.Content>
			<EventsForm {data} />
		</Card.Content>
	</Card.Root>
</div>
