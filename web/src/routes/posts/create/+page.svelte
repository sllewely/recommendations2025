<script lang="ts">
	import { enhance } from "$app/forms";
	import Input from "$lib/components/form/Input.svelte";
	import FormButton from "$lib/components/form/FormButton.svelte";
	import H1 from "$lib/components/text/H1.svelte";
	import Card from "$lib/components/Card.svelte";
	import { Textarea } from "$lib/components/ui/textarea/index.js";
	import { marked } from "marked";

	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { goto } from "$app/navigation";

	let { data, form } = $props();

	let creating = $state(false);

	let rendered = $state(form?.content);
	let captured_text = $state("");
	let marked_text = $derived(marked(captured_text));

	let timer: number;
	const debounce = (v: string) => {
		console.log(v);
		clearTimeout(timer);
		timer = setTimeout(() => {
			captured_text = v;
		}, 750);
	};
</script>

<div>
	<H1>Create a post</H1>

	{#if creating}
		<p>creating post...</p>
	{/if}
	<div class="grid grid-cols-2 gap-4">
		<div class="">
			<Card>
				<form
					method="POST"
					action="?/create_post"
					use:enhance={() => {
						creating = true;
						return async ({ update, result }) => {
							await update();
							creating = false;
							let res = result.data;
							if (res.success) {
								newToast("You have successfully created a post!!!!");
								goto("/posts");
							} else {
								newToast("Error creating a post: " + res.message, ToastType.Error);
							}
						};
					}}
				>
					<div class="flex flex-col pb-4">
						<Input name="title" label="Title:" value={form?.title} />

						<Textarea
							name="content"
							bind:value={rendered}
							on:keyup={({ target: { value } }) => debounce(value)}
						/>
					</div>
					<FormButton>Create post</FormButton>
				</form>
			</Card>
		</div>
		<div>
			<Card>
				{rendered}
			</Card>
			<Card>{@html marked_text}</Card>
		</div>
	</div>
</div>
