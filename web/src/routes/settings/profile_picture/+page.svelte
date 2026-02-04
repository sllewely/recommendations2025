<script lang="ts">
	import * as Form from "$lib/components/ui/form";
	import { Spinner } from "$lib/components/ui/spinner/index.js";
	import { onMount } from "svelte";
	import type { User } from "$lib/api_calls/types";

	interface Props {
		data: {
			user: User;
		};
	}

	let { data }: Props = $props();

	let upload_url = $state("");
	let img_blob: Blob | null = $state(null);

	let uploading = $state(false);
	let upload_response = $state("");

	onMount(async () => {
		const upload_url_response = await fetch(`/api/images/presigned_upload_url`, {
			method: "GET",
			headers: { "Content-Type": "application/json" },
		});
		const res = await upload_url_response.json();
		upload_url = res.url;
		console.log("uploadurl", JSON.stringify(upload_url));

		if (data.user.profile_photo_url) {
			const cloudflare_get_url = await fetch(data.user.presigned_url, {
				method: "GET",
			});
			img_blob = await cloudflare_get_url.blob();
		}
	});

	let files = $state();

	$effect(() => {
		if (files) {
			console.log(files);

			for (const file of files) {
				console.log(`${file.name}: ${file.size} bytes`);
			}
		}
	});

	const submitUpload = async () => {
		uploading = true;
		console.log(files[0]);
		let res = await fetch(upload_url, {
			method: "PUT",
			body: files[0],
		});
		upload_response = await res.text();
		console.log("upload response", res);
		// gen new presigned url
		const response = await fetch("/api/images/update_profile_url", {
			method: "POST",
			headers: {
				"Content-Type": "application/json",
			},
		});
		const json = await response.json();
		if (json["errors"]) {
		} else {
			console.log("update profile pic", json);
		}
		uploading = false;
	};
</script>

<div>
	<div>
		{#if img_blob}
			(old image:)
			<img src={URL.createObjectURL(img_blob)} />
		{/if}
	</div>
	<form id="user_form" enctype="multipart/form-data">
		<input
			accept="image/png, image/jpeg"
			bind:files
			id="avatar"
			name="avatar"
			type="file"
			class="bg-lime-500 rounded-sm m-2 p-2"
		/>

		{#if files}
			<h2>Selected files:</h2>
			{#each Array.from(files) as file}
				<p>{file.name} ({file.size} bytes)</p>
			{/each}
		{/if}

		<div class="flex flex-col space-y-2">
			<Form.Button onclick={submitUpload} disabled={uploading ? "true" : undefined}>
				{#if uploading}
					<Spinner />
					Uploading...
				{:else}
					Update
				{/if}
			</Form.Button>
		</div>
	</form>
	<div>
		<div>debug info:</div>
		<div>{upload_response}</div>
	</div>
</div>
