<script lang="ts">
	import Link from "$lib/components/text/Link.svelte";
	import { parseAbsoluteToLocal } from "@internationalized/date";
	import MarkedDownPost from "$lib/components/posts/MarkedDownPost.svelte";
	import FriendshipBadge from "$lib/components/ui/badge/FriendshipBadge.svelte";
	import TruncatedContent from "$lib/components/posts/TruncatedContent.svelte";
	import { current_user } from "$lib/state/current_user.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import { X } from "@lucide/svelte";

	// ondelete is called with the comment id after it is successfully deleted
	const { comment, truncate = false, ondelete = undefined } = $props();

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
			{#if is_mine && ondelete}
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
	</article>
</div>
