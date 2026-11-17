<script lang="ts">
	import { enhance } from "$app/forms";
	import LinkButton from "$lib/components/text/LinkButton.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { goto, invalidate } from "$app/navigation";
	import { MessageCircleMore, Star } from "@lucide/svelte";
	import { Button } from "$lib/components/ui/button";
	import { current_user, isSignedIn } from "$lib/state/current_user.svelte";
	import * as Card from "$lib/components/ui/card/index.js";
	import * as Tooltip from "$lib/components/ui/tooltip/index.js";
	import Link from "$lib/components/text/Link.svelte";
	import MarkedDownPost from "$lib/components/posts/MarkedDownPost.svelte";
	import RsvpBadge from "$lib/components/ui/badge/RsvpBadge.svelte";
	import { parseAbsoluteToLocal } from "@internationalized/date";
	import { onMount } from "svelte";
	import {
		isSchedulingTime,
		type Event,
		type Guest,
		type PlusOne,
		type User,
	} from "$lib/api_calls/types";
	import { Badge } from "$lib/components/ui/badge";
	import { Separator } from "$lib/components/ui/separator";
	import * as Select from "$lib/components/ui/select/index.js";
	import Commentable from "$lib/components/posts/Commentable.svelte";
	import SelectRsvp from "$lib/components/rsvp/SelectRsvp.svelte";
	import CalendarCopy from "$lib/CalendarCopy.svelte";
	import ProposedTimeVotes from "$lib/components/events/ProposedTimeVotes.svelte";
	import GuestRsvp from "$lib/components/rsvp/GuestRsvp.svelte";
	import PlusOnes from "$lib/components/rsvp/PlusOnes.svelte";

	interface Props {
		data: {
			event: Event;
			user: User;
			my_user_id: string;
			// signed out: the guest remembered in this browser, if any
			guest?: Guest | null;
		};
	}

	let { data }: Props = $props();
	let my_user_id = data.my_user_id;

	let comments = data.event.comments || [];

	let num_comments = comments.length;

	/* RSVP status */
	let current_user_rsvp = (() => {
		if (my_user_id === null || my_user_id === "" || typeof my_user_id === "undefined") {
			return null;
		}
		return data.event.rsvps.find((rsvp) => rsvp.user.id === my_user_id) ?? null;
	})();

	/* +1s appear under the user who added them, or at the bottom if that user isn't in the list */
	let plus_ones = $derived(data.event.plus_ones ?? []);
	const plusOnesFor = (user_id: string) => plus_ones.filter((p) => p.user_id === user_id);
	let listed_user_ids = $derived(new Set(data.event.rsvps.map((rsvp) => rsvp.user.id)));
	let unlisted_plus_ones = $derived(plus_ones.filter((p) => !listed_user_ids.has(p.user_id)));

	let delete_event = async () => {
		const response = await fetch("/api/events/delete", {
			method: "POST",
			body: JSON.stringify({ id: data.event.id }),
			headers: {
				"Content-Type": "application/json",
			},
		});
		let res = await response.json();
		if (res.success) {
			newToast("Successfully deleted event");
			goto("/posts");
		} else {
			newToast("Error deleting a event: " + res.message, ToastType.Error);
		}
	};

	let localizedCreateTime = $derived(parseAbsoluteToLocal(data.event.created_at));
	let formattedCreateTime = $state();
	let localizedStartTime = $derived(parseAbsoluteToLocal(data.event.start_date_time));
	let formattedStartDate = $state();
	let formattedStartTime = $state();
	// bumps when the start time or confirmed status changes on the page (the host clicked a star)
	let start_time_updates = $state(0);
	let previous_schedule: string | null = null;
	$effect(() => {
		const schedule = `${data.event.start_date_time}|${data.event.chosen_proposed_time_id}`;
		if (previous_schedule !== null && previous_schedule !== schedule) {
			start_time_updates += 1;
		}
		previous_schedule = schedule;
	});

	let signed_in = $state(false);
	onMount(() => {
		signed_in = isSignedIn();
		localizedCreateTime = parseAbsoluteToLocal(data.event.created_at);

		formattedCreateTime = new Intl.DateTimeFormat("en-US", {
			dateStyle: "medium",
			timeStyle: "short",
			timeZone: localizedCreateTime.timeZone,
		}).format(localizedCreateTime.toDate());
	});

	// an effect (not onMount) so the start time updates when the host chooses a proposed time
	$effect(() => {
		formattedStartDate = new Intl.DateTimeFormat("en-US", {
			weekday: "short",
			month: "short",
			year: "numeric",
			day: "numeric",
			timeZone: localizedStartTime.timeZone,
		}).format(localizedStartTime.toDate());
		formattedStartTime = new Intl.DateTimeFormat("en-US", {
			hour: "numeric",
			minute: "numeric",
			hour12: true,
			timeZone: localizedStartTime.timeZone,
		}).format(localizedStartTime.toDate());
	});
</script>

