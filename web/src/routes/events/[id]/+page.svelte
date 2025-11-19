<script lang="ts">
	import { enhance } from "$app/forms";
	import LinkButton from "$lib/components/text/LinkButton.svelte";
	import EventCard from "$lib/components/posts/EventCard.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { goto } from "$app/navigation";
	import { MessageCircleMore } from "@lucide/svelte";
	import SubmitComment from "$lib/components/posts/SubmitComment.svelte";
	import Comment from "$lib/components/posts/Comment.svelte";
	import { Button } from "$lib/components/ui/button";
	import { current_user } from "$lib/state/current_user.svelte";
	import * as Card from "$lib/components/ui/card/index.js";

	let { data } = $props();
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
</script>

<div>
	{#if my_user_id === event.user.id}
		<div class="float-right relative">
			<LinkButton url="/events/{event.id}/edit">Edit</LinkButton>
			<Button onclick={delete_event} variant="destructive">Delete</Button>
		</div>
	{/if}
	<EventCard feed_item={event} />
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
