<script lang="ts">
	import { enhance } from "$app/forms";
	import { Button } from "$lib/components/ui/button";
	import { Textarea } from "$lib/components/ui/textarea";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import { MessageCirclePlus } from "@lucide/svelte";
	import type { Comment, Feedable } from "$lib/api_calls/types";

	interface Props {
		feed_item: Feedable;
		update_comments: (comments: Comment[]) => void;
	}

	let { feed_item, update_comments }: Props = $props();

	let posting = $state(false);
</script>

<div class="mt-2">
	{#if posting}
		...posting
	{/if}
	<form
		method="POST"
		action="/posts?/submit_comment"
		use:enhance={({ formElement }) => {
			posting = true;
			return async ({ result }) => {
				posting = false;
				const res = result.type === "success" ? (result.data as any) : undefined;
				if (res?.success) {
					formElement.reset();
					update_comments(res.res);
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
		<Textarea name="body" placeholder="I was thinking..." />
		<div class="flex justify-center pt-2">
			<Button type="submit" disabled={posting}>
				<MessageCirclePlus /> &nbsp; Submit Comment
			</Button>
		</div>
	</form>
</div>
