<script lang="ts">
	import { enhance } from "$app/forms";
	import { goto } from "$app/navigation";
	import FormButton from "$lib/components/form/FormButton.svelte";
	import H1 from "$lib/components/text/H1.svelte";
	import Link from "$lib/components/text/Link.svelte";
	import * as Form from "$lib/components/ui/form/index.js";
	import { Input } from "$lib/components/ui/input/index.js";
	import { signinFormSchema, type SigninFormSchema } from "./schema";
	import { type SuperValidated, type Infer, superForm } from "sveltekit-superforms";
	import { zodClient } from "sveltekit-superforms/adapters";

	import { current_user } from "$lib/state/current_user.svelte";
	import { setPendingToast, newToast, ToastType } from "$lib/state/toast.svelte";

	let creating = $state(false);

	let { data }: { data: { form: SuperValidated<Infer<SigninFormSchema>> } } = $props();

	const form = superForm(data.form, {
		validators: zodClient(signinFormSchema),
	});

	const { form: formData } = form;
</script>

<div>
	{#if creating}
		<p>signing in...</p>
	{/if}

	<form
		method="POST"
		action="?/signin"
		use:enhance={() => {
			creating = true;
			return async ({ update, result }) => {
				await update();
				creating = false;
				let res = result.data;
				if (res.success) {
					current_user.auth_token = res["auth_token"];
					current_user.id = res["user_id"];
					setPendingToast("You have successfully signed in!", ToastType.Success);
					goto("/posts");
				} else {
					newToast("Error signing in: " + res.message, ToastType.Error);
				}
			};
		}}
	>
		<div class="flex flex-col">
			<Form.Field {form} name="email">
				<Form.Control>
					{#snippet children({ props })}
						<Form.Label>E-mail</Form.Label>
						<Input {...props} bind:value={$formData.email} />
					{/snippet}
				</Form.Control>
				<Form.FieldErrors />
			</Form.Field>
			<Form.Field {form} name="password">
				<Form.Control>
					{#snippet children({ props })}
						<Form.Label>Password</Form.Label>
						<Input {...props} bind:value={$formData.password} input_type="password" />
					{/snippet}
				</Form.Control>
				<Form.Description
					>Message Sarah if you forgot your password and want it reset.
				</Form.Description>
				<Form.FieldErrors />
			</Form.Field>
		</div>
		<FormButton>Sign in</FormButton>
	</form>
</div>
