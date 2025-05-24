<script lang="ts">
	import { enhance } from "$app/forms";
	import Input from "$lib/components/form/Input.svelte";
	import InputCheckbox from "$lib/components/form/InputCheckbox.svelte";
	import FormButton from "$lib/components/form/FormButton.svelte";
	import H1 from "$lib/components/text/H1.svelte";
	import Link from "$lib/components/text/Link.svelte";
	import ToggleButton from "$lib/components/form/ToggleButton.svelte";
	import Card from "$lib/components/Card.svelte";
	import LinkButton from "$lib/components/text/LinkButton.svelte";

	import { RecommendationStatus } from "$lib/enums";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import { goto } from "$app/navigation";

	let { data, form } = $props();

	let creating = $state(false);

	let post = data.post;

	// TODO:
	// List of types, one can be selected
	// One selected: interested, watching, recommend
	// who recommended appears if interested
	// rating appears if recommend or watching
</script>

<div>
	<H1>Edit your post</H1>

	{#if creating}
		<p>creating post...</p>
	{/if}
	<Card>
		<form
			method="POST"
			action="?/update_post"
			use:enhance={() => {
				creating = true;
				return async ({ update, result }) => {
					await update();
					creating = false;
					let res = result.data;
					if (res.success) {
						newToast("You have successfully updated a post!!!!");
						goto("/posts");
					} else {
						newToast("Error updating a post: " + res.message, ToastType.Error);
					}
				};
			}}
		>
			<div class="flex flex-col">
				<input type="hidden" name="post_id" value={post.id} />
				<!--            <InputCheckbox name="recommendation_only" label="Don't post publicly, just save for me (TODO: not implemented):" />-->
				<Input name="post_title" label="Post Title:" value={form?.post_title ?? post.post_title} />
				<Input name="content" label="Content" value={form?.content ?? post.content} />
			</div>
			<FormButton>Update post</FormButton>
		</form>
	</Card>
</div>
