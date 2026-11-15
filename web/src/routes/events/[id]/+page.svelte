<script lang="ts">
	import UserCard from "$lib/components/users/UserCard.svelte";
	import Button from "$lib/components/Button.svelte";
	import SubHeader from "$lib/components/SubHeader.svelte";
	import SubHeaderTitle from "$lib/components/SubHeaderTitle.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { goto, invalidate } from "$app/navigation";
	import type { Event, User } from "$lib/api_calls/types";
	import EventCard from "$lib/components/posts/EventCard.svelte";
	import Comments from "$lib/components/posts/Comments.svelte";
	import RsvpList from "$lib/components/rsvp/RsvpList.svelte";
	import SectionHeading from "$lib/components/text/SectionHeading.svelte";

	interface Props {
		data: {
			event: Event;
			user: User;
			my_user_id: string;
		};
	}

	let { data }: Props = $props();
	let my_user_id = data.my_user_id;

	let comments = $state(data.event.comments ?? []);
	let rsvps = $state(data.event.rsvps ?? []);

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
			goto("/");
		} else {
			newToast("Error deleting a event: " + res.message, ToastType.Error);
		}
	};
</script>

<SubHeader>
	<SubHeaderTitle title={data.event.title || "event"}>
		{#snippet caption()}
			by <UserCard user={data.event.user} size="sm" />
		{/snippet}
	</SubHeaderTitle>
	{#if my_user_id === data.event.user.id}
		<div class="flex flex-row gap-5">
			<Button href="/events/{data.event.id}/edit">edit</Button>
			<Button color="red" onclick={delete_event}>delete</Button>
		</div>
	{/if}
</SubHeader>

<!-- the event across the top, then comments (left 2/3) and rsvps (right 1/3); stacked on mobile -->
<div class="flex flex-col gap-10 md:grid md:grid-cols-3 md:gap-5">
	<div class="md:col-span-3">
		<EventCard feed_item={data.event} truncate={false} panels={false} />
	</div>

	<section class="flex min-w-0 flex-col gap-3 md:col-span-2">
		<SectionHeading>comments</SectionHeading>
		<Comments feed_item={data.event} bind:comments />
	</section>

	<section class="flex min-w-0 flex-col gap-3">
		<SectionHeading>rsvps</SectionHeading>
		<RsvpList event_id={data.event.id} bind:rsvps />
	</section>
</div>
