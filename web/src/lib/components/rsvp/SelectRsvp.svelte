<script lang="ts">
	import RsvpBadge from "$lib/components/ui/badge/RsvpBadge.svelte";
	import {
		type Rsvp,
		RSVP_STATUSES,
		type RsvpStatus,
		rsvpStatusToText,
		type RsvpVariant,
	} from "$lib/api_calls/types";
	import { Button } from "$lib/components/ui/button";
	import RsvpButton from "$lib/components/rsvp/RsvpButton.svelte";

	interface Props {
		rsvp: Rsvp | null | { status: RsvpStatus };
	}

	let { rsvp }: Props = $props();

	let current_user_rsvp = $derived(rsvp ? rsvp : { status: "not_rsvpd" });
	let open_choices = $state(false);

	// On click, pop up choices for rsvp
</script>

{console.log("rsvp", rsvp)}
<div>
	<div class={"flex flex-row gap-2 absolute" + (open_choices ? "" : " hidden")}>
		{#each RSVP_STATUSES as status}
			<Button variant="outline" class="rounded-full">
				{rsvpStatusToText(status).text}
			</Button>
			<!--			<RsvpBadge rsvp={{ status: status }} selected={current_user_rsvp?.status === status}/>-->
		{/each}
	</div>

	<RsvpButton rsvp={current_user_rsvp} click_handler={() => (open_choices = !open_choices)} />
</div>
