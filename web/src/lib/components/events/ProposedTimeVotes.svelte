<script lang="ts">
	import { Button } from "$lib/components/ui/button";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { parseAbsoluteToLocal } from "@internationalized/date";
	import type { ProposedTime, User } from "$lib/api_calls/types";
	import { onMount } from "svelte";

	let {
		proposed_times,
		my_user,
	}: {
		proposed_times: ProposedTime[];
		// null when signed out; voting is hidden
		my_user: User | null;
	} = $props();

	let times = $state<ProposedTime[]>(proposed_times.map((pt) => ({ ...pt })));
	let max_votes = $derived(Math.max(0, ...times.map((pt) => pt.vote_count)));

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
	<p class="text-xs font-light">Vote for the times that work for you.</p>
	{#each times as pt (pt.id)}
		<div class="flex flex-row items-center justify-between gap-2">
			<div class="flex flex-col">
				<span class:font-semibold={pt.vote_count > 0 && pt.vote_count === max_votes}>
					{formatted[pt.id] ?? ""}
				</span>
				{#if pt.users && pt.users.length > 0}
					<span class="text-xs text-muted-foreground">
						{pt.users.map((u) => u.name).join(", ")}
					</span>
				{/if}
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
