<script lang="ts">
	import { enhance } from "$app/forms";
	import { goto } from "$app/navigation";
	import { type SuperValidated, type Infer, superForm } from "sveltekit-superforms";
	import { zodClient } from "sveltekit-superforms/adapters";
	import { Input } from "$lib/components/ui/input";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { type PostFormSchema, postFormSchema } from "./schema";
	import { Button } from "$lib/components/ui/button/index.js";
	import * as Card from "$lib/components/ui/card/index.js";
	import * as Tabs from "$lib/components/ui/tabs/index.js";
	import { Textarea } from "$lib/components/ui/textarea/index.js";
	import MarkedDownPost from "$lib/components/posts/MarkedDownPost.svelte";
	import H1 from "$lib/components/text/H1.svelte";
	import { Field, Control, Description } from "formsnap";
	import FormLabel from "$lib/components/form/FormLabel.svelte";
	import FormFieldErrors from "$lib/components/form/FormFieldErrors.svelte";
	import { Spinner } from "$lib/components/ui/spinner";
	import bblogo from "$lib/assets/android-launchericon-72-72.png";

	let { data }: { data: { form: SuperValidated<Infer<PostFormSchema>>; event: any } } = $props();
	const form = superForm(data.form, {
		validators: zodClient(postFormSchema),
	});
	const { form: formData } = form;

	let creating = $state(false);
	let user_search_results = $state([]);
	let searching_user = $state(false);

	const usersearch = (e: KeyboardEvent) => {
		if (e.key === "@") {
			searching_user = true;
		}
		if (e.key === "Escape") {
			// TODO: no escape key on mobile lol
			searching_user = false;
			user_search_results = [];
		}
		if (e.key === "Tab") {
			if (searching_user && user_search_results.length > 0) {
				e.preventDefault();
				//insert the uuid
				let uuid = user_search_results[0].id;

				const target = e.target as HTMLTextAreaElement;
				const whole_text = target.value;
				// call backend
				const pos = target.selectionStart;
				// walk backwards until the @ or space
				const last_at = whole_text.lastIndexOf("@", pos);
				target.value =
					whole_text.substring(0, last_at + 1) +
					`[${user_search_results[0].name}](/users/${uuid})` +
					whole_text.substring(pos);
				$formData.content = target.value;
				searching_user = false;
				user_search_results = [];
			}
		}
		if (!searching_user) {
			return;
		}
		const target = e.target as HTMLTextAreaElement;

		// wait for the keypress to modify the text
		setTimeout(async () => {
			const whole_text = target.value;
			// call backend
			const pos = target.selectionStart;
			// walk backwards until the @ or space
			const last_at = whole_text.lastIndexOf("@", pos);

			const searchstring = whole_text.substring(last_at + 1, pos);
			console.log(searchstring);
			const response = await fetch(`/api/friends/search?search=${searchstring}`, {
				method: "GET",
				headers: { "Content-Type": "application/json" },
			});

			user_search_results = await response.json();
		}, 0);
	};
</script>

<div>
	<Card.Root>
		<Card.Header>
			<Card.Title>
				{#if $formData.id}
					Edit post
				{:else}
					Create a post
				{/if}
			</Card.Title>
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
				<Tabs.Root value="write" class="w-full">
					<Tabs.List class="grid w-full grid-cols-2">
						<Tabs.Trigger value="write">Write</Tabs.Trigger>
						<Tabs.Trigger value="preview">Preview Markdown</Tabs.Trigger>
					</Tabs.List>
					<Tabs.Content value="write" class="pt-4">
						<Field {form} name="content">
							<Control>
								{#snippet children({ props })}
									<FormLabel>Content</FormLabel>
									<div style="position:relative">
										{#if user_search_results.length > 0}
											<div style="position:absolute; left: 10px; bottom: -10px; z-index: 20;">
												<Card.Root>
													<Card.Content>
														<div class="flex flex-col gap-1">
															{#each user_search_results as user}
																<div class="flex flex-row items-center gap-2">
																	<div class="rounded-full w-6 h-6 overflow-hidden shrink-0">
																		{#if user.profile_photo_url}
																			<img
																				src={"https://" + user.profile_photo_url}
																				alt="profile picture"
																			/>
																		{:else}
																			<img src={bblogo} alt="profile picture" />
																		{/if}
																	</div>
																	<div>
																		{user.name}
																	</div>
																</div>
															{/each}
														</div>
													</Card.Content>
												</Card.Root>
											</div>
										{/if}
									</div>
									<Textarea
										{...props}
										bind:value={$formData.content}
										onkeydown={usersearch}
										placeholder="Write your post here... (markdown supported)"
										class="h-80"
									/>
								{/snippet}
							</Control>
							<FormFieldErrors />
						</Field>
					</Tabs.Content>
					<Tabs.Content value="preview" class="pt-4">
						<div class="min-h-80 rounded-md border border-input bg-background p-4">
							{#if $formData.content && $formData.content.trim().length > 0}
								<MarkedDownPost captured_text={$formData.content} />
							{:else}
								<p class="text-sm text-muted-foreground italic">Nothing to preview</p>
							{/if}
						</div>
					</Tabs.Content>
				</Tabs.Root>

				<Field {form} name="id">
					<input hidden value={$formData.id} name="id" />
				</Field>
				<div class="pt-4">
					<Button type="submit" disabled={creating}>
						{#if creating}
							<Spinner />
						{/if}
						Submit
					</Button>
				</div>
			</form>
		</Card.Content>
	</Card.Root>
</div>
