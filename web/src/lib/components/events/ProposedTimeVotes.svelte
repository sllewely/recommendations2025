<script lang="ts">
	import { Button } from "$lib/components/ui/button";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { parseAbsoluteToLocal } from "@internationalized/date";
	import type { ProposedTime, User } from "$lib/api_calls/types";
	import { onMount } from "svelte";
	import { invalidateAll } from "$app/navigation";
	import { Star } from "lucide-svelte";

	let {
		proposed_times,
		my_user,
		is_host = false,
		chosen_proposed_time_id = null,
	}: {
		proposed_times: ProposedTime[];
		// null when signed out; voting is hidden
		my_user: User | null;
		// the host can choose the winning time
		is_host?: boolean;
		chosen_proposed_time_id?: string | null;
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

	const iVoted = (pt: ProposedTime) => !!my_user && !!pt.users?.some((u) => u.id === my_user.id);

	// filled in right away when the host clicks, before the server confirms
	let pending_chosen_id = $state<string | null>(null);
	let chosen_id = $derived(pending_chosen_id ?? chosen_proposed_time_id);
	// the star that should play its pop animation
	let just_chosen_id = $state<string | null>(null);
	// leave room for the star column so times line up
	let show_stars = $derived(is_host || !!chosen_id);

	const chooseTime = async (pt: ProposedTime) => {
		if (pt.id === chosen_id) return;
		pending_chosen_id = pt.id;
		just_chosen_id = pt.id;
		const response = await fetch("/api/proposed_times/choose", {
			method: "POST",
			body: JSON.stringify({ id: pt.id }),
			headers: { "Content-Type": "application/json" },
		});
		const res = await response.json();
		if (!res.success) {
			pending_chosen_id = null;
			just_chosen_id = null;
			newToast("Error choosing a time: " + res.message, ToastType.Error);
			return;
		}
		newToast("Event time updated!");
		// reload the event so its start time shows the winner
		await invalidateAll();
		pending_chosen_id = null;
	};

	const toggleVote = async (pt: ProposedTime) => {
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
		pt.vote_count = pt.users.length;
	};
</script>

<div class="flex flex-col gap-2">
	<span class="text-xl">Find a time</span>
	<p class="text-xs font-light">
		Vote for the times that work for you.{#if is_host}
			Click a star to choose the winner.{/if}
	</p>
	{#each times as pt (pt.id)}
		{@const chosen = pt.id === chosen_id}
		{@const star_class = `size-12 transition-colors duration-500 ${
			chosen ? "fill-yellow-400 text-yellow-500" : "fill-transparent text-muted-foreground"
		}`}
		<div class="flex flex-row items-center justify-between gap-2">
			<div class="flex flex-row items-center gap-3">
				{#if show_stars}
					<span class="shrink-0" class:star-pop={pt.id === just_chosen_id}>
						{#if is_host}
							<button
								type="button"
								class="block cursor-pointer rounded-full hover:scale-110 transition-transform disabled:cursor-default disabled:hover:scale-100"
								aria-label={chosen ? "chosen time" : "choose this time"}
								aria-pressed={chosen}
								disabled={chosen}
								onclick={() => chooseTime(pt)}
							>
								<Star class={star_class} />
							</button>
						{:else}
							<!-- placeholder keeps the times aligned with the chosen one -->
							<Star class={star_class} style={chosen ? "" : "visibility: hidden"} />
						{/if}
					</span>
				{/if}
				<div class="flex flex-col">
					<span class:font-bold={chosen} class:text-lg={chosen}>
						{formatted[pt.id] ?? ""}
					</span>
					{#if pt.users && pt.users.length > 0}
						<span class="text-xs text-muted-foreground">
							{pt.users.map((u) => u.name).join(", ")}
						</span>
					{/if}
				</div>
			</div>
			<div class="flex flex-row items-center gap-2">
				<span class="text-sm text-muted-foreground">
					{pt.vote_count}
					{pt.vote_count === 1 ? "vote" : "votes"}
				</span>
				{#if my_user}
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
