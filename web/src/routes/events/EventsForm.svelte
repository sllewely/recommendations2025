<script lang="ts">
	import { enhance } from "$app/forms";
	import { browser } from "$app/environment";
	import { goto } from "$app/navigation";
	import { type SuperValidated, type Infer, superForm } from "sveltekit-superforms";
	import { zodClient } from "sveltekit-superforms/adapters";
	import {
		getLocalTimeZone,
		parseAbsoluteToLocal,
		toCalendarDate,
		toTime,
		today,
	} from "@internationalized/date";
	import { CalendarDays } from "@lucide/svelte";
	import { type EventsFormSchema, eventsFormSchema } from "./schema";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { formatWhen } from "$lib/format_date";
	import type { Event as EventType, User } from "$lib/api_calls/types";
	import Button from "$lib/components/Button.svelte";
	import MarkedDownPost from "$lib/components/posts/MarkedDownPost.svelte";
	import FeedBadge, { CARD } from "$lib/components/posts/FeedBadge.svelte";
	import { cn } from "$lib/utils.js";
	import FormField from "$lib/components/form/FormField.svelte";
	import FormRow from "$lib/components/form/FormRow.svelte";
	import SharingPrivacy from "$lib/components/form/SharingPrivacy.svelte";
	import type { PickedPerson } from "$lib/components/users/PeoplePicker.svelte";
	import PeoplePicker from "$lib/components/users/PeoplePicker.svelte";
	import { Spinner } from "$lib/components/ui/spinner";

	let {
		data,
	}: {
		data: { form: SuperValidated<Infer<EventsFormSchema>>; event?: EventType };
	} = $props();

	const form = superForm(data.form, {
		validators: zodClient(eventsFormSchema),
	});
	const { form: formData } = form;

	let creating = $state(false);
	let audience = $state<PickedPerson[]>(data.event?.audience ?? []);

	let invited = $state<PickedPerson[]>(
		data.event?.rsvps?.map((rsvp) => ({
			type: "user" as const,
			id: rsvp.user.id,
			name: rsvp.user.name,
			profile_photo_url: rsvp.user.profile_photo_url,
		})) ?? [],
	);

	if (data.event) {
		const start = parseAbsoluteToLocal(data.event.start_date_time);
		$formData.start_date = toCalendarDate(start).toString();
		$formData.start_time = toTime(start).toString().substring(0, 5);
		$formData.id = data.event.id;
	} else if (!$formData.start_date) {
		$formData.start_date = today(getLocalTimeZone()).add({ days: 1 }).toString();
	}

	$effect(() => {
		$formData.invited_friend_ids = invited.map((f) => f.id);
	});

	let preview_when = $derived.by(() => {
		if (!browser || !$formData.start_date) return "";
		const start = new Date(`${$formData.start_date}T${$formData.start_time || "00:00"}`);
		return isNaN(start.getTime()) ? "" : formatWhen(start.toISOString());
	});
</script>

<form
	id="events_form"
	method="POST"
	class="flex flex-col gap-3"
	use:enhance={() => {
		creating = true;
		return async ({ update, result }) => {
			await update();
			creating = false;
			const res = result.data;
			if (res?.success) {
				newToast(
					data.event
						? "You have successfully updated an event!!"
						: "You have successfully created an event!!",
				);
				goto("/");
			} else {
				newToast("Error saving event" + (res?.error ? ": " + res.error : ""), ToastType.Error);
			}
		};
	}}
>
	<section aria-label="preview" class={cn("mb-7 flex flex-col gap-5", CARD)}>
		<div class="flex flex-row items-center gap-3">
			<FeedBadge icon={CalendarDays} accent="lime" />
			{#if $formData.title?.trim()}
				<h3 class="mt-1 text-lg font-semibold leading-tight">{$formData.title}</h3>
			{:else}
				<h3 class="mt-1 text-lg italic leading-tight text-zinc-500 dark:text-zinc-400">
					your event
				</h3>
			{/if}
		</div>
		<ul
			class="flex min-w-0 flex-col gap-1 text-sm text-zinc-500 dark:text-zinc-400 [&>li]:truncate [&_.value]:text-zinc-700 dark:[&_.value]:text-zinc-300"
		>
			<li>on <span class="value">{preview_when}</span></li>
			{#if $formData.address?.trim()}
				<li>at <span class="value">{$formData.address}</span></li>
			{/if}
			{#if $formData.url?.trim()}
				<li>see <span class="value underline">{$formData.url}</span></li>
			{/if}
		</ul>
		{#if $formData.description?.trim()}
			<MarkedDownPost captured_text={$formData.description} />
		{/if}
	</section>

	<FormField
		{form}
		name="title"
		label="title"
		bind:value={$formData.title}
		placeholder="what's happening?"
	/>

	<FormField
		{form}
		name="start_date"
		label="date"
		type="date"
		bind:value={$formData.start_date}
		class="w-auto self-start dark:scheme-dark"
	/>
	<FormField
		{form}
		name="start_time"
		label="start time"
		type="time"
		bind:value={$formData.start_time}
		class="w-auto self-start dark:scheme-dark"
	/>

	<FormField
		{form}
		name="description"
		label="description"
		multiline
		bind:value={$formData.description}
		placeholder="hype it up! (markdown supported)"
		class="min-h-40"
	/>
	<FormField
		{form}
		name="address"
		label="address"
		bind:value={$formData.address}
		placeholder="where is it?"
	/>
	<FormField
		{form}
		name="url"
		label="link"
		bind:value={$formData.url}
		placeholder="tickets or event page"
	/>
	<FormField
		{form}
		name="event_type"
		label="event type"
		bind:value={$formData.event_type}
		placeholder="helps people find what they're into"
	/>

	<FormRow label="invite friends" for="invite_friends">
		<PeoplePicker
			id="invite_friends"
			name="invited_friend_ids"
			add_label="invite"
			picked_subtitle="invited!"
			bind:picked={invited}
		/>
	</FormRow>

	<input hidden value={$formData.id} name="id" />
	<input hidden value={getLocalTimeZone()} name="time_zone" />

	<SharingPrivacy bind:value={$formData.privacy} bind:audience />

	<FormRow>
		<Button type="submit" disabled={creating} class="self-start">
			{#if creating}
				<Spinner />
			{/if}
			{$formData.id ? "save" : "create"}
		</Button>
	</FormRow>
</form>
