<script lang="ts">
	import { enhance } from "$app/forms";
	import { goto } from "$app/navigation";
	import { Input } from "$lib/components/ui/input";
	import { signinFormSchema, type SigninFormSchema } from "./schema";
	import { type SuperValidated, type Infer, superForm } from "sveltekit-superforms";
	import { zodClient } from "sveltekit-superforms/adapters";
	import { Field, Control, Description } from "formsnap";
	import FormLabel from "$lib/components/form/FormLabel.svelte";
	import FormFieldErrors from "$lib/components/form/FormFieldErrors.svelte";

	import { current_user } from "$lib/state/current_user.svelte.js";
	import { setPendingToast, newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { Button } from "$lib/components/ui/button";

	let creating = $state(false);

	let { form_data }: { form_data: SuperValidated<Infer<SigninFormSchema>> } = $props();

	const form = superForm(form_data, {
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
					current_user.id = res["res"]["my_user_id"];
					setPendingToast("You have successfully signed in!", ToastType.Success);
					goto("/posts");
				} else {
					if (res.message) {
						newToast("Error signing in: " + res.message, ToastType.Error);
					}
				}
			};
		}}
	>
		<div class="flex flex-col">
			<Field {form} name="email">
				<Control>
					{#snippet children({ props })}
						<FormLabel>E-mail</FormLabel>
						<Input {...props} bind:value={$formData.email} />
					{/snippet}
				</Control>
				<FormFieldErrors />
			</Field>
			<Field {form} name="password">
				<Control>
					{#snippet children({ props })}
						<FormLabel>Password</FormLabel>
						<Input {...props} bind:value={$formData.password} type="password" />
					{/snippet}
				</Control>
				<Description>Message Sarah if you forgot your password</Description>
				<FormFieldErrors />
			</Field>
		</div>
		<Button type="submit">Sign in</Button>
	</form>
</div>
