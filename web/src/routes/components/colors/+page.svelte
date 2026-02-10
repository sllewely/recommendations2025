<script lang="ts">
	import type { Rsvp } from "$lib/api_calls/types";
	import RsvpBadge from "$lib/components/ui/badge/RsvpBadge.svelte";

	const going_rsvp: Rsvp = { id: "1", status: "going" };
	const interested_rsvp = { id: "2", status: "interested" };
	const hide_rsvp = { id: "2", status: "hide" };
	const not_going_rsvp = { id: "2", status: "cant_go" };
</script>

<RsvpBadge rsvp={going_rsvp} />
<RsvpBadge rsvp={interested_rsvp} />
<RsvpBadge rsvp={hide_rsvp} />
<RsvpBadge rsvp={not_going_rsvp} />
<RsvpBadge rsvp={null} />
