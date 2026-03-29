<script lang="ts">
	import { type Rsvp, type RsvpDecorataions, rsvpStatusToText } from "$lib/api_calls/types";
	import { Button } from "$lib/components/ui/button";

	interface Props {
		rsvp: Rsvp;
		click_handler: () => void;
	}

	let { rsvp, click_handler }: Props = $props();

	let rsvp_decoration = $derived(rsvpStatusToText(rsvp.status));
</script>

<Button variant="outline" class="rounded-full" onclick={click_handler}>
	{rsvp_decoration.text}
</Button>
