<script lang="ts">
	import type { Rsvp } from "$lib/api_calls/types";
	import RsvpBadge from "$lib/components/ui/badge/RsvpBadge.svelte";
	import FriendshipBadge from "$lib/components/ui/badge/FriendshipBadge.svelte";

	const going_rsvp: Rsvp = { id: "1", status: "going" };
	const interested_rsvp = { id: "2", status: "interested" };
	const hide_rsvp = { id: "2", status: "hide" };
	const not_going_rsvp = { id: "2", status: "cant_go" };
</script>

<div class="flex flex-col gap-4 p-4">
	<div class="flex flex-wrap gap-2">
		<RsvpBadge rsvp={going_rsvp} />
		<RsvpBadge rsvp={interested_rsvp} />
		<RsvpBadge rsvp={hide_rsvp} />
		<RsvpBadge rsvp={not_going_rsvp} />
		<RsvpBadge rsvp={null} />
	</div>

	<div class="flex flex-wrap gap-2">
		<FriendshipBadge status="friends" />
		<FriendshipBadge status="self" />
		<FriendshipBadge status="pending_friend_request" />
		<FriendshipBadge status="sent_friend_request" />
		<FriendshipBadge status="none" />
	</div>
</div>
