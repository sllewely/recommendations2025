<script lang="ts">
	// Who's coming to an event, as a UserList. You come first, as "you", with a dashed chip on
	// the right showing your rsvp ("rsvp?" if you haven't). Clicking it opens a popover of the
	// choices over the chip; picking one updates your rsvp in place. Everyone else follows, going
	// first, with their rsvp as text on the right.
	//   <RsvpList event_id={event.id} bind:rsvps />
	import { page } from "$app/state";
	import type { Rsvp, RsvpStatus, User } from "$lib/api_calls/types";
	import UserList from "$lib/components/users/UserList.svelte";
	import UserCard from "$lib/components/users/UserCard.svelte";
	import RsvpStatusText from "$lib/components/rsvp/RsvpStatusText.svelte";
	import RsvpPicker from "$lib/components/rsvp/RsvpPicker.svelte";
	import Link from "$lib/components/text/Link.svelte";
	import { current_user, isSignedIn } from "$lib/state/current_user.svelte";

	interface Props {
		event_id: string;
		rsvps: Rsvp[];
	}

	let { event_id, rsvps = $bindable([]) }: Props = $props();

	let signed_in = $derived(isSignedIn());

	let mine = $derived(rsvps.find((r) => r.user?.id === current_user.id));
	// you, from your own rsvp if there is one, otherwise from the layout's signed-in user
	let me = $derived<User>(
		mine?.user ??
			({
				id: current_user.id,
				name: page.data.current_name ?? "you",
				profile_photo_url: page.data.current_photo ?? undefined,
			} as User),
	);

	// everyone else, going first
	const ORDER: RsvpStatus[] = ["going", "interested", "invited", "cant_go", "hide"];
	let others = $derived(
		rsvps
			.filter((r) => r.user?.id !== current_user.id)
			.toSorted((a, b) => ORDER.indexOf(a.status) - ORDER.indexOf(b.status)),
	);
	let statuses = $derived(Object.fromEntries(others.map((r) => [r.user.id, r.status])));

	const subtle = "text-zinc-600 dark:text-zinc-300";
	const you_subtle = "text-zinc-500 dark:text-zinc-400";
</script>

{#if signed_in}
	<UserList
		users={others.map((r) => r.user)}
		trailing={RsvpStatusText}
		trailing_props={{ statuses }}
		name_class={(user) => (statuses[user.id] === "cant_go" ? subtle : undefined)}
	>
		{#snippet leading()}
			<!-- your row just says "you" -->
			<UserCard
				user={me}
				label="you"
				dashed={!mine}
				static
				name_class={!mine
					? you_subtle
					: mine.status === "cant_go"
						? subtle
						: "text-zinc-900 dark:text-yellow-50"}
			/>
			<RsvpPicker {event_id} bind:rsvps />
		{/snippet}
	</UserList>
{:else}
	<span class="text-sm">
		<Link url="/sign_in">sign in</Link> to rsvp and see who's coming
	</span>
{/if}
