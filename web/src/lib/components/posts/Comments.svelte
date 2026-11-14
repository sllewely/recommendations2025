<script lang="ts">
	import { onMount } from "svelte";
	import { enhance } from "$app/forms";
	import type { Comment, Post, Event, Recommendation } from "$lib/api_calls/types";
	import { isSignedIn } from "$lib/state/current_user.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import { formatWhen } from "$lib/format_date";
	import Button from "$lib/components/Button.svelte";
	import TextField from "$lib/components/TextField.svelte";
	import CommentItem from "$lib/components/posts/Comment.svelte";

	interface Props {
		feed_item: Post | Event | Recommendation;
		comments: Comment[];
		offset?: boolean;
	}

	let { feed_item, comments = $bindable([]), offset = true }: Props = $props();

	let signed_in = $derived(isSignedIn());
	let posting = $state(false);

	let mounted = $state(false);
	onMount(() => {
		mounted = true;
	});
</script>

<div class="flex flex-col gap-2">
	{#if signed_in}
		<form
			class="mb-1"
			method="POST"
			action="/posts?/submit_comment"
			use:enhance={({ formElement }) => {
				posting = true;
				return async ({ result }) => {
					posting = false;
					const res = result.type === "success" ? (result.data as any) : undefined;
					if (res?.success) {
						formElement.reset();
						comments = res.res;
						newToast("You have successfully created a comment ~~!", ToastType.Success);
					} else if (result.type === "redirect") {
						window.location.href = result.location;
					} else {
						const message =
							res?.message ?? (result.type === "error" ? result.error?.message : undefined);
						newToast("Error creating a comment: " + (message ?? "unknown error"), ToastType.Error);
					}
				};
			}}
		>
			<input type="hidden" name="commentable_id" value={feed_item.id} />
			<input type="hidden" name="commentable_type" value={feed_item.class_name} />
			<div class="flex flex-row items-end gap-2.5">
				<TextField
					multiline
					rows={1}
					name="body"
					placeholder="I was thinking..."
					class="min-h-0 flex-1"
				/>
				<Button type="submit" disabled={posting} class="shrink-0">
					{posting ? "posting..." : "comment"}
				</Button>
			</div>
		</form>
	{/if}

	{#each comments as comment}
		<CommentItem
			user={comment.user!}
			body={comment.body}
			caption="on {mounted ? formatWhen(comment.created_at) : ''}"
			{offset}
		/>
	{:else}
		{#if !signed_in}
			<span class="text-sm text-zinc-500 dark:text-zinc-400">no comments yet</span>
		{/if}
	{/each}
</div>
