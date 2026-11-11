<script lang="ts">
	import { enhance } from "$app/forms";
	import * as Card from "$lib/components/ui/card/index.js";
	import type { Post } from "$lib/api_calls/types";
	import MarkedDownPost from "$lib/components/posts/MarkedDownPost.svelte";
	import TruncatedContent from "$lib/components/posts/TruncatedContent.svelte";
	import { NotebookPen } from "@lucide/svelte";

	interface Props {
		feed_item: Post;
		truncate?: boolean;
		in_feed?: boolean;
	}

	let { feed_item, truncate = true, in_feed = false }: Props = $props();

	if (feed_item.class_name !== "Post") {
		console.error("not a post feed item");
	}
</script>

<div>
	<div>
		<div class="py-1">
			<a href="/posts/{feed_item.id}">
				<Card.Root
					class="{in_feed
						? 'border-0 shadow-none'
						: 'border-orange-500'} hover:bg-orange-100 dark:hover:bg-orange-900 dark:bg-gray-900 dark:text-gray-200"
				>
					{#if feed_item.title}
						<Card.Header class="px-3 pt-2">
							<Card.Title class="flex flex-row items-center gap-2">
								{#if in_feed}
									<NotebookPen class="size-5 shrink-0 text-orange-500" />
								{/if}
								{feed_item.title}
							</Card.Title>
						</Card.Header>
					{/if}

					<Card.Content class="px-3 py-1 flex flex-row gap-2">
						{#if in_feed && !feed_item.title}
							<NotebookPen class="size-5 shrink-0 mt-1 text-orange-500" />
						{/if}
						{#if feed_item.content}
							<div class="min-w-0 flex-1">
								<TruncatedContent text={feed_item.content} enabled={truncate}>
									<MarkedDownPost captured_text={feed_item.content} />
								</TruncatedContent>
							</div>
						{/if}
					</Card.Content>
				</Card.Root>
			</a>
		</div>
	</div>
</div>
