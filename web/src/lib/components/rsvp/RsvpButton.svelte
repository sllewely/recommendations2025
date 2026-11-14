<script lang="ts">
	import { type RsvpDecorataions, type RsvpStatus, rsvpStatusToText } from "$lib/api_calls/types";
	import { Button } from "$lib/components/ui/button";

	interface Props {
		rsvp_status: RsvpStatus | null;
		selected?: boolean;
		click_handler: () => void;
	}

	let { rsvp_status, click_handler, selected }: Props = $props();

	let rsvp_decoration = $derived(rsvpStatusToText(rsvp_status));
</script>

<Button
	variant={rsvp_decoration.variant}
	class={selected ? " border-2 border-black" : ""}
	size="sm"
	onclick={click_handler}
>
	<span class="text-xs">{rsvp_decoration.text}</span>
</Button>
