<script lang="ts">
	// Who's coming to an event, as a UserList. You come first, as "you", with a dashed chip on
	// the right showing your rsvp ("rsvp?" if you haven't). Clicking it opens a popover of the
	// choices over the chip; picking one updates your rsvp in place. Everyone else follows, going
	// first, with their rsvp as text on the right.
	//   <RsvpList event_id={event.id} bind:rsvps />
	import { page } from "$app/state";
	import { type Rsvp, type RsvpStatus, type User, RSVP_STATUSES } from "$lib/api_calls/types";
	import UserList from "$lib/components/users/UserList.svelte";
	import UserCard from "$lib/components/users/UserCard.svelte";
	import RsvpStatusText, { RSVP_LABELS } from "$lib/components/rsvp/RsvpStatusText.svelte";
	import Link from "$lib/components/text/Link.svelte";
	import { current_user, isSignedIn } from "$lib/state/current_user.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import { cn } from "$lib/utils.js";
	import { Popover } from "bits-ui";

	interface Props {
		event_id: string;
		rsvps: Rsvp[];
	}

	let { event_id, rsvps = $bindable([]) }: Props = $props();

	let signed_in = $derived(isSignedIn());
	let picking = $state(false);
	let sending = $state(false);

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

	const rsvp = async (status: RsvpStatus) => {
		picking = false;
		if (sending || status === mine?.status) return;
		sending = true;
		const before = rsvps;
		// show it straight away; put it back if the server says no
		rsvps = [
			...before.filter((r) => r.user?.id !== current_user.id),
			{ event_id, status, user: me },
		];
		try {
			const response = await fetch("/api/rsvp/update", {
				method: "POST",
				headers: { "Content-Type": "application/json" },
				body: JSON.stringify({ event_id, status }),
			});
			const json = await response.json().catch(() => null);
			if (!response.ok || !json || json["errors"] || json["error"]) {
				rsvps = before;
				newToast("Couldn't rsvp: " + (json?.["errors"] ?? json?.["error"] ?? ""), ToastType.Error);
			}
		} finally {
			sending = false;
		}
	};

	const subtle = "text-zinc-700 dark:text-zinc-300";
	const you_subtle = "text-zinc-500 dark:text-zinc-400";

	// h-7 (28px): the popover's sideOffset pulls it back over the chip by this much
	const chip =
		"inline-flex h-7 shrink-0 items-center border border-dashed border-zinc-500 text-sm dark:border-zinc-400";
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
				name_class={!mine ? you_subtle : mine.status === "cant_go" ? subtle : "text-yellow-50"}
			/>
			<Popover.Root bind:open={picking}>
				<Popover.Trigger
					class={cn(
						chip,
						"cursor-pointer px-2.5 hover:border-solid",
						mine ? "text-zinc-700 dark:text-zinc-200" : "text-zinc-500 dark:text-zinc-400",
					)}
					aria-label={mine ? `your rsvp: ${RSVP_LABELS[mine.status]}, change it` : "rsvp"}
					disabled={sending}
				>
					{mine ? RSVP_LABELS[mine.status] : "rsvp?"}
				</Popover.Trigger>
				<Popover.Portal>
					<!-- anchored to the chip's bottom-right corner: it opens over the chip and grows up
					     and to the left. a column of choices, dashed lines between; each is pulled up
					     1px so neighbours share one line, and the hovered one goes solid above the rest -->
					<Popover.Content
						side="top"
						align="end"
						sideOffset={-28}
						class="z-50 flex flex-col bg-zinc-100 pt-px outline-hidden dark:bg-zinc-800"
						role="menu"
						aria-label="your rsvp"
					>
						{#each RSVP_STATUSES as status}
							<button
								type="button"
								role="menuitem"
								class={cn(
									chip,
									"relative -mt-px cursor-pointer justify-end px-2.5 hover:z-10 hover:border-solid",
									"text-zinc-700 dark:text-zinc-200",
								)}
								onclick={() => rsvp(status)}
							>
								{RSVP_LABELS[status]}
							</button>
						{/each}
					</Popover.Content>
				</Popover.Portal>
			</Popover.Root>
		{/snippet}
	</UserList>
{:else}
	<span class="text-sm">
		<Link url="/sign_in">sign in</Link> to rsvp and see who's coming
	</span>
{/if}
