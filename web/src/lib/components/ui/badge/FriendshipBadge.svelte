<script lang="ts">
	import { Badge, type Variant } from "$lib/components/ui/badge/index.js";
	import type { FriendshipStatus } from "$lib/api_calls/types";

	interface Props {
		status?: FriendshipStatus | string | null;
		class?: string;
	}

	let { status, class: className = "" }: Props = $props();

	type BadgeInfo = {
		text: string;
		variant: Variant;
	};

	const badgeInfo = $derived.by((): BadgeInfo | null => {
		if (!status) return null;
		switch (status) {
			case "friends":
				return { text: "Friends", variant: "going" };
			case "self":
				return { text: "You", variant: "secondary" };
			case "pending_friend_request":
				return { text: "Pending Request", variant: "interested" };
			case "sent_friend_request":
				return { text: "Request Sent", variant: "invited" };
			case "none":
				return { text: "Not Friends", variant: "outline" };
			default:
				return { text: String(status), variant: "outline" };
		}
	});
</script>

{#if badgeInfo}
	<Badge variant={badgeInfo.variant} class={className}>{badgeInfo.text}</Badge>
{/if}
