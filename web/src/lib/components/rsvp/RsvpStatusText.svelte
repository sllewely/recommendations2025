<script lang="ts" module>
	import type { RsvpStatus } from "$lib/api_calls/types";

	export const RSVP_LABELS: Record<RsvpStatus, string> = {
		going: "going",
		interested: "interested",
		cant_go: "can't go",
		hide: "not interested",
		invited: "invited",
	};
</script>

<script lang="ts">
	// The right side of a row in an event's rsvp list (a UserList trailing component): that
	// person's rsvp as plain text.
	import type { User } from "$lib/api_calls/types";

	interface Props {
		user: User;
		statuses: Record<string, RsvpStatus>;
	}

	let { user, statuses }: Props = $props();

	let status = $derived(statuses[user.id]);
</script>

{#if status}
	<span
		class={status === "going"
			? "shrink-0 text-sm text-zinc-700 dark:text-zinc-200"
			: status === "interested"
				? "shrink-0 text-sm text-zinc-700 dark:text-zinc-300"
				: "shrink-0 text-sm text-zinc-500 dark:text-zinc-400"}
	>
		{RSVP_LABELS[status]}
	</span>
{/if}
