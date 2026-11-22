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
			<a href="/posts/{feed_item.id}" class={in_feed ? "card-link" : ""}>
				<Card.Root
					class={in_feed
						? "border-0 bg-transparent shadow-none dark:bg-transparent"
						: "border-orange-500 hover:bg-orange-100 dark:hover:bg-orange-900 dark:bg-gray-900 dark:text-gray-200"}
				>
					{#if feed_item.title}
						<Card.Header class={in_feed ? "p-0 pb-1" : "px-3 pt-2"}>
							<Card.Title
								class="flex flex-row items-center gap-2 {in_feed
									? 'text-lg font-semibold leading-tight'
									: ''}"
							>
								{#if in_feed}
									<NotebookPen class="size-5 shrink-0 text-sky-500 dark:text-sky-300" />
								{/if}
								{feed_item.title}
							</Card.Title>
						</Card.Header>
					{/if}

					<Card.Content class="{in_feed ? 'p-0' : 'px-3 py-1'} flow-root">
						{#if in_feed && !feed_item.title}
							<NotebookPen class="size-5 float-left mr-2 mt-1.5 text-sky-500 dark:text-sky-300" />
						{/if}
						{#if feed_item.content}
							<!-- ~6 lines: six 1.5rem lines plus the paragraph's top margin -->
							<TruncatedContent
								text={feed_item.content}
								enabled={truncate}
								thresholdLength={400}
								thresholdLines={6}
								collapsedClass="max-h-[9.25rem]"
								buttonClass="text-xs leading-none"
							>
								<MarkedDownPost captured_text={feed_item.content} />
							</TruncatedContent>
						{/if}
					</Card.Content>
				</Card.Root>
			</a>
		</div>
	</div>
</div>
