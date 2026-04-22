<script lang="ts">
	import { enhance } from "$app/forms";
	import LinkButton from "$lib/components/text/LinkButton.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { goto, invalidate } from "$app/navigation";
	import { MessageCircleMore } from "@lucide/svelte";
	import { Button } from "$lib/components/ui/button";
	import { current_user, isSignedIn } from "$lib/state/current_user.svelte";
	import * as Card from "$lib/components/ui/card/index.js";
	import * as Tooltip from "$lib/components/ui/tooltip/index.js";
	import Link from "$lib/components/text/Link.svelte";
	import MarkedDownPost from "$lib/components/posts/MarkedDownPost.svelte";
	import RsvpBadge from "$lib/components/ui/badge/RsvpBadge.svelte";
	import { parseAbsoluteToLocal } from "@internationalized/date";
	import { onMount } from "svelte";
	import type { Event, User } from "$lib/api_calls/types";
	import { Separator } from "$lib/components/ui/separator";
	import * as Select from "$lib/components/ui/select/index.js";
	import Commentable from "$lib/components/posts/Commentable.svelte";
	import SelectRsvp from "$lib/components/rsvp/SelectRsvp.svelte";
	import CalendarCopy from "$lib/CalendarCopy.svelte";

	interface Props {
		data: {
			event: Event;
			user: User;
			my_user_id: string;
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

	let signed_in = $state(false);
	onMount(() => {
		signed_in = isSignedIn();
		localizedCreateTime = parseAbsoluteToLocal(data.event.created_at);

		formattedCreateTime = new Intl.DateTimeFormat("en-US", {
			dateStyle: "medium",
			timeStyle: "short",
			timeZone: localizedCreateTime.timeZone,
		}).format(localizedCreateTime.toDate());

		localizedStartTime = parseAbsoluteToLocal(data.event.start_date_time);
		formattedStartDate = new Intl.DateTimeFormat("en-US", {
			weekday: "short",
			month: "short",
			year: "numeric",
			day: "numeric",
			timeZone: localizedCreateTime.timeZone,
		}).format(localizedStartTime.toDate());
		formattedStartTime = new Intl.DateTimeFormat("en-US", {
			hour: "numeric",
			minute: "numeric",
			hour12: true,
			timeZone: localizedCreateTime.timeZone,
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
						{formattedStartDate}
						at {formattedStartTime}
					</Card.Description>
				</Card.Header>
				<Card.Content>
					<div class="flex flex-col gap-2">
						{#if data.event.description}
							<MarkedDownPost captured_text={data.event.description} />
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
							<div>
								<SelectRsvp rsvp={current_user_rsvp} event_id={data.event.id} />
							</div>
						{:else}
							<RsvpBadge rsvp={{ status: "not_rsvpd" }} />
							<span>Sign in to rsvp</span>
						{/if}
					</div>

					<Separator class="my-6" />
					<div class="">
						<span class="text-xl">Rsvps</span>
						{#if signed_in}
							{#each data.event.rsvps as rsvp}
								<div class="flex flex-row justify-between">
									<div>
										{rsvp.user.name}
									</div>
									<div>
										<RsvpBadge {rsvp} />
									</div>
								</div>
							{/each}
						{:else}
							<span>Sign in to see who's coming</span>
							<span>Rsvps: {data.event.rsvps.length}</span>
						{/if}
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
