<script lang="ts">
	import { enhance } from "$app/forms";
	import { goto } from "$app/navigation";
	import FormButton from "$lib/components/form/FormButton.svelte";
	import H1 from "$lib/components/text/H1.svelte";
	import * as Form from "$lib/components/ui/form/index.js";
	import { Input } from "$lib/components/ui/input/index.js";
	import { signupFormSchema, type SignupFormSchema } from "./schema";
	import { type SuperValidated, type Infer, superForm } from "sveltekit-superforms";
	import { zodClient } from "sveltekit-superforms/adapters";

	import { current_user } from "$lib/state/current_user.svelte";
	import { setPendingToast, newToast, ToastType } from "$lib/state/toast.svelte";

	let creating = $state(false);

	let { form_data }: { form_data: SuperValidated<Infer<SignupFormSchema>> } = $props();

	const form = superForm(form_data, {
		validators: zodClient(signupFormSchema),
	});

	const { form: formData } = form;
</script>

<div>
	{#if creating}
		<p>creating...</p>
	{/if}

	<form
		method="POST"
		action="?/create"
		use:enhance={() => {
			creating = true;
			return async ({ update, result }) => {
				await update();
				creating = false;
				let res = result.data;
				if (res.success) {
					newToast("You have successfully created an account!!!!");
					goto("/sign_in");
				} else {
					if (res.message) {
						newToast("Error creating an account: " + res.message, ToastType.Error);
					}
				}
			};
		}}
	>
		<div class="flex flex-col">
			<Form.Field {form} name="name">
				<Form.Control let:attrs>
					<Form.Label>Name</Form.Label>
					<Input {...attrs} bind:value={$formData.name} />
				</Form.Control>
				<Form.Description>Display name visible to others</Form.Description>
				<Form.FieldErrors />
			</Form.Field>
			<Form.Field {form} name="email">
				<Form.Control let:attrs>
					<Form.Label>E-mail</Form.Label>
					<Input {...attrs} bind:value={$formData.email} />
				</Form.Control>
				<Form.FieldErrors />
			</Form.Field>
			<Form.Field {form} name="password">
				<Form.Control let:attrs>
					<Form.Label>Password</Form.Label>
					<Input {...attrs} bind:value={$formData.password} type="password" />
				</Form.Control>
				<Form.FieldErrors />
			</Form.Field>
		</div>
		<Form.Button>Create account</Form.Button>
	</form>
</div>
