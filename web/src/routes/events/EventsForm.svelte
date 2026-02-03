<script lang="ts">
	import { enhance } from "$app/forms";
	import * as Card from "$lib/components/ui/card/index.js";
	import { Button } from "$lib/components/ui/button";
	import { Calendar } from "$lib/components/ui/calendar";
	import * as Popover from "$lib/components/ui/popover";
	import { Input } from "$lib/components/ui/input/index.js";
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
	import { Field, Control, Label, Description, FieldErrors } from "formsnap";
	import { Spinner } from "$lib/components/ui/spinner";
	import HorizontalLabelInput from "$lib/components/form/HorizontalLabelInput.svelte";

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

	let submitDisabled = $state(false);

	const onSubmit = () => {
		console.log("submitting");
		document.getElementById("events_form").submit();
		submitDisabled = true;
	};
</script>

<div>
	<div>
		{#if creating}
			<p>creating...</p>
		{/if}
		<form
			id="events_form"
			method="POST"
			use:enhance={() => {
				creating = true;
				return async ({ update, result }) => {
					await update({ reset: false });
					creating = false;
					let res = result.data;
					if (res.success) {
						if (data.event) {
							newToast("You have successfully updated an event!!");
						} else {
							newToast("You have successfully created an event!!");
						}
						goto("/posts");
					} else {
						console.log(res.message);
						newToast("Error creating an event: " + res.message, ToastType.Error);
					}
				};
			}}
		>
			<Field {form} name="title">
				<Control>
					{#snippet children({ props })}
						<HorizontalLabelInput label_title="Title" {...props} bind:value={$formData.title} />
						<!--						<div class="flex flex-row gap-6 pb-6">-->
						<!--							<Label class="font-semibold">Title</Label>-->
						<!--							<Input {...props} bind:value={$formData.title} />-->
						<!--						</div>-->
					{/snippet}
				</Control>
				<FieldErrors />
			</Field>
			<Field {form} name="id">
				<input hidden value={$formData.id} name="id" />
			</Field>
			<div class="flex flex-row pb-6 items-end gap-6">
				<Field {form} name="start_date">
					<label class="font-semibold">Date</label>
					<Popover.Root>
						<Popover.Trigger>
							<Button variant="outline">
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
					<FieldErrors />
				</Field>
				<Field {form} name="start_time">
					<Control>
						{#snippet children({ props })}
							<Label class="font-semibold">Start Time</Label>
							<input type="time" {...props} bind:value={$formData.start_time} />
						{/snippet}
					</Control>
					<FieldErrors />
				</Field>
			</div>
			<Field {form} name="time_zone">
				<input hidden value={getLocalTimeZone()} name="time_zone" />
			</Field>
			<Field {form} name="description">
				<Control>
					{#snippet children({ props })}
						<Card.Root>
							<Card.Header>
								<Card.Title>Preview of the description</Card.Title>
								<Card.Description>
									{#if rendering}
										pause typing to render...
									{:else}
										markdown supported
									{/if}
								</Card.Description>
							</Card.Header>
							<Card.Content>
								<MarkedDownPost {captured_text} />
							</Card.Content>
						</Card.Root>
						<div class="pt-6">
							<Label class="font-semibold">Description</Label>
							<Textarea
								{...props}
								id="description"
								bind:value={$formData.description}
								onkeyup={({ target: { value } }) => debounce(value)}
							/>
						</div>
					{/snippet}
				</Control>
				<Description class="text-xs font-light">Hype it up!!</Description>
				<FieldErrors />
			</Field>
			<Field {form} name="address">
				<Control>
					{#snippet children({ props })}
						<div class="flex flex-row gap-6 pt-6 items-end">
							<Label class="font-semibold">Address</Label>
							<Input {...props} bind:value={$formData.address} />
						</div>
					{/snippet}
				</Control>
				<FieldErrors />
			</Field>
			<Field {form} name="url">
				<Control>
					{#snippet children({ props })}
						<div class="flex flex-row gap-6 pt-6 items-end">
							<Label class="font-semibold">Url</Label>
							<Input {...props} bind:value={$formData.url} />
						</div>
					{/snippet}
				</Control>
				<Description class="font-light text-xs">Ticket or event link.</Description>
				<FieldErrors />
			</Field>
			<Field {form} name="event_type">
				<Control>
					{#snippet children({ props })}
						<div class="flex flex-row gap-6 pt-6 items-end">
							<Label class="text-nowrap font-semibold">Event Type</Label>
							<Input {...props} bind:value={$formData.event_type} />
						</div>
					{/snippet}
				</Control>
				<Description class="text-xs font-light"
					>Help people find what they're interested in.
				</Description>
				<FieldErrors />
			</Field>
			<Field {form} name="is_public">
				<Control>
					{#snippet children({ props })}
						<input hidden value={$formData.is_public ?? true} {...props} />
					{/snippet}
				</Control>
			</Field>
			<div class="pt-6">
				<Button onclick={onSubmit} disabled={creating}>
					{#if creating}
						<Spinner />
					{/if}
					Submit
				</Button>
			</div>
		</form>
	</div>
</div>
