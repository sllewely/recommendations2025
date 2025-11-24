<script lang="ts">
	import { enhance } from "$app/forms";
	import * as Form from "$lib/components/ui/form";
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
					<Form.Field {form} name="name">
						<Form.Control let:attrs>
							<Form.Label>Name</Form.Label>
							<Input {...attrs} bind:value={$formData.name} />
						</Form.Control>
						<Form.Description>This is your public display name.</Form.Description>
						<Form.FieldErrors />
					</Form.Field>

					<Form.Field {form} name="blurb">
						<Form.Control let:attrs>
							<Form.Label>Blurb</Form.Label>
							<Textarea {...attrs} bind:value={$formData.blurb} />
						</Form.Control>
						<Form.Description>Help people find you :)</Form.Description>
						<Form.FieldErrors />
					</Form.Field>

					<Form.Field {form} name="string_tags">
						<Form.Control let:attrs>
							<Form.Label>Tags</Form.Label>
							<Input {...attrs} bind:value={$formData.string_tags} />
						</Form.Control>
						<Form.Description
							>To help people search for you. @xamples are the name of your town, college, or friend
							group
						</Form.Description>
						<Form.FieldErrors />
					</Form.Field>
					<div class="space-x-2 mb-4">
						{#each tags as tag}
							<Badge>{tag.tag}</Badge>
						{/each}
					</div>

					<div class="flex flex-col space-y-2">
						<Form.Button
							on:click={() => {
								console.log("click!!");
							}}
						>
							Update
						</Form.Button>
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
					<Form.Field {form} name="email">
						<Form.Control let:attrs>
							<Form.Label>Email</Form.Label>
							<Input {...attrs} bind:value={$formData.email} />
						</Form.Control>
						<Form.Description>Your account email.</Form.Description>
						<Form.FieldErrors />
					</Form.Field>
					<Button type="button" on:click={(edit_password = !edit_password)}>Edit password</Button>
					{#if edit_password}
						<Form.Field {form} name="password">
							<Form.Control let:attrs>
								<Form.Label>Set password</Form.Label>
								<Input type="password" {...attrs} bind:value={$formData.password} />
							</Form.Control>
							<Form.Description>Overwrite your old password</Form.Description>
							<Form.FieldErrors />
						</Form.Field>
					{/if}

					<div class="flex flex-col mt-4">
						<Form.Button>Update</Form.Button>
					</div>
				</Card.Content>
			</Card.Root>
		</Tabs.Content>
	</Tabs.Root>
</form>
