<script lang="ts">
	import { Badge } from "$lib/components/ui/badge/index.js";
	import type { Rsvp } from "$lib/api_calls/types";

	interface Props {
		rsvp: Rsvp | null;
	}

	let { rsvp }: Props = $props();

	type rsvpVariants = "not_rsvpd" | "going" | "interested" | "not_going" | "not_interested";
	const [badgeText, badgeVariant] = (function (): [string, rsvpVariants] {
		if (!rsvp) return ["Not rsvp'd", "not_rsvpd"];
		switch (rsvp.status) {
			case "going":
				return ["Going", "going"];
			case "interested":
				return ["Interested", "interested"];
			case "cant_go":
				return ["Not going", "not_going"];
			case "not_interested":
				return ["Not interested", "not_interested"];
			default:
				return ["Not rsvp'd", "not_rsvpd"];
		}
	})();
	// const badgeText = rsvp ? rsvp.status : "Not rsvp'd";
	// const badgeVariant = "going";
</script>

<div>
	<Badge variant={badgeVariant}>{badgeText}</Badge>
</div>
