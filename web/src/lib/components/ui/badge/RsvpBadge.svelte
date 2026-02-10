<script lang="ts">
	import { Badge } from "$lib/components/ui/badge/index.js";
	import type { Rsvp } from "$lib/api_calls/types";

	interface Props {
		rsvp: Rsvp | null | { status: string };
	}

	let { rsvp }: Props = $props();

	type rsvpVariants = "not_rsvpd" | "going" | "interested" | "not_going" | "hide" | "invited";
	const [badgeText, badgeVariant] = (function (): [string, rsvpVariants] {
		if (!rsvp) return ["Not rsvp'd", "not_rsvpd"];
		switch (rsvp.status) {
			case "going":
				return ["Going", "going"];
			case "interested":
				return ["Interested", "interested"];
			case "cant_go":
				return ["Not going", "not_going"];
			case "invited":
				return ["Invited", "invited"];
			case "hide":
				return ["Not interested", "hide"];
			default:
				return ["Not rsvp'd", "not_rsvpd"];
		}
	})();
</script>

<div>
	<div class="hidden">{rsvp?.status}</div>
	<Badge variant={badgeVariant}>{badgeText}</Badge>
</div>
