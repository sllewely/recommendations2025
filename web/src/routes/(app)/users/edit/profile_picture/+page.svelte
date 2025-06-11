<script lang="ts">
	import { enhance } from "$app/forms";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import { Input } from "$lib/components/ui/input";
	import * as Form from "$lib/components/ui/form";
	import { imageFormSchema, type ImageSchema } from "./schema";
	import { type SuperValidated, type Infer, superForm } from "sveltekit-superforms";
	import { zodClient } from "sveltekit-superforms/adapters";

	interface Props {
		data: { form_data: SuperValidated<Infer<ImageSchema>> };
	}

	let { data }: Props = $props();
	const form = superForm(data.form_data, {
		validators: zodClient(imageFormSchema),
	});
	const { form: formData } = form;

	let creating = $state(false);

	let avatar, fileinput;
	let upload_photo = async (file) => {
		const response = await fetch("/api/upload_profile_picture", {
			method: "POST",
			body: JSON.stringify({ file: file }),
			headers: {
				"Content-Type": "application/json",
			},
		});
	};
	const onFileSelected = (e: Event) => {
		let image = e.target.files[0];
		// let reader = new FileReader();
		// reader.readAsDataURL(image);
		upload_photo(image);
		// reader.onload = (e) => {
		// 	avatar = e.target.result;
		// };
	};
</script>

<div>
	<form
		id="user_form"
		enctype="multipart/form-data"
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
		<Form.Field {form} name="image">
			<Form.Control let:attrs>
				<Form.Label>photo</Form.Label>
				<Input type="file" {...attrs} bind:value={$formData.image} />
			</Form.Control>
			<Form.Description>Upload a profile photo.</Form.Description>
			<Form.FieldErrors />
		</Form.Field>

		<div class="flex flex-col space-y-2">
			<Form.Button
				on:click={() => {
					console.log("click!!");
				}}
			>
				Update
			</Form.Button>
		</div>
	</form>
</div>
