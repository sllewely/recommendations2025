<script lang="ts">
	import { enhance } from "$app/forms";
	import Input from "$lib/components/form/Input.svelte";
	import InputDateTime from "$lib/components/form/InputDateTime.svelte";
	import InputCheckbox from "$lib/components/form/InputCheckbox.svelte";
	import FormButton from "$lib/components/form/FormButton.svelte";
	import H1 from "$lib/components/text/H1.svelte";
	import Link from "$lib/components/text/Link.svelte";
	import ToggleButton from "$lib/components/form/ToggleButton.svelte";
	import Card from "$lib/components/Card.svelte";
	import LinkButton from "$lib/components/text/LinkButton.svelte";

	import { RecommendationStatus } from "$lib/enums";
	import InputeDateTime from "$lib/components/form/InputDateTime.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import { goto } from "$app/navigation";

	let { data, form } = $props();

	let creating = $state(false);

	// TODO:
	// Privacy
</script>

<div>
	<H1>Create an event post</H1>

	{#if creating}
		<p>creating...</p>
	{/if}
	<Card>
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
				<Card>
					<Input name="title" label="Title:" value={form?.title} />
					<InputDateTime date_value={form?.date_input} time_value={form?.time_input} />
					<Input name="description" label="Description:" />
					<Input name="address" label="Address:" value={form?.address} />
					<Input name="url" label="URL:" value={form?.url} />
					<Input name="event_type" label="Event Type:" value={form?.event_type} />
				</Card>
			</div>
			<FormButton>Create event</FormButton>
		</form>
	</Card>
</div>
