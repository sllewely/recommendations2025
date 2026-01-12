<script lang="ts">
	import { enhance } from "$app/forms";
	import LinkButton from "$lib/components/text/LinkButton.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { goto, invalidate } from "$app/navigation";
	import { MessageCircleMore } from "@lucide/svelte";
	import SubmitComment from "$lib/components/posts/SubmitComment.svelte";
	import Comment from "$lib/components/posts/Comment.svelte";
	import { Button } from "$lib/components/ui/button";
	import { current_user, isSignedIn } from "$lib/state/current_user.svelte";
	import * as Card from "$lib/components/ui/card/index.js";
	import * as Tooltip from "$lib/components/ui/tooltip/index.js";
	import Link from "$lib/components/text/Link.svelte";
	import MarkedDownPost from "$lib/components/posts/MarkedDownPost.svelte";
	import RsvpBadge from "$lib/components/ui/badge/RsvpBadge.svelte";
	import { parseAbsoluteToLocal } from "@internationalized/date";
	import { onMount } from "svelte";
	import type { Event } from "$lib/api_calls/types";
	import { Separator } from "$lib/components/ui/separator";
	import * as Select from "$lib/components/ui/select/index.js";

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

	// // Svelte pitfall.  Page updates are not triggered by load data prop change!!
	// // This is the workaround
	// let event = $state(data.event);
	// $effect(() => {
	// 	event = data.event;
	// });

	let comments = data.event.comments || [];

	let num_comments = comments.length;

	/* RSVP status */
	let current_user_rsvp = (() => {
		if (my_user_id === null || my_user_id === "" || typeof my_user_id === "undefined") {
			return null;
		}
		return data.event.rsvps.find((rsvp) => rsvp.user.id === my_user_id) ?? null;
	})();
	let rsvp_status = $state(current_user_rsvp ? current_user_rsvp.status : null);

	const rsvp_statuses = ["going", "interested", "cant_go", "not_interested", "not_rsvpd"];

	let delete_event = async () => {
		const response = await fetch("/api/delete_event", {
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

	onMount(() => {
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

	const update_rsvp = async (status: String) => {
		console.log("update_rsvp", status);
		const response = await fetch("/api/rsvp/update", {
			method: "POST",
			headers: {
				"Content-Type": "application/json",
			},
			body: JSON.stringify({
				user_id: my_user_id,
				event_id: data.event.id,
				status: status,
			}),
		});
		const json = await response.json();
		if (json["errors"]) {
		} else {
			console.log("json", json);
			// await invalidate(`/events/${data.event.id}`);
			window.location.reload();
		}
	};
</script>

<div>
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
			<a href="/events/{data.event.id}">
				<Card.Root class=" border-lime-500 ">
					<Card.Header>
						{#if data.event.title}
							<Card.Title>{data.event.title}</Card.Title>
						{/if}
						<Card.Description>
							<div class="flex flex-col">
								<div>
									{formattedStartDate}
								</div>
								<div>
									At {formattedStartTime}
								</div>
							</div>
						</Card.Description>
					</Card.Header>
					<Card.Content>
						{#if data.event.description}
							<MarkedDownPost captured_text={data.event.description} />
						{/if}
						<div class="text-sm text-gray-500">
							{#if data.event.address}
								<p>at {data.event.address}</p>
							{/if}
						</div>
						<div class="flex flex-row justify-between">
							{#if isSignedIn()}
								<div>
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
										<Select.Root type="single" name="rsvpStatus" bind:value={rsvp_status}>
											<Select.Trigger>
												<RsvpBadge rsvp={current_user_rsvp} />
											</Select.Trigger>
											<Select.Content>
												<Select.Group>
													{#each rsvp_statuses as status}
														<Select.Item
															value={status}
															onclick={() => {
																update_rsvp(status);
															}}
														>
															<RsvpBadge rsvp={{ status: status }} />
														</Select.Item>
													{/each}
												</Select.Group>
											</Select.Content>
										</Select.Root>
									</form>
								</div>
							{:else}
								<RsvpBadge rsvp={{ status: "not_rsvpd" }} />
								<p>Sign in to rsvp</p>
							{/if}
							{#if data.event.url}
								<Tooltip.Provider>
									<Tooltip.Root>
										<Tooltip.Trigger>
											<Link url={data.event.url}>link</Link>
										</Tooltip.Trigger>
										<Tooltip.Content>
											<p>{data.event.url}</p>
										</Tooltip.Content>
									</Tooltip.Root>
								</Tooltip.Provider>
							{/if}
						</div>
						<Separator class="my-6" />
						<div class="">
							<span class="text-xl">Rsvps</span>
							{#if isSignedIn()}
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
								<p>Sign in to see who's coming</p>
								<p>Rsvps: {data.event.rsvps.length}</p>
							{/if}
						</div>
					</Card.Content>
				</Card.Root>
			</a>
		</div>
	</div>
	<div>
		<div class="flex">
			{num_comments} Comments
			<MessageCircleMore />
		</div>
		{#if isSignedIn()}
			<div>
				{#each comments as comment}
					<Comment {comment} />
				{/each}
			</div>

			<SubmitComment feed_item={data.event} />
		{:else}
			<Card.Root class="bg-teal-400">
				<Card.Content>Sign in to read and leave comments!</Card.Content>
			</Card.Root>
		{/if}
	</div>
</div>
