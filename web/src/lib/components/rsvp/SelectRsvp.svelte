<script lang="ts">
	import RsvpBadge from "$lib/components/ui/badge/RsvpBadge.svelte";
	import type { Rsvp } from "$lib/api_calls/types";

	interface Props {
		rsvp: Rsvp | null | { status: string };
	}

	let { rsvp }: Props = $props();

	let current_user_rsvp = $derived(rsvp ? rsvp : { status: "not_rsvpd" });

	// On click, pop up choices for rsvp

	const rsvp_statuses = ["going", "interested", "cant_go", "hide", "not_rsvpd"];
</script>

{console.log("rsvp", rsvp)}
<div>
	<div class="flex flex-row gap-2 absolute">
		{#each rsvp_statuses as status}
			<RsvpBadge rsvp={{ status: status }} selected={current_user_rsvp?.status === status} />
		{/each}
	</div>

	<RsvpBadge rsvp={current_user_rsvp} />
</div>
