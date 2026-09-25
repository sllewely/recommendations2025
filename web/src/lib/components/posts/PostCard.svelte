<script lang="ts">
	import { enhance } from "$app/forms";
	import * as Card from "$lib/components/ui/card/index.js";
	import type { Post } from "$lib/api_calls/types";
	import MarkedDownPost from "$lib/components/posts/MarkedDownPost.svelte";
	import TruncatedContent from "$lib/components/posts/TruncatedContent.svelte";

	interface Props {
		feed_item: Post;
		truncate?: boolean;
	}

	let { feed_item, truncate = true }: Props = $props();

	if (feed_item.class_name !== "Post") {
		console.error("not a post feed item");
	}
</script>

<div>
	<div>
		<div class="p-2">
			<a href="/posts/{feed_item.id}">
				<Card.Root
					class="border-orange-500 hover:bg-orange-100 dark:hover:bg-orange-900 dark:bg-gray-900 dark:text-gray-200"
				>
					{#if feed_item.title}
						<Card.Header>
							<Card.Title>{feed_item.title}</Card.Title>
						</Card.Header>
					{/if}

					<Card.Content>
						{#if feed_item.content}
							<TruncatedContent text={feed_item.content} enabled={truncate}>
								<MarkedDownPost captured_text={feed_item.content} />
							</TruncatedContent>
						{/if}
					</Card.Content>
				</Card.Root>
			</a>
		</div>
	</div>
</div>
