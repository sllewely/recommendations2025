<script lang="ts">
	import Link from "$lib/components/text/Link.svelte";
	import { parseAbsoluteToLocal } from "@internationalized/date";
	import MarkedDownPost from "$lib/components/posts/MarkedDownPost.svelte";
	import FriendshipBadge from "$lib/components/ui/badge/FriendshipBadge.svelte";

	const { comment } = $props();

	const localizedCreateTime = parseAbsoluteToLocal(comment.created_at);
	const formattedCreateTime = new Intl.DateTimeFormat("en-US", {
		dateStyle: "medium",
		timeStyle: "short",
		timeZone: localizedCreateTime.timeZone,
	}).format(localizedCreateTime.toDate());
</script>

<div class="flex justify-left">
	<article class="p-2 text-base bg-white rounded-lg dark:bg-gray-900">
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
				<MarkedDownPost captured_text={comment.body} />
			</div>
		</div>
	</article>
</div>
