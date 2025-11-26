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
	import MarkedDownPost from "$lib/components/posts/MarkedDownPost.svelte";

	let { data, form } = $props();

	let creating = $state(false);

	let rendered = $state(form?.content);
	let captured_text = $state("");
	let marked_text = $derived(marked(captured_text));

	let timer: number;
	const debounce = (v: string) => {
		clearTimeout(timer);
		timer = setTimeout(() => {
			captured_text = v;
		}, 750);
	};

	let searching_user = $state(false);

	const usersearch = (e: KeyboardEvent) => {
		if (e.key === "@") {
			searching_user = true;
		}
		if (e.key === "Escape") {
			// TODO: no escape key on mobile lol
			searching_user = false;
		}
		if (!searching_user) {
			return;
		}
		const target = e.target as HTMLTextAreaElement;

		// wait for the keypress to modify the text
		setTimeout(() => {
			const whole_text = target.value;
			// call backend
			const pos = target.selectionStart;
			// walk backwards until the @ or space
			const last_at = whole_text.lastIndexOf("@", pos);

			const searchstring = whole_text.substring(last_at + 1, pos);
			console.log(searchstring);
		}, 0);

		// call the backend, and return some users

		const users = [{ name: "sarah", id: "2a3e5720-27a5-493b-adfd-dd4b99afd4d9" }];

		// hover box with options I can tab throough and select with enter
		// but also escape out
		// or just keep typing
		// or just click on the user

		//target.value = searchstring.replace(`@${username}`, `[${username}](/users/${username})`);
	};
</script>

<div>
	<H1>Create a post</H1>

	{#if creating}
		<p>creating post...</p>
	{/if}
	<div class="lg:grid lg:grid-cols-2 lg:gap-4">
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
							on:keydown={usersearch}
							on:keyup={({ target: { value } }) => debounce(value)}
							class="h-80"
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
			<Card>
				<MarkedDownPost {captured_text} />
			</Card>
		</div>
	</div>
</div>
