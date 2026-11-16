<script lang="ts">
	import { Button } from "$lib/components/ui/button";
	import { Calendar } from "$lib/components/ui/calendar";
	import * as Popover from "$lib/components/ui/popover";
	import { CalendarIcon, X } from "lucide-svelte";
	import {
		type DateValue,
		DateFormatter,
		getLocalTimeZone,
		parseAbsoluteToLocal,
		today,
	} from "@internationalized/date";
	import type { ProposedTime } from "$lib/api_calls/types";

	let {
		proposed_times = $bindable([]),
		existing = [],
		onUse,
	}: {
		// ISO start datetimes the creator is proposing
		proposed_times: string[];
		// already saved proposed times, used to show votes
		existing?: ProposedTime[];
		// set the event's start time to this proposed time
		onUse: (start_date_time: string) => void;
	} = $props();

	const df = new DateFormatter("en-US", {
		weekday: "short",
		month: "short",
		day: "numeric",
		hour: "numeric",
		minute: "2-digit",
	});
	const date_df = new DateFormatter("en-US", { dateStyle: "long" });

	let new_date = $state<DateValue>(today(getLocalTimeZone()).add({ days: 1 }));
	let new_time = $state("17:00");

	const sameTime = (a: string, b: string) => new Date(a).getTime() === new Date(b).getTime();

	let sorted_times = $derived(
		[...proposed_times].sort((a, b) => new Date(a).getTime() - new Date(b).getTime()),
	);

	const votesFor = (start_date_time: string) =>
		existing.find((pt) => sameTime(pt.start_date_time, start_date_time));

	const addTime = () => {
		if (!new_date || !new_time) return;
		// interpreted in the browser's local time zone
		const iso = new Date(`${new_date.toString()}T${new_time}`).toISOString();
		if (proposed_times.some((t) => sameTime(t, iso))) return;
		proposed_times = [...proposed_times, iso];
	};

	const removeTime = (start_date_time: string) => {
		proposed_times = proposed_times.filter((t) => !sameTime(t, start_date_time));
	};
</script>

<div class="rounded-md border border-input p-4 flex flex-col gap-4">
	<div>
		<p class="font-semibold">Find a time</p>
		<p class="text-xs font-light">
			Propose some start times and let people vote on the ones that work for them.
		</p>
	</div>

	<div class="flex flex-row flex-wrap items-end gap-4">
		<Popover.Root>
			<Popover.Trigger>
				<Button variant="outline" type="button">
					<CalendarIcon class="mr-2 size-4" />
					{new_date ? date_df.format(new_date.toDate(getLocalTimeZone())) : "Select a date"}
				</Button>
			</Popover.Trigger>
			<Popover.Content class="w-auto p-0">
				<Calendar bind:value={new_date} type="single" initialFocus />
			</Popover.Content>
		</Popover.Root>
		<input type="time" aria-label="proposed start time" bind:value={new_time} />
		<Button type="button" variant="outline" onclick={addTime}>Add time</Button>
	</div>

	{#if sorted_times.length > 0}
		<ul class="flex flex-col gap-2">
			{#each sorted_times as start_date_time (start_date_time)}
				{@const votes = votesFor(start_date_time)}
				<li class="flex flex-row items-center justify-between gap-2">
					<span>{df.format(parseAbsoluteToLocal(start_date_time).toDate())}</span>
					<div class="flex flex-row items-center gap-2">
						{#if votes}
							<span class="text-sm text-muted-foreground">
								{votes.vote_count}
								{votes.vote_count === 1 ? "vote" : "votes"}
							</span>
						{/if}
						<Button type="button" variant="ghost" size="sm" onclick={() => onUse(start_date_time)}>
							Use this time
						</Button>
						<Button
							type="button"
							variant="ghost"
							size="sm"
							aria-label="remove proposed time"
							onclick={() => removeTime(start_date_time)}
						>
							<X class="size-4" />
						</Button>
					</div>
				</li>
			{/each}
		</ul>
	{:else}
		<p class="text-sm text-muted-foreground italic">No times proposed yet</p>
	{/if}
</div>
