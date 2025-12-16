<script lang="ts">
	import { enhance } from "$app/forms";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { Input } from "$lib/components/ui/input";
	import * as Form from "$lib/components/ui/form";
	import { imageFormSchema, type ImageSchema } from "./schema";
	import { type SuperValidated, type Infer, superForm } from "sveltekit-superforms";
	import { zodClient } from "sveltekit-superforms/adapters";
	import { onMount } from "svelte";

	interface Props {
		data: { form_data: SuperValidated<Infer<ImageSchema>> };
	}

	let { data }: Props = $props();
	const form = superForm(data.form_data, {
		validators: zodClient(imageFormSchema),
	});
	const { form: formData } = form;

	let creating = $state(false);

	let upload_url = $state("");

	onMount(async () => {
		const response = await fetch(`/api/images/presigned_upload_url`, {
			method: "GET",
			headers: { "Content-Type": "application/json" },
		});
		upload_url = await response.json();
		console.log("uploadurl", JSON.stringify(upload_url));
	});
</script>

<div>
	{upload_url}

	<!--	<form-->
	<!--		id="user_form"-->
	<!--		enctype="multipart/form-data"-->
	<!--		method="POST"-->
	<!--		action="?/update_user"-->
	<!--		use:enhance={() => {-->
	<!--			creating = true;-->
	<!--			return async ({ update, result }) => {-->
	<!--				await update();-->
	<!--				creating = false;-->
	<!--				// let res = result.data;-->
	<!--				// if (res.success) {-->
	<!--				// 	newToast("You have successfully updated your user");-->
	<!--				// } else {-->
	<!--				// 	newToast("Error updating " + res.message, ToastType.Error);-->
	<!--				// }-->
	<!--			};-->
	<!--		}}-->
	<!--	>-->
	<!--		<Form.Field {form} name="image">-->
	<!--			<Form.Control let:attrs>-->
	<!--				<Form.Label>photo</Form.Label>-->
	<!--				<Input type="file" {...attrs} bind:value={$formData.image} />-->
	<!--			</Form.Control>-->
	<!--			<Form.Description>Upload a profile photo.</Form.Description>-->
	<!--			<Form.FieldErrors />-->
	<!--		</Form.Field>-->

	<!--		<div class="flex flex-col space-y-2">-->
	<!--			<Form.Button-->
	<!--				on:click={() => {-->
	<!--					console.log("click!!");-->
	<!--				}}-->
	<!--			>-->
	<!--				Update-->
	<!--			</Form.Button>-->
	<!--		</div>-->
	<!--	</form>-->
</div>
