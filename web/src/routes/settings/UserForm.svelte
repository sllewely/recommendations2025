<script lang="ts">
	import { enhance } from "$app/forms";
	import { Input } from "$lib/components/ui/input";
	import { profileFormSchema, type FormSchema } from "./schema";
	import { type SuperValidated, type Infer, superForm } from "sveltekit-superforms";
	import { zodClient } from "sveltekit-superforms/adapters";
	import { Badge } from "$lib/components/ui/badge";
	import FormButton from "$lib/components/form/FormButton.svelte";
	import H1 from "$lib/components/text/H1.svelte";
	import { Label } from "$lib/components/ui/label";
	import { Textarea } from "$lib/components/ui/textarea";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import * as Tabs from "$lib/components/ui/tabs";
	import * as Card from "$lib/components/ui/card";
	import { Button } from "$lib/components/ui/button";
	import { Field, Control, Description } from "formsnap";
	import FormLabel from "$lib/components/form/FormLabel.svelte";
	import FormFieldErrors from "$lib/components/form/FormFieldErrors.svelte";

	interface Props {
		form_data: SuperValidated<Infer<FormSchema>>;
		tags: string[];
	}

	let { form_data, tags }: Props = $props();

	const form = superForm(form_data, {
		validators: zodClient(profileFormSchema),
	});

	const { form: formData } = form;

	let creating = $state(false);
	let edit_password = $state(false);
</script>

{#if creating}
	<p>creating...</p>
{/if}

<form
	id="user_form"
	method="POST"
	action="?/update_user"
	use:enhance={() => {
		creating = true;
		return async ({ update, result }) => {
			await update();
			creating = false;
			let res = result.data;
			if (res.success) {
				newToast("You have successfully updated your user");
			} else {
				newToast("Error updating " + res.message, ToastType.Error);
			}
		};
	}}
>
	<Tabs.Root value="profile" class="">
		<Tabs.List class="grid w-full grid-cols-2">
			<Tabs.Trigger value="profile">Profile</Tabs.Trigger>
			<Tabs.Trigger value="account">Account</Tabs.Trigger>
		</Tabs.List>
		<Tabs.Content value="profile">
			<Card.Root>
				<Card.Header>
					<H1>Edit your profile</H1>
				</Card.Header>
				<Card.Content>
					<Field {form} name="name">
						<Control>
							{#snippet children({ props })}
								<FormLabel>Name</FormLabel>
								<Input {...props} bind:value={$formData.name} />
							{/snippet}
						</Control>
						<Description>This is your public display name.</Description>
						<FormFieldErrors />
					</Field>

					<Field {form} name="blurb">
						<Control>
							{#snippet children({ props })}
								<FormLabel>Blurb</FormLabel>
								<Textarea {...props} bind:value={$formData.blurb} />
							{/snippet}
						</Control>
						<Description>Help people find you :)</Description>
						<FormFieldErrors />
					</Field>

					<Field {form} name="string_tags">
						<Control>
							{#snippet children({ props })}
								<FormLabel>Tags</FormLabel>
								<Input {...props} bind:value={$formData.string_tags} />
							{/snippet}
						</Control>
						<Description
							>To help people search for you. @xamples are the name of your town, college, or friend
							group
						</Description>
						<FormFieldErrors />
					</Field>
					<div class="space-x-2 mb-4">
						{#each tags as tag}
							<Badge>{tag}</Badge>
						{/each}
					</div>

					<div class="flex flex-col space-y-2">
						<Button type="submit">Update</Button>
					</div>
				</Card.Content>
			</Card.Root>
		</Tabs.Content>
		<Tabs.Content value="account">
			<Card.Root>
				<Card.Header>
					<H1>Edit your account details</H1>
				</Card.Header>
				<Card.Content>
					<Field {form} name="email">
						<Control>
							{#snippet children({ props })}
								<FormLabel>Email</FormLabel>
								<Input {...props} bind:value={$formData.email} />
							{/snippet}
						</Control>
						<Description>Your account email.</Description>
						<FormFieldErrors />
					</Field>
					<Button
						type="button"
						onclick={() => {
							edit_password = !edit_password;
						}}
						>Edit password
					</Button>
					{#if edit_password}
						<Field {form} name="password">
							<Control>
								{#snippet children({ props })}
									<FormLabel>Set password</FormLabel>
									<Input type="password" {...props} bind:value={$formData.password} />
								{/snippet}
							</Control>
							<Description>Overwrite your old password</Description>
							<FormFieldErrors />
						</Field>
					{/if}

					<div class="flex flex-col mt-4">
						<Button type="submit">Update</Button>
					</div>
				</Card.Content>
			</Card.Root>
		</Tabs.Content>
	</Tabs.Root>
</form>
