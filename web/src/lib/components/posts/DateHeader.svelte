<script lang="ts">
	import H2 from "$lib/components/text/H2.svelte";
	import * as Card from "$lib/components/ui/card/index.js";

	interface Props {
		event_item: {
			date_header: string;
		};
	}

	let { event_item }: Props = $props();
</script>

<div class="p-2">
	<Card.Root>
		<Card.Content class="text-xl font-bold flex justify-center">
			{event_item.date_header}
		</Card.Content>
	</Card.Root>
</div>