<div>
	{#if signed_in}
		<CalendarCopy />
	{/if}

	{#if my_user_id === data.event.user.id}
		<div class="float-right relative">
			<LinkButton url="/events/{data.event.id}/edit">Edit</LinkButton>
			<Button onclick={delete_event} variant="destructive">Delete</Button>
		</div>
	{/if}
	<div>
		<div class="flex flex-row justify-between">
			<!--        <svelte:boundary>-->
			<div>
				<span class="font-bold">
					<!-- I just broke this for the feed TODO SARAH -->
					<Link url="/users/{data.event.user.id}">{data.event.user.name}</Link>
				</span>'s event
			</div>
			<!--        <div><span class="font-bold"><a class="text-teal-400 hover:text-orange-400" href="/users/{data.event.creator_id}">{data.event.creator_name}</a></span> posted an upcoming event</div>-->
			<!--        </svelte:boundary>-->
			<div>
				<span class="text-sm">posted at {formattedCreateTime}</span>
			</div>
		</div>
		<div class="p-2">
			<Card.Root class=" border-lime-500 ">
				<Card.Header>
					{#if data.event.title}
						<Card.Title>{data.event.title}</Card.Title>
					{/if}
					<Card.Description>
						{#key start_time_updates}
							<span
								class="inline-flex flex-row items-center gap-1"
								class:time-updated={start_time_updates > 0}
							>
								{#if isSchedulingTime(data.event)}
									<span class="font-semibold">Pending</span>
								{:else if data.event.chosen_proposed_time_id}
									<span class="inline-flex flex-row items-center gap-1 font-semibold">
										<Star class="size-5 shrink-0 fill-yellow-400 text-yellow-500" />
										Confirmed
									</span>
								{/if}
								{formattedStartDate}
								at {formattedStartTime}
							</span>
						{/key}
					</Card.Description>
				</Card.Header>
				<Card.Content>
					<div class="flex flex-col gap-2">
						{#if data.event.description}
							<MarkedDownPost captured_text={data.event.description} />
						{/if}
						{#if data.event.proposed_times?.length > 0}
							<Separator class="my-4" />
							<ProposedTimeVotes
								proposed_times={data.event.proposed_times}
								my_user={signed_in ? (data.user ?? null) : null}
								is_host={my_user_id === data.event.user.id}
								chosen_proposed_time_id={data.event.chosen_proposed_time_id}
								event_id={data.event.id}
								guest_mode={!signed_in}
								guest={signed_in ? null : (data.guest ?? null)}
							/>
							<Separator class="my-4" />
						{/if}
						<div class="text-sm text-gray-500">
							{#if data.event.address}
								<span>at {data.event.address}</span>
							{/if}
						</div>
						{#if data.event.url}
							<p class="w-full truncate">
								<Tooltip.Provider>
									<Tooltip.Root>
										<Tooltip.Trigger>
											<Link url={data.event.url}>
												<span class="text-sm">{data.event.url}</span>
											</Link>
										</Tooltip.Trigger>
										<Tooltip.Content>
											<span>{data.event.url}</span>
										</Tooltip.Content>
									</Tooltip.Root>
								</Tooltip.Provider>
							</p>
						{/if}
						{#if signed_in}
							<PlusOnes event_id={data.event.id} my_plus_ones={plusOnesFor(my_user_id)}>
								<SelectRsvp rsvp={current_user_rsvp} event_id={data.event.id} />
							</PlusOnes>
						{:else}
							<GuestRsvp
								event_id={data.event.id}
								guest={data.guest ?? null}
								guest_rsvps={data.event.guest_rsvps ?? []}
							/>
						{/if}
					</div>

					<Separator class="my-6" />
					<div class="">
						<span class="text-xl">Rsvps</span>
						{#snippet plusOneRow(plus_one: PlusOne, with_user: boolean)}
							<div class="flex flex-row justify-between pl-4 text-sm">
								<div>
									{plus_one.name}
									{#if with_user}
										<span class="text-xs text-muted-foreground">with {plus_one.user_name}</span>
									{/if}
								</div>
								<Badge variant="outline">+1</Badge>
							</div>
						{/snippet}
						{#each data.event.rsvps as rsvp}
							<div class="flex flex-row justify-between">
								<div>
									{rsvp.user.name}
								</div>
								<div>
									<RsvpBadge {rsvp} />
								</div>
							</div>
							{#each plusOnesFor(rsvp.user.id) as plus_one (plus_one.id)}
								{@render plusOneRow(plus_one, false)}
							{/each}
						{/each}
						{#each data.event.guest_rsvps ?? [] as guest_rsvp}
							<div class="flex flex-row justify-between">
								<div>
									{guest_rsvp.guest_name}
									<span class="text-xs text-muted-foreground">guest</span>
								</div>
								<div>
									<RsvpBadge rsvp={guest_rsvp} />
								</div>
							</div>
						{/each}
						{#each unlisted_plus_ones as plus_one (plus_one.id)}
							{@render plusOneRow(plus_one, true)}
						{/each}
					</div>
				</Card.Content>
			</Card.Root>
		</div>
	</div>
	<div>
		{#if signed_in}
			<Commentable feed_item={data.event} {comments} />
		{:else}
			<div class="flex">
				{num_comments} Comments
				<MessageCircleMore />
			</div>
		{/if}
	</div>
</div>

<style>
	.time-updated {
		border-radius: 0.25rem;
		animation: time-updated 1.4s ease-out;
	}

	@keyframes time-updated {
		0% {
			transform: scale(1);
			background-color: transparent;
		}
		25% {
			transform: scale(1.15);
			background-color: rgb(250 204 21 / 0.6);
		}
		100% {
			transform: scale(1);
			background-color: transparent;
		}
	}

	@media (prefers-reduced-motion: reduce) {
		.time-updated {
			animation: none;
		}
	}
</style>
