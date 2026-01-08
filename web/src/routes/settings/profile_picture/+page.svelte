<script lang="ts">
	import * as Form from "$lib/components/ui/form";
	import { onMount } from "svelte";

	let upload_url = $state("");
	let img_blob = $state("");

	onMount(async () => {
		const upload_url_response = await fetch(`/api/images/presigned_upload_url`, {
			method: "GET",
			headers: { "Content-Type": "application/json" },
		});
		const res = await upload_url_response.json();
		upload_url = res.url;
		console.log("uploadurl", JSON.stringify(upload_url));

		const retrieve_file_response = await fetch(`/api/images/presigned_get_url`, {
			method: "GET",
			headers: { "Content-Type": "application/json" },
		});
		const res2 = await retrieve_file_response.json();
		const get_url = res2.url;
		console.log("geturl", JSON.stringify(res2));

		const cloudflare_get_url = await fetch(get_url, {
			method: "GET",
		});
		img_blob = await cloudflare_get_url.blob();
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
</script>

<div>
	<form id="user_form" enctype="multipart/form-data">
		<input accept="image/png, image/jpeg" bind:files id="avatar" name="avatar" type="file" />

		{#if files}
			<h2>Selected files:</h2>
			{#each Array.from(files) as file}
				<p>{file.name} ({file.size} bytes)</p>
			{/each}
		{/if}

		<div class="flex flex-col space-y-2">
			<Form.Button
				onclick={async () => {
					console.log(files[0]);
					await fetch(upload_url, {
						method: "PUT",
						body: files[0],
					});
				}}
			>
				Update
			</Form.Button>
		</div>
	</form>
	<div>
		{#if img_blob}
			<img src={URL.createObjectURL(img_blob)} />
		{/if}
	</div>
</div>
