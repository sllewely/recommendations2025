<script lang="ts">
	import SubmitComment from "$lib/components/posts/SubmitComment.svelte";
	import { MessageCircleMore } from "@lucide/svelte";
	import type { Comment, Feedable } from "$lib/api_calls/types";
	import Link from "$lib/components/text/Link.svelte";
	import * as Collapsible from "$lib/components/ui/collapsible";
	import CommentComponent from "$lib/components/posts/Comment.svelte";

	interface Props {
		comments: Comment;
		feed_item: Feedable;
	}

	let { comments, feed_item } = $props();

	let all_comments = $state(comments);
	let num_comments = $derived(all_comments.length);

	let update_comments = (new_comments: Comment[]) => {
		all_comments = new_comments;
	};

	let show_extra_comment = $state(true);

	let toggle_comment = () => {
		show_extra_comment = !show_extra_comment;
	};
</script>

<div>
	<Collapsible.Root>
		<Collapsible.Trigger onclick={toggle_comment}>
			<Link>
				<div class="flex">
					{num_comments} Comments
					<MessageCircleMore />
				</div>
			</Link>
		</Collapsible.Trigger>
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
				<SubmitComment {feed_item} {update_comments} />
			</div>
		</Collapsible.Content>
	</Collapsible.Root>
</div>
