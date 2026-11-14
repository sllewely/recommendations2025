<script lang="ts">
	import { enhance } from "$app/forms";
	import { goto } from "$app/navigation";
	import { type SuperValidated, type Infer, superForm } from "sveltekit-superforms";
	import { zodClient } from "sveltekit-superforms/adapters";
	import { newToast, ToastType } from "$lib/state/toast.svelte.js";
	import { type PostFormSchema, postFormSchema } from "./schema";
	import Button from "$lib/components/Button.svelte";
	import TextField from "$lib/components/TextField.svelte";
	import MarkedDownPost from "$lib/components/posts/MarkedDownPost.svelte";
	import { CARD } from "$lib/components/posts/FeedBadge.svelte";
	import { cn } from "$lib/utils.js";
	import FormField from "$lib/components/form/FormField.svelte";
	import FormRow from "$lib/components/form/FormRow.svelte";
	import SharingPrivacy from "$lib/components/form/SharingPrivacy.svelte";
	import type { PickedPerson } from "$lib/components/users/PeoplePicker.svelte";
	import type { ApiResponse, Post } from "$lib/api_calls/types";
	import { Spinner } from "$lib/components/ui/spinner";
	import UserCard from "$lib/components/users/UserCard.svelte";

	let {
		data,
	}: {
		data: { form: SuperValidated<Infer<PostFormSchema>>; post_response?: ApiResponse<Post> };
	} = $props();
	const form = superForm(data.form, {
		validators: zodClient(postFormSchema),
	});
	const { form: formData } = form;

	let creating = $state(false);
	// prefill the audience when editing an existing post
	let audience = $state<PickedPerson[]>(data.post_response?.res?.audience ?? []);
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

<form
	method="POST"
	action="?/create_post"
	class="flex flex-col gap-3"
	use:enhance={() => {
		creating = true;
		return async ({ update, result }) => {
			await update();
			creating = false;
			let res = result.data;
			if (res.success) {
				newToast("You have successfully created a post!!");
				goto("/");
			} else {
				newToast("Error creating post: " + res.message, ToastType.Error);
			}
		};
	}}
>
	<section aria-label="preview" class={cn("mb-7 flex flex-col gap-5", CARD)}>
		{#if $formData.content?.trim()}
			<MarkedDownPost captured_text={$formData.content} />
		{:else}
			<p class="italic text-zinc-500 dark:text-zinc-400">your post will show up here</p>
		{/if}
	</section>

	<FormField {form} name="content" label="content" bind:value={$formData.content}>
		{#snippet control({ props })}
			<div class="relative">
				{#if user_search_results.length > 0}
					<!-- @mention suggestions; Tab picks the first -->
					<div
						class="absolute top-full left-2.5 z-20 mt-1 flex flex-col gap-1 border border-dashed border-zinc-500 bg-zinc-100 p-3 dark:border-zinc-400 dark:bg-zinc-800"
					>
						{#each user_search_results as user}
							<UserCard {user} size="xs" static />
						{/each}
					</div>
				{/if}
				<TextField
					{...props}
					multiline
					bind:value={$formData.content}
					onkeydown={usersearch}
					placeholder="write your post here... (markdown supported)"
					class="min-h-40"
				/>
			</div>
		{/snippet}
	</FormField>

	<input hidden value={$formData.id} name="id" />

	<SharingPrivacy bind:value={$formData.privacy} bind:audience />

	<FormRow>
		<Button type="submit" disabled={creating} class="self-start">
			{#if creating}
				<Spinner />
			{/if}
			{$formData.id ? "save" : "post"}
		</Button>
	</FormRow>
</form>
