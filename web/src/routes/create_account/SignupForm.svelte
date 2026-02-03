<script lang="ts">
	import { enhance } from "$app/forms";
	import { goto } from "$app/navigation";
	import { Input } from "$lib/components/ui/input";
	import { signupFormSchema, type SignupFormSchema } from "./schema";
	import { type SuperValidated, type Infer, superForm } from "sveltekit-superforms";
	import { zodClient } from "sveltekit-superforms/adapters";
	import { Field, Control, Label, Description, FieldErrors } from "formsnap";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { Button } from "$lib/components/ui/button";

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
				await update({ reset: false });
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
			<Field {form} name="name">
				<Control>
					{#snippet children({ props })}
						<Label class="font-semibold">Name</Label>
						<Input {...props} bind:value={$formData.name} />
					{/snippet}
				</Control>
				<Description>Display name visible to others</Description>
				<FieldErrors />
			</Field>
			<Field {form} name="email">
				<Control>
					{#snippet children({ props })}
						<Label class="font-semibold">E-mail</Label>
						<Input {...props} bind:value={$formData.email} />
					{/snippet}
				</Control>
				<FieldErrors />
			</Field>
			<Field {form} name="password">
				<Control>
					{#snippet children({ props })}
						<Label class="font-semibold">Password</Label>
						<Input {...props} bind:value={$formData.password} type="password" />
					{/snippet}
				</Control>
				<FieldErrors />
			</Field>
		</div>
		<Button type="submit">Create account</Button>
	</form>
</div>
