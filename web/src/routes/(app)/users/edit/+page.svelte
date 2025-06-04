<script lang="ts">
	import H1 from "$lib/components/text/H1.svelte";
	import UserForm from "./UserForm.svelte";
	import { goto } from "$app/navigation";

	let { data, form } = $props();
	let user = data.user;

	let tags = $state(user.tags);
	$effect(() => {
		tags = data.user.tags;
	});

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
	<p>#TODO page needs a fun background!!</p>
	<H1>{user.name}</H1>

	<div>
		<img
			class="upload"
			src="https://static.thenounproject.com/png/625182-200.png"
			alt=""
			on:click={() => {
				fileinput.click();
			}}
		/>
		<div
			class="chan"
			on:click={() => {
				fileinput.click();
			}}
		>
			Choose Image
		</div>
		<input
			style="display:none"
			type="file"
			accept=".jpg, .jpeg, .png"
			on:change={(e) => onFileSelected(e)}
			bind:this={fileinput}
		/>
	</div>

	<div>
		<UserForm form_data={data.form} {tags} />
	</div>
</div>
