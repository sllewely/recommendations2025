<script lang="ts">
	import SubHeader from "$lib/components/SubHeader.svelte";
	import SubHeaderTitle from "$lib/components/SubHeaderTitle.svelte";
	import SectionHeading from "$lib/components/text/SectionHeading.svelte";
	import Link from "$lib/components/text/Link.svelte";
	import type { PageData } from "./$types.js";
	import { enhance } from "$app/forms";
	import { goto } from "$app/navigation";
	import { signinFormSchema } from "./schema";
	import { superForm } from "sveltekit-superforms";
	import { zodClient } from "sveltekit-superforms/adapters";
	import FormField from "$lib/components/form/FormField.svelte";
	import FormRow from "$lib/components/form/FormRow.svelte";
	import Button from "$lib/components/Button.svelte";
	import { Spinner } from "$lib/components/ui/spinner";
	import { current_user } from "$lib/state/current_user.svelte.js";
	import { setPendingToast, newToast, ToastType } from "$lib/state/toast.svelte.js";

	let { data }: { data: PageData } = $props();

	let creating = $state(false);

	const form = superForm(data.form, {
		validators: zodClient(signinFormSchema),
	});

	const { form: formData } = form;
</script>

<SubHeader>
	<SubHeaderTitle title="log in" />
</SubHeader>

<div>
	<SectionHeading>sign in</SectionHeading>
	<Link url="/create_account">Or create an account</Link>

	<div>
		<div>
			<form
				class="flex flex-col gap-3"
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
							goto("/");
						} else {
							if (res.message) {
								newToast("Error signing in: " + res.message, ToastType.Error);
							}
						}
					};
				}}
			>
				<FormField
					{form}
					name="email"
					autocomplete="username"
					label="e-mail"
					bind:value={$formData.email}
				/>
				<FormField
					{form}
					name="password"
					autocomplete="current-password"
					label="password"
					type="password"
					description="Message Sarah if you forgot your password"
					bind:value={$formData.password}
				/>
				<FormRow>
					<Button type="submit" disabled={creating} class="self-start">
						{#if creating}
							<Spinner />
						{/if}
						sign in
					</Button>
				</FormRow>
			</form>
		</div>
	</div>
</div>
