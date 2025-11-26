<script lang="ts">
	import { enhance } from "$app/forms";
	import { goto } from "$app/navigation";
	import * as Form from "$lib/components/ui/form";
	import { type SuperValidated, type Infer, superForm } from "sveltekit-superforms";
	import { zodClient } from "sveltekit-superforms/adapters";
	import { Input } from "$lib/components/ui/input";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { type PostFormSchema, postFormSchema } from "./schema";
	import { Button } from "$lib/components/ui/button/index.js";
	import * as Card from "$lib/components/ui/card/index.js";
	import { Textarea } from "$lib/components/ui/textarea/index.js";
	import MarkedDownPost from "$lib/components/posts/MarkedDownPost.svelte";
	import H1 from "$lib/components/text/H1.svelte";

	let { data }: { data: { form: SuperValidated<Infer<PostFormSchema>>; event: any } } = $props();
	const form = superForm(data.form, {
		validators: zodClient(postFormSchema),
	});
	const { form: formData } = form;

	let creating = $state(false);
	let rendering = $state(false);

	let captured_text = $state("");

	let timer: number;
	const debounce = (v: string) => {
		rendering = true;
		clearTimeout(timer);
		timer = setTimeout(() => {
			captured_text = v;
			rendering = false;
		}, 500);
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
	<div class="md:grid md:grid-cols-2 md:gap-4">
		<div class="md:order-last">
			<Card.Root>
				<Card.Header>
					<Card.Title>Preview</Card.Title>
					<Card.Description>
						{#if rendering}
							<p>pause typing to render...</p>
						{/if}
					</Card.Description>
				</Card.Header>
				<Card.Content>
					<MarkedDownPost {captured_text} />
				</Card.Content>
			</Card.Root>
		</div>
		<div>
			<Card.Root>
				<Card.Header>
					<Card.Title>Create a post</Card.Title>
					<Card.Description>writing to your friends builds community</Card.Description>
				</Card.Header>
				<Card.Content>
					{#if creating}
						<p>creating...</p>
					{/if}
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
									newToast("You have successfully created a post!!");
									goto("/posts");
								} else {
									newToast("Error creating post: " + res.message, ToastType.Error);
								}
							};
						}}
					>
						<Form.Field {form} name="content">
							<Form.Control let:attrs>
								<Form.Label>Content</Form.Label>
								<Textarea
									{...attrs}
									bind:value={$formData.content}
									on:keydown={usersearch}
									on:keyup={({ target: { value } }) => debounce(value)}
									class="h-80"
								/>
							</Form.Control>
						</Form.Field>

						<Form.Field {form} name="id">
							<input hidden value={$formData.id} name="id" />
						</Form.Field>
						<div class="pt-4">
							<Form.Button>Submit</Form.Button>
						</div>
					</form>
				</Card.Content>
			</Card.Root>
		</div>
	</div>
</div>
