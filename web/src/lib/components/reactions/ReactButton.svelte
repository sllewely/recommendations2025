<script lang="ts">
	import { Button } from "$lib/components/ui/button";
	import { reactToEmoji } from "$lib/api_calls/types";

	interface Props {
		react: string;
		selected?: boolean;
		click_handler: () => void;
		class?: string;
	}

	let { react, selected, click_handler, class: className }: Props = $props();
</script>

<Button size="sm" class={className} onclick={click_handler}>
	<span>{reactToEmoji[react] || react}</span>
</Button>
