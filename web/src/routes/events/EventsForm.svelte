<script lang="ts">
	import { enhance } from "$app/forms";
	import * as Form from "$lib/components/ui/form";
	import * as Card from "$lib/components/ui/card/index.js";
	import { Button } from "$lib/components/ui/button";
	import { Calendar } from "$lib/components/ui/calendar";
	import * as Popover from "$lib/components/ui/popover";
	import { Input } from "$lib/components/ui/input";
	import { type EventsFormSchema, eventsFormSchema } from "./schema";
	import { type SuperValidated, type Infer, superForm } from "sveltekit-superforms";
	import { zodClient } from "sveltekit-superforms/adapters";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { goto } from "$app/navigation";
	import { Textarea } from "$lib/components/ui/textarea";
	import { CalendarIcon } from "lucide-svelte";
	import {
		type DateValue,
		DateFormatter,
		getLocalTimeZone,
		toCalendarDate,
		toTime,
		today,
		Time,
		parseAbsoluteToLocal,
	} from "@internationalized/date";
	import MarkedDownPost from "$lib/components/posts/MarkedDownPost.svelte";

	let { data }: { data: { form: SuperValidated<Infer<EventsFormSchema>>; event: any } } = $props();

	const form = superForm(data.form, {
		validators: zodClient(eventsFormSchema),
	});

	const { form: formData } = form;

	const df = new DateFormatter("en-US", {
		dateStyle: "long",
	});

	let default_date = today(getLocalTimeZone()).add({ days: 1 });
	let start_date_value = $state<DateValue>(default_date);

	if (data.event) {
		let start_date_time = data.event.start_date_time;
		let start_date_localized = parseAbsoluteToLocal(start_date_time);
		start_date_value = toCalendarDate(start_date_localized);

		$formData.start_time = toTime(start_date_localized).toString().substring(0, 5);
		$formData.id = data.event.id;
	}

	$effect(() => {
		$formData.start_date = start_date_value.toString();
	});

	let creating = $state(false);
	let rendering = $state(false);

	let captured_text = $state("");

	let timer: number;
	const debounce = (v: string) => {
		rendering = true;
		clearTimeout(timer);
		timer = setTimeout(() => {
			captured_text = v;
			rendering = false;
		}, 500);
	};
</script>

<div>
	<div>
		{#if creating}
			<p>creating...</p>
		{/if}
		<form
			method="POST"
			use:enhance={() => {
				creating = true;
				return async ({ update, result }) => {
					await update();
					creating = false;
					let res = result.data;
					if (res.success) {
						console.log("success create event");
						newToast("You have successfully created an event!!");
						goto("/posts");
					} else {
						newToast("Error creating an event: " + res.message, ToastType.Error);
					}
				};
			}}
		>
			<Form.Field {form} name="title">
				<Form.Control let:attrs>
					<Form.Label>Title</Form.Label>
					<Input {...attrs} bind:value={$formData.title} />
				</Form.Control>
				<Form.Description>Name of the event.</Form.Description>
				<Form.FieldErrors />
			</Form.Field>
			<Form.Field {form} name="id">
				<input hidden value={$formData.id} name="id" />
			</Form.Field>
			<div class="flex flex-row justify-between">
				<Form.Field {form} name="start_date">
					<Form.Control let:attrs>
						<Form.Label>Date</Form.Label>
						<Popover.Root>
							<Popover.Trigger>
								<Button variant="outline" {...attrs}>
									<CalendarIcon class="mr-2 size-4" />
									{start_date_value
										? df.format(start_date_value.toDate(getLocalTimeZone()))
										: "Select a date"}
								</Button>
							</Popover.Trigger>
							<Popover.Content class="w-auto p-0">
								<Calendar
									bind:value={start_date_value}
									type="single"
									initialFocus
									onValueChange={(v) => {
										if (v) {
											$formData.start_date = v.toString();
										} else {
											$formData.start_date = "";
										}
									}}
								/>
							</Popover.Content>
						</Popover.Root>
						<input hidden value={$formData.start_date} name="start_date" />
					</Form.Control>
					<Form.FieldErrors />
				</Form.Field>
				<Form.Field {form} name="start_time">
					<Form.Control let:attrs>
						<Form.Label>Start Time</Form.Label>
						<input type="time" {...attrs} bind:value={$formData.start_time} />
					</Form.Control>
					<Form.FieldErrors />
				</Form.Field>
			</div>
			<Form.Field {form} name="time_zone">
				<Form.Control>
					<input hidden value={getLocalTimeZone()} name="time_zone" />
				</Form.Control>
				<Form.FieldErrors />
			</Form.Field>
			<Form.Field {form} name="description">
				<Form.Control let:attrs>
					<Card.Root>
						<Card.Header>
							<Card.Title>Preview of the description</Card.Title>
							<Card.Description>
								{#if rendering}
									<p>pause typing to render...</p>
								{:else}
									<p>markdown supported</p>
								{/if}
							</Card.Description>
						</Card.Header>
						<Card.Content>
							<MarkedDownPost {captured_text} />
						</Card.Content>
					</Card.Root>
					<Form.Label>Description</Form.Label>
					<Textarea
						{...attrs}
						bind:value={$formData.description}
						on:keyup={({ target: { value } }) => debounce(value)}
					/>
				</Form.Control>
				<Form.Description>Hype it up!!</Form.Description>
				<Form.FieldErrors />
			</Form.Field>
			<Form.Field {form} name="address">
				<Form.Control let:attrs>
					<Form.Label>Address</Form.Label>
					<Input {...attrs} bind:value={$formData.address} />
				</Form.Control>
				<Form.Description>Location.</Form.Description>
				<Form.FieldErrors />
			</Form.Field>
			<Form.Field {form} name="url">
				<Form.Control let:attrs>
					<Form.Label>Url</Form.Label>
					<Input {...attrs} bind:value={$formData.url} />
				</Form.Control>
				<Form.Description>Ticket or event link.</Form.Description>
				<Form.FieldErrors />
			</Form.Field>
			<Form.Field {form} name="event_type">
				<Form.Control let:attrs>
					<Form.Label>Event Type</Form.Label>
					<Input {...attrs} bind:value={$formData.event_type} />
				</Form.Control>
				<Form.Description>Help people find what they're interested in.</Form.Description>
				<Form.FieldErrors />
			</Form.Field>
			<Form.Button>Submit</Form.Button>
		</form>
	</div>
</div>
