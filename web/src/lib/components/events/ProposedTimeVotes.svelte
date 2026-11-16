<script lang="ts">
	import { Button } from "$lib/components/ui/button";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { parseAbsoluteToLocal } from "@internationalized/date";
	import type { Guest, ProposedTime, User } from "$lib/api_calls/types";
	import GuestRsvpDialog, { type GuestDetails } from "$lib/components/rsvp/GuestRsvpDialog.svelte";
	import { onMount } from "svelte";
	import { invalidateAll } from "$app/navigation";
	import { Star } from "lucide-svelte";

	let {
		proposed_times,
		my_user,
		is_host = false,
		chosen_proposed_time_id = null,
		event_id,
		guest_mode = false,
		guest = null,
	}: {
		proposed_times: ProposedTime[];
		// null when signed out; voting is hidden
		my_user: User | null;
		// the host can choose the winning time
		is_host?: boolean;
		chosen_proposed_time_id?: string | null;
		event_id: string;
		// signed out: vote as a guest
		guest_mode?: boolean;
		// the guest remembered in this browser, if any
		guest?: Guest | null;
	} = $props();

	let times = $state<ProposedTime[]>(proposed_times.map((pt) => ({ ...pt })));

	// format on the client so times show in the viewer's time zone
	let formatted = $state<Record<string, string>>({});
	onMount(() => {
		const fmt = new Intl.DateTimeFormat("en-US", {
			weekday: "short",
			month: "short",
			day: "numeric",
			hour: "numeric",
			minute: "2-digit",
		});
		formatted = Object.fromEntries(
			times.map((pt) => [pt.id, fmt.format(parseAbsoluteToLocal(pt.start_date_time).toDate())]),
		);
	});

	const iVoted = (pt: ProposedTime) => {
		if (my_user) return !!pt.users?.some((u) => u.id === my_user.id);
		if (guest) return pt.guest_ids.includes(guest.id);
		return false;
	};

	const voterNames = (pt: ProposedTime) => [
		...(pt.users ?? []).map((u) => u.name),
		...(pt.guests ?? []).map((g) => g.name),
	];

	// a guest without a name is asked for one before their first vote
	let guest_dialog_open = $state(false);
	let guest_vote_pt = $state<ProposedTime | null>(null);

	const postGuestVote = async (pt: ProposedTime, vote: boolean, details?: GuestDetails) => {
		const response = await fetch("/api/guest/vote", {
			method: "POST",
			body: JSON.stringify({ id: pt.id, vote, name: details?.name, email: details?.email }),
			headers: { "Content-Type": "application/json" },
		});
		const res = await response.json();
		if (!res.success) {
			newToast("Error voting: " + res.message, ToastType.Error);
			return null;
		}
		const guest_id = vote ? res.res.guest.id : guest?.id;
		pt.guest_ids = vote
			? [...pt.guest_ids, guest_id]
			: pt.guest_ids.filter((id) => id !== guest_id);
		pt.vote_count += vote ? 1 : -1;
		return res;
	};

	const submitGuestDetails = async (details: GuestDetails): Promise<boolean> => {
		if (!guest_vote_pt) return false;
		const voted = await postGuestVote(guest_vote_pt, true, details);
		if (!voted) return false;
		if (details.status) {
			await fetch("/api/guest/rsvp", {
				method: "POST",
				headers: { "Content-Type": "application/json" },
				body: JSON.stringify({ event_id, ...details }),
			});
		}
		// picks up the newly remembered guest
		await invalidateAll();
		return true;
	};

	// set right away when the host clicks, before the server confirms; undefined = no click pending
	let pending_chosen_id = $state<string | null | undefined>(undefined);
	let chosen_id = $derived(
		pending_chosen_id === undefined ? chosen_proposed_time_id : pending_chosen_id,
	);
	// the star that should play its pop animation; pops re-keys it so it can replay
	let just_clicked_id = $state<string | null>(null);
	let pops = $state(0);
	// leave room for the star column so times line up
	let show_stars = $derived(is_host || !!chosen_id);

	// clicking the chosen star again unconfirms it
	const toggleChosen = async (pt: ProposedTime) => {
		const choose = pt.id !== chosen_id;
		pending_chosen_id = choose ? pt.id : null;
		just_clicked_id = pt.id;
		pops += 1;
		const response = await fetch("/api/proposed_times/choose", {
			method: "POST",
			body: JSON.stringify({ id: pt.id, choose }),
			headers: { "Content-Type": "application/json" },
		});
		const res = await response.json();
		if (!res.success) {
			pending_chosen_id = undefined;
			just_clicked_id = null;
			newToast("Error choosing a time: " + res.message, ToastType.Error);
			return;
		}
		newToast(choose ? "Event time confirmed!" : "Event time is pending again");
		// reload the event so its start time and status update
		await invalidateAll();
		pending_chosen_id = undefined;
	};

	const toggleVote = async (pt: ProposedTime) => {
		if (guest_mode) {
			if (guest) {
				await postGuestVote(pt, !iVoted(pt));
			} else {
				guest_vote_pt = pt;
				guest_dialog_open = true;
			}
			return;
		}
		if (!my_user) return;
		const vote = !iVoted(pt);
		const response = await fetch("/api/proposed_times/vote", {
			method: "POST",
			body: JSON.stringify({ id: pt.id, vote }),
			headers: { "Content-Type": "application/json" },
		});
		const res = await response.json();
		if (!res.success) {
			newToast("Error voting: " + res.message, ToastType.Error);
			return;
		}
		const users = pt.users ?? [];
		pt.users = vote ? [...users, my_user] : users.filter((u) => u.id !== my_user.id);
		pt.vote_count += vote ? 1 : -1;
	};
