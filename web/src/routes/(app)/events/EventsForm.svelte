<script lang="ts">
	import { enhance } from "$app/forms";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { goto } from "$app/navigation";
	import H1 from "$lib/components/text/H1.svelte";
	import FormButton from "$lib/components/form/FormButton.svelte";
	import InputDateTime from "$lib/components/form/InputDateTime.svelte";
	import { type Infer, superForm, type SuperValidated } from "sveltekit-superforms";
	import { eventsFormSchema, type EventsFormSchema } from "./schema";
	import { zodClient } from "sveltekit-superforms/adapters";
	import { Input } from "$lib/components/ui/input";
	import * as Form from "$lib/components/ui/form";
	import { Card } from "$lib/components/ui/card";
	import { Calendar } from "$lib/components/ui/calendar/index.js";

	import type { DateRange } from "bits-ui";
	import {
		CalendarDate,
		DateFormatter,
		type DateValue,
		parseDate,
		getLocalTimeZone,
		today,
	} from "@internationalized/date";
	import { cn } from "$lib/utils.js";
	import { Button, buttonVariants } from "$lib/components/ui/button/index.js";
	import { RangeCalendar } from "$lib/components/ui/range-calendar/index.js";
	import * as Popover from "$lib/components/ui/popover/index.js";
	import { CalendarIcon, CalendarRange } from "lucide-svelte";

	interface Props {
		form_data: SuperValidated<Infer<EventsFormSchema>>;
	}

	let { form_data }: Props = $props();

	const form = superForm(form_data, {
		validators: zodClient(eventsFormSchema),
	});

	const { form: formData } = form;

	let creating = $state(false);

	const df = new DateFormatter("en-US", {
		dateStyle: "medium",
	});

	let value = $state<DateValue | undefined>();

	$effect(() => {
		value = $formData.start_date ? parseDate($formData.start_date) : undefined;
	});

	let placeholder = $state<DateValue>(today(getLocalTimeZone()));
</script>

<div>
	{#if creating}
		<p>creating...</p>
	{/if}
	<Card class="p-4">
		<H1>Create an event post</H1>

		<form
			method="POST"
			action="?/create_event"
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
			<div class="flex flex-col">
				<Form.Field {form} name="title">
					<Form.Control let:attrs>
						<Form.Label>Title</Form.Label>
						<Input {...attrs} bind:value={$formData.title} />
					</Form.Control>
					<Form.Description>Name of the event</Form.Description>
					<Form.FieldErrors />
				</Form.Field>

				<div class="flex justify-between space-x-4">
					<div class="flex-1">
						<Form.Field {form} name="start_date" class="flex flex-col">
							<Form.Control>
								{#snippet children({ props })}
									<Form.Label>Date</Form.Label>
									<Popover.Root>
										<Popover.Trigger
											{...props}
											class={cn(
												buttonVariants({ variant: "outline" }),
												"w-[280px] justify-start pl-4 text-left font-normal",
												!value && "text-muted-foreground",
											)}
										>
											{value ? df.format(value.toDate(getLocalTimeZone())) : "Pick a date"}
											<CalendarIcon class="ml-auto size-4 opacity-50" />
										</Popover.Trigger>
										<Popover.Content class="w-auto p-0" side="top">
											<Calendar
												type="single"
												value={value as DateValue}
												bind:placeholder
												minValue={new CalendarDate(1900, 1, 1)}
												maxValue={today(getLocalTimeZone())}
												calendarLabel="Date of birth"
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
									<Form.Description
										>Your date of birth is used to calculator your age</Form.Description
									>
									<Form.FieldErrors />
									<!--									<input hidden value={$formData.start_date} name={props.name} />-->
								{/snippet}
							</Form.Control>
						</Form.Field>
					</div>
					<div class="flex-1">
						<Form.Field {form} name="start_date" class="flex flex-col">
							<Form.Control let:attrs>
								<Form.Label>Time</Form.Label>
								<input
									type="time"
									name="time_input"
									id="time_input"
									class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
									value={$formData.time ? $formData.time : "15:00"}
									required
								/>
								<Form.FieldErrors />
							</Form.Control>
						</Form.Field>
					</div>
				</div>

				<!--                    <Input name="title" label="Title:" value={form?.title}/>-->
				<!--                    <InputDateTime date_value={form?.date_input} time_value="{form?.time_input}"/>-->
				<!--                    <Input name="description" label="Description:"/>-->
				<!--                    <Input name="address" label="Address:" value={form?.address}/>-->
				<!--                    <Input name="url" label="URL:" value={form?.url}/>-->
				<!--                    <Input name="event_type" label="Event Type:" value={form?.event_type}/>-->
			</div>
			<FormButton>Create event</FormButton>
		</form>
	</Card>
</div>
