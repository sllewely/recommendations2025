<script lang="ts">
	import SubHeader from "$lib/components/SubHeader.svelte";
	import SubHeaderTitle from "$lib/components/SubHeaderTitle.svelte";
	import SectionHeading from "$lib/components/text/SectionHeading.svelte";
	import type { PageData } from "./$types.js";
	import { enhance } from "$app/forms";
	import { goto } from "$app/navigation";
	import { signupFormSchema } from "./schema";
	import { superForm } from "sveltekit-superforms";
	import { zodClient } from "sveltekit-superforms/adapters";
	import FormField from "$lib/components/form/FormField.svelte";
	import FormRow from "$lib/components/form/FormRow.svelte";
	import Button from "$lib/components/Button.svelte";
	import { Spinner } from "$lib/components/ui/spinner";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";

	let { data }: { data: PageData } = $props();

	let creating = $state(false);

	const form = superForm(data.form, {
		validators: zodClient(signupFormSchema),
	});

	const { form: formData } = form;
</script>

<SubHeader>
	<SubHeaderTitle title="sign up" />
</SubHeader>

<div>
	<SectionHeading>create account</SectionHeading>

	<div>
		<form
			class="flex flex-col gap-3"
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
			<FormField
				{form}
				name="name"
				autocomplete="name"
				label="name"
				description="Display name visible to others"
				bind:value={$formData.name}
			/>
			<FormField
				{form}
				name="email"
				autocomplete="email"
				label="e-mail"
				bind:value={$formData.email}
			/>
			<FormField
				{form}
				name="password"
				autocomplete="new-password"
				label="password"
				type="password"
				bind:value={$formData.password}
			/>
			<FormRow>
				<Button type="submit" disabled={creating} class="self-start">
					{#if creating}
						<Spinner />
					{/if}
					create account
				</Button>
			</FormRow>
		</form>
	</div>
</div>