</script>

<div class="flex flex-col gap-2">
	<span class="text-xl">Find a time</span>
	<p class="text-xs font-light">
		Vote for the times that work for you.{#if is_host}
			Click a star to choose the winner, or click it again to unconfirm.{/if}
	</p>
	{#each times as pt (pt.id)}
		{@const chosen = pt.id === chosen_id}
		{@const star_class = `size-12 transition-colors duration-500 ${
			chosen ? "fill-yellow-400 text-yellow-500" : "fill-transparent text-muted-foreground"
		}`}
		<div class="flex flex-row items-center justify-between gap-2">
			<div class="flex flex-row items-center gap-3">
				{#if show_stars}
					{#key pt.id === just_clicked_id ? pops : 0}
						<span class="shrink-0" class:star-pop={pt.id === just_clicked_id}>
							{#if is_host}
								<button
									type="button"
									class="block cursor-pointer rounded-full hover:scale-110 transition-transform"
									aria-label={chosen ? "unconfirm this time" : "choose this time"}
									aria-pressed={chosen}
									onclick={() => toggleChosen(pt)}
								>
									<Star class={star_class} />
								</button>
							{:else}
								<!-- placeholder keeps the times aligned with the chosen one -->
								<Star class={star_class} style={chosen ? "" : "visibility: hidden"} />
							{/if}
						</span>
					{/key}
				{/if}
				<div class="flex flex-col">
					<span class:font-bold={chosen} class:text-lg={chosen}>
						{formatted[pt.id] ?? ""}
					</span>
					{#if voterNames(pt).length > 0}
						<span class="text-xs text-muted-foreground">
							{voterNames(pt).join(", ")}
						</span>
					{/if}
				</div>
			</div>
			<div class="flex flex-row items-center gap-2">
				<span class="text-sm text-muted-foreground">
					{pt.vote_count}
					{pt.vote_count === 1 ? "vote" : "votes"}
				</span>
				{#if my_user || guest_mode}
					<Button
						size="sm"
						variant={iVoted(pt) ? "default" : "outline"}
						onclick={() => toggleVote(pt)}
					>
						{iVoted(pt) ? "Works for me ✓" : "Works for me"}
					</Button>
				{/if}
			</div>
		</div>
	{/each}
</div>

{#if guest_mode}
	<GuestRsvpDialog
		bind:open={guest_dialog_open}
		{guest}
		require_status={false}
		title="Vote as a guest"
		description="Tell the host who you are. No account needed."
		submit_label="Vote"
		onSubmit={submitGuestDetails}
	/>
{/if}

<style>
	.star-pop {
		display: inline-block;
		animation: star-pop 600ms ease-out;
	}

	@keyframes star-pop {
		0% {
			transform: scale(1) rotate(0deg);
		}
		40% {
			transform: scale(1.5) rotate(-20deg);
		}
		70% {
			transform: scale(0.9) rotate(10deg);
		}
		100% {
			transform: scale(1) rotate(0deg);
		}
	}

	@media (prefers-reduced-motion: reduce) {
		.star-pop {
			animation: none;
		}
	}
</style>
