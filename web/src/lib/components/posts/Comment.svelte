<script lang="ts">
	import Link from "$lib/components/text/Link.svelte";
	import { parseAbsoluteToLocal } from "@internationalized/date";
	import MarkedDownPost from "$lib/components/posts/MarkedDownPost.svelte";
	import FriendshipBadge from "$lib/components/ui/badge/FriendshipBadge.svelte";
	import TruncatedContent from "$lib/components/posts/TruncatedContent.svelte";
	import { current_user } from "$lib/state/current_user.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import { Pencil, X } from "@lucide/svelte";
	import { Textarea } from "$lib/components/ui/textarea";
	import { Button } from "$lib/components/ui/button";
	import Reactions from "$lib/components/reactions/Reactions.svelte";

	// ondelete is called with the comment id after it is successfully deleted
	// onupdate is called with the updated comment after it is successfully saved
	const { comment, truncate = false, ondelete = undefined, onupdate = undefined } = $props();

	const is_mine = $derived(String(current_user.id) === String(comment.user_id ?? comment.user?.id));

	let confirming = $state(false);
	let deleting = $state(false);

	const delete_comment = async () => {
		deleting = true;
		const response = await fetch("/api/comments/delete", {
			method: "POST",
			body: JSON.stringify({ id: comment.id }),
			headers: {
				"Content-Type": "application/json",
			},
		});
		const res = await response.json();
		deleting = false;
		confirming = false;
		if (res.success) {
			newToast("Deleted comment", ToastType.Success);
			ondelete?.(comment.id);
		} else {
			newToast("Error deleting comment: " + res.message, ToastType.Error);
		}
	};

	let editing = $state(false);
	let saving = $state(false);
	let draft = $state("");

	const start_editing = () => {
		draft = comment.body;
		editing = true;
	};

	const save_comment = async () => {
		saving = true;
		const response = await fetch("/api/comments/update", {
			method: "POST",
			body: JSON.stringify({ id: comment.id, body: draft }),
			headers: {
				"Content-Type": "application/json",
			},
		});
		const res = await response.json();
		saving = false;
		if (res.success) {
			editing = false;
			newToast("Updated comment", ToastType.Success);
			onupdate?.({ ...comment, body: res.res.body });
		} else {
			newToast("Error updating comment: " + res.message, ToastType.Error);
		}
	};

	const localizedCreateTime = parseAbsoluteToLocal(comment.created_at);
	const formattedCreateTime = new Intl.DateTimeFormat("en-US", {
		dateStyle: "medium",
		timeStyle: "short",
		timeZone: localizedCreateTime.timeZone,
	}).format(localizedCreateTime.toDate());
</script>

<div class="flex justify-left">
	<article class="w-full px-2 py-1 text-base bg-white rounded-lg dark:bg-gray-900">
		<div class="flex justify-between items-center">
			<div class="flex items-center gap-2">
				<p
					class="inline-flex items-center mr-1 text-sm text-gray-900 dark:text-white font-semibold"
				>
					<Link url="/users/{comment.user.id}">{comment.user.name}</Link>
				</p>
				{#if comment.user?.friendship_status}
					<FriendshipBadge status={comment.user.friendship_status} />
				{/if}
				<p class="text-sm text-gray-600 dark:text-gray-400">
					{formattedCreateTime}
				</p>
			</div>
			{#if is_mine && ondelete && onupdate && !editing}
				<div class="flex items-center gap-1 ml-auto pl-2 text-xs">
					{#if confirming}
						<span class="text-gray-600 dark:text-gray-400">Delete?</span>
						<button
							class="text-red-600 hover:underline disabled:opacity-50"
							disabled={deleting}
							onclick={delete_comment}>Yes</button
						>
						<button
							class="text-gray-600 dark:text-gray-400 hover:underline"
							disabled={deleting}
							onclick={() => (confirming = false)}>No</button
						>
					{:else}
						<button
							class="text-gray-400 hover:text-gray-900 dark:hover:text-white"
							aria-label="Edit comment"
							title="Edit comment"
							onclick={start_editing}
						>
							<Pencil size={14} />
						</button>
						<button
							class="text-gray-400 hover:text-red-600"
							aria-label="Delete comment"
							title="Delete comment"
							onclick={() => (confirming = true)}
						>
							<X size={14} />
						</button>
					{/if}
				</div>
			{/if}
		</div>
		{#if editing}
			<div class="pt-1">
				<Textarea bind:value={draft} disabled={saving} />
				<div class="flex justify-end gap-2 pt-1">
					<Button size="sm" variant="outline" disabled={saving} onclick={() => (editing = false)}
						>Cancel</Button
					>
					<Button size="sm" disabled={saving || !draft.trim()} onclick={save_comment}>Save</Button>
				</div>
			</div>
		{:else}
			<div class="text-left">
				<div class="text-gray-500 dark:text-gray-400">
					<!-- ~2 lines: two 1.5rem lines plus the paragraph's top margin -->
					<TruncatedContent
						text={comment.body}
						enabled={truncate}
						thresholdLength={120}
						thresholdLines={2}
						collapsedClass="max-h-[3.25rem]"
						buttonClass="text-xs leading-none"
					>
						<MarkedDownPost captured_text={comment.body} />
					</TruncatedContent>
				</div>
			</div>
		{/if}
		{#if comment.reactions}
			<div class="flex justify-end">
				<Reactions feedable={comment} />
			</div>
		{/if}
	</article>
</div>
