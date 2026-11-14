<script lang="ts">
	import Link from "$lib/components/text/Link.svelte";
	import { parseAbsoluteToLocal } from "@internationalized/date";
	import MarkedDownPost from "$lib/components/posts/MarkedDownPost.svelte";
	import FriendshipBadge from "$lib/components/ui/badge/FriendshipBadge.svelte";
	import TruncatedContent from "$lib/components/posts/TruncatedContent.svelte";

	const { comment, truncate = false } = $props();

	const localizedCreateTime = parseAbsoluteToLocal(comment.created_at);
	const formattedCreateTime = new Intl.DateTimeFormat("en-US", {
		dateStyle: "medium",
		timeStyle: "short",
		timeZone: localizedCreateTime.timeZone,
	}).format(localizedCreateTime.toDate());
</script>

<div class="flex justify-left">
	<article class="px-2 py-1 text-base bg-white rounded-lg dark:bg-gray-900">
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
