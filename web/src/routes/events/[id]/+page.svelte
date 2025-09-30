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

	let rsvp = $derived(event.current_user_rsvp);

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
</script>

{console.log("hello")}
{console.log(event)}

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
				<select
					name="rsvp_status"
					id="rsvp_status"
					onchange={(event) => event.target.form.requestSubmit()}
				>
					<option value="not_selected" selected={rsvp === null}>not rsvp'd</option>
					<option value="going" selected={rsvp === "going"}>going</option>
					<option value="interested" selected={rsvp === "interested"}>interested</option>
					<option value="cant_go" selected={rsvp === "cant_go"}>can't go</option>
					<option value="not_interested" selected={rsvp === "not_interested"}
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
		<div>
			{#each comments as comment}
				<Comment {comment} />
			{/each}
		</div>

		<SubmitComment feed_item={event} />
	</div>
</div>
