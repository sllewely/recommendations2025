<script lang="ts">
	import { enhance } from "$app/forms";
	import LinkButton from "$lib/components/text/LinkButton.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { goto } from "$app/navigation";
	import { MessageCircleMore } from "@lucide/svelte";
	import SubmitComment from "$lib/components/posts/SubmitComment.svelte";
	import Comment from "$lib/components/posts/Comment.svelte";
	import { Button } from "$lib/components/ui/button";
	import { current_user } from "$lib/state/current_user.svelte";
	import * as Card from "$lib/components/ui/card/index.js";
	import * as Tooltip from "$lib/components/ui/tooltip/index.js";
	import Link from "$lib/components/text/Link.svelte";
	import MarkedDownPost from "$lib/components/posts/MarkedDownPost.svelte";
	import RsvpBadge from "$lib/components/ui/badge/RsvpBadge.svelte";
	import { parseAbsoluteToLocal } from "@internationalized/date";
	import { onMount } from "svelte";
	import type { Event } from "$lib/api_calls/types";

	interface Props {
		data: {
			event: Event;
			my_user_id: string;
		};
	}

	let { data }: Props = $props();
	// let user = data.user;
	let my_user_id = data.my_user_id;

	let creating = $state(false);

	// Svelte pitfall.  Page updates are not triggered by load data prop change!!
	// This is the workaround
	let event = $state(data.event);
	$effect(() => {
		event = data.event;
	});

	let comments = $derived(event.comments || []);

	let num_comments = $derived(comments.length);

	let current_user_rsvp = $derived(
		event.rsvps.find((rsvp) => rsvp.user.id === current_user.id) ?? null,
	);

	let rsvp_status = $derived(current_user_rsvp ? current_user_rsvp.status : null);

	let delete_event = async () => {
		const response = await fetch("/api/delete_event", {
			method: "POST",
			body: JSON.stringify({ id: event.id }),
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

	let signed_in = $state(false);

	$effect(() => {
		signed_in = current_user && current_user.id !== "" && typeof current_user.id !== "undefined";
	});

	let localizedCreateTime = $derived(parseAbsoluteToLocal(event.created_at));
	let formattedCreateTime = $state();
	let localizedStartTime = $derived(parseAbsoluteToLocal(event.start_date_time));
	let formattedStartTime = $state();

	onMount(() => {
		localizedCreateTime = parseAbsoluteToLocal(event.created_at);

		formattedCreateTime = new Intl.DateTimeFormat("en-US", {
			dateStyle: "medium",
			timeStyle: "short",
			timeZone: localizedCreateTime.timeZone,
		}).format(localizedCreateTime.toDate());

		localizedStartTime = parseAbsoluteToLocal(event.start_date_time);
		formattedStartTime = new Intl.DateTimeFormat("en-US", {
			dateStyle: "medium",
			timeStyle: "short",
			timeZone: localizedCreateTime.timeZone,
		}).format(localizedStartTime.toDate());

		signed_in = current_user && current_user.id !== "" && typeof current_user.id !== "undefined";
	});
</script>

{console.log("rsvps", event.rsvps)}
{console.log("current_user_rsvp", current_user_rsvp)}

<div>
	{#if my_user_id === event.user.id}
		<div class="float-right relative">
			<LinkButton url="/events/{event.id}/edit">Edit</LinkButton>
			<Button onclick={delete_event} variant="destructive">Delete</Button>
		</div>
	{/if}
	<div>
		<div class="flex flex-row justify-between">
			<!--        <svelte:boundary>-->
			<div>
				<span class="font-bold">
					<!-- I just broke this for the feed TODO SARAH -->
					<Link url="/users/{event.user.id}">{event.user.name}</Link>
				</span> posted an upcoming event
			</div>
			<!--        <div><span class="font-bold"><a class="text-teal-400 hover:text-orange-400" href="/users/{event.creator_id}">{event.creator_name}</a></span> posted an upcoming event</div>-->
			<!--        </svelte:boundary>-->
			<div>
				<span class="text-sm">at {formattedCreateTime}</span>
			</div>
		</div>
		<div class="p-2">
			<a href="/events/{event.id}">
				<Card.Root
					class="dark:bg-gray-900 dark:text-gray-200 border-lime-500 hover:bg-lime-100 border-2 dark:hover:bg-emerald-950"
				>
					<Card.Header>
						{#if event.title}
							<Card.Title>{event.title}</Card.Title>
						{/if}
						<Card.Description>Happening {formattedStartTime}</Card.Description>
					</Card.Header>
					<Card.Content>
						{#if event.description}
							<MarkedDownPost captured_text={event.description} />
						{/if}
						<div class="text-sm text-gray-500">
							{#if event.address}
								<p>at {event.address}</p>
							{/if}
						</div>
						<div class="flex flex-row justify-between">
							<div>
								<RsvpBadge rsvp={current_user_rsvp} />
							</div>
							{#if event.url}
								<Tooltip.Provider>
									<Tooltip.Root>
										<Tooltip.Trigger>
											<Link url={event.url}>link</Link>
										</Tooltip.Trigger>
										<Tooltip.Content>
											<p>{event.url}</p>
										</Tooltip.Content>
									</Tooltip.Root>
								</Tooltip.Provider>
							{/if}
						</div>
					</Card.Content>
				</Card.Root>
			</a>
		</div>
	</div>
	<div>
		<div>
			{#if creating}
				<p>updating...</p>
			{/if}
			<form
				method="POST"
				action="?/update_rsvp"
				use:enhance={() => {
					creating = true;
					return async ({ update, result }) => {
						await update();
						creating = false;
						let res = result.data;
						if (res.success) {
							newToast("Success updating your rsvp");
						} else {
							newToast("Error updating rsvp: " + res.message, ToastType.Error);
						}
					};
				}}
			>
				<input type="hidden" name="event_id" value={event.id} />
				<input type="hidden" name="user_id" value={my_user_id} />
				<label for="rsvp_status">Your rsvp:</label>
				<select name="rsvp_status" id="rsvp_status" onchange={(e) => e.target.form.requestSubmit()}>
					<option value="not_selected" selected={rsvp_status === null}>not rsvp'd</option>
					<option value="going" selected={rsvp_status === "going"}>going</option>
					<option value="interested" selected={rsvp_status === "interested"}>interested</option>
					<option value="cant_go" selected={rsvp_status === "cant_go"}>can't go</option>
					<option value="not_interested" selected={rsvp_status === "not_interested"}
						>not interested
					</option>
				</select>
			</form>
		</div>
		<div>
			rsvps
			<div>
				{#each event.rsvps as rsvp}
					{rsvp.status}
				{/each}
			</div>
		</div>
	</div>
	<div>
		<div class="flex">
			{num_comments} Comments
			<MessageCircleMore />
		</div>
		{#if signed_in}
			<div>
				{#each comments as comment}
					<Comment {comment} />
				{/each}
			</div>

			<SubmitComment feed_item={event} />
		{:else}
			<Card.Root class="bg-teal-400">
				<Card.Content>Sign in to read and leave comments!</Card.Content>
			</Card.Root>
		{/if}
	</div>
</div>
