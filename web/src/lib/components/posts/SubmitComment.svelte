<script lang="ts">
	import { enhance } from "$app/forms";
	import Button from "$lib/components/Button.svelte";
	import TextField from "$lib/components/TextField.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import type { Comment, Feedable } from "$lib/api_calls/types";

	interface Props {
		feed_item: Feedable;
		update_comments: (comments: Comment[]) => void;
	}

	let { feed_item, update_comments }: Props = $props();

	let posting = $state(false);
</script>

<div class="mt-2">
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
</div>
