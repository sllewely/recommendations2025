<script lang="ts">
	import { enhance } from "$app/forms";
	import * as Form from "$lib/components/ui/form";
	import { type SuperValidated, type Infer, superForm } from "sveltekit-superforms";
	import { zodClient } from "sveltekit-superforms/adapters";
	import { Input } from "$lib/components/ui/input";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { type CircleFormSchema, circleFormSchema } from "./schema";
	import H1 from "$lib/components/text/H1.svelte";
	import H2 from "$lib/components/text/H2.svelte";
	import { Button } from "$lib/components/ui/button/index.js";
	import * as Card from "$lib/components/ui/card/index.js";

	let { data }: { data: { form: SuperValidated<Infer<CircleFormSchema>>; event: any } } = $props();

	const form = superForm(data.form, {
		validators: zodClient(circleFormSchema),
	});

	const { form: formData } = form;

	let creating = $state(false);
</script>

<div>
	<Card.Root>
		<Card.Header>
			<Card.Title>Add a new Circle</Card.Title>
			<Card.Description>Circles are a way to organize your friends</Card.Description>
		</Card.Header>
		<Card.Content>
			{#if creating}
				<p>creating...</p>
			{/if}
			<form
				method="POST"
				action="?/create_circle"
				use:enhance={() => {
					creating = true;
					return async ({ update, result }) => {
						await update();
						creating = false;
						let res = result.data;
						if (res.success) {
							console.log("success create circle");
							newToast("You have successfully created a circle!!");
						} else {
							newToast("Error creating circle: " + res.message, ToastType.Error);
						}
					};
				}}
			>
				<Form.Field {form} name="name">
					<Form.Control let:attrs>
						<Form.Label>Name</Form.Label>
						<Input {...attrs} bind:value={$formData.name} />
					</Form.Control>
					<Form.Control let:attrs>
						<Form.Label>Friends</Form.Label>
						<ul id="friends">list of friends will go here</ul>
						<div class="flex gap-2">
							<Input {...attrs} id="search" name="search" />
							<Button
								type="button"
								class="rounded hover:bg-orange-500 text-teal-700 font-semibold hover:text-white py-2 px-4 border border-teal-500 hover:border-transparent"
								variant="outline"
								on:click={() => {
									// call search_friends to populate potential friends

									pending_friends = [];
									document.getElementById("search").focus();
								}}
								>Search
							</Button>
						</div>
						<div>potential friends that you searched for</div>
					</Form.Control>
					<Form.FieldErrors />
				</Form.Field>
				<Form.Button>Submit</Form.Button>
			</form>
		</Card.Content>
	</Card.Root>
</div>
