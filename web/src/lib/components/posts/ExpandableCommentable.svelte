<script lang="ts">
	import SubmitComment from "$lib/components/posts/SubmitComment.svelte";
	import { MessageCircleMore } from "@lucide/svelte";
	import type { Comment, Feedable, Post, Event, Recommendation } from "$lib/api_calls/types";
	import Link from "$lib/components/text/Link.svelte";
	import * as Collapsible from "$lib/components/ui/collapsible";
	import CommentComponent from "$lib/components/posts/Comment.svelte";
	import type { Snippet } from "svelte";

	interface Props {
		comments: Comment[];
		feed_item: Post | Event | Recommendation;
		// rendered on the right side of the comments toggle row
		actions?: Snippet;
	}

	let { comments, feed_item, actions }: Props = $props();

	let all_comments = $state(comments);
	let num_comments = $derived(all_comments.length);

	let update_comments = (new_comments: Comment[]) => {
		all_comments = new_comments;
	};

	let show_extra_comment = $state(true);

	let expand_comments = () => {
		show_extra_comment = !show_extra_comment;
	};
</script>

<div class="px-3">
	<Collapsible.Root>
		<div class="flex flex-row items-center justify-between">
			<Collapsible.Trigger onclick={expand_comments}>
				<Link>
					<div class="flex">
						{num_comments} Comments
						<MessageCircleMore />
					</div>
				</Link>
			</Collapsible.Trigger>
			{@render actions?.()}
		</div>
		<div>
			{#if num_comments > 0 && show_extra_comment}
				<CommentComponent comment={all_comments.at(-1)} />
			{/if}
		</div>
		<Collapsible.Content>
			<div>
				<div>
					{#each all_comments as comment}
						<CommentComponent {comment} />
					{/each}
				</div>
			</div>
			<SubmitComment {feed_item} {update_comments} />
		</Collapsible.Content>
	</Collapsible.Root>
</div>
