<script lang="ts">
	import { enhance } from "$app/forms";
	import * as Form from "$lib/components/ui/form/index.js";
	import { Input } from "$lib/components/ui/input/index.js";
	import { type EventsFormSchema, eventsFormSchema } from "./schema";
	import { type SuperValidated, type Infer, superForm } from "sveltekit-superforms";
	import { zodClient } from "sveltekit-superforms/adapters";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import { goto } from "$app/navigation";

	let { data }: { data: { form: SuperValidated<Infer<EventsFormSchema>> } } = $props();

	const form = superForm(data.form, {
		validators: zodClient(eventsFormSchema),
	});

	const { form: formData } = form;

	let creating = $state(false);
</script>

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
		<Form.Field {form} name="description">
			<Form.Control let:attrs>
				<Form.Label>Description</Form.Label>
				<Input {...attrs} bind:value={$formData.description} />
			</Form.Control>
			<Form.Description>description.</Form.Description>
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
			<Form.Description>Name of the event.</Form.Description>
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
