<script lang="ts">
	import EventsForm from "../../EventsForm.svelte";
	import * as Card from "$lib/components/ui/card/index.js";
	import type { PageData } from "./$types.js";

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
