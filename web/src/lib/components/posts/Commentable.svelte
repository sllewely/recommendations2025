<script lang="ts">
	import SubmitComment from "$lib/components/posts/SubmitComment.svelte";
	import { MessageCircleMore } from "@lucide/svelte";
	import type { Comment, Feedable, Post, Event, Recommendation } from "$lib/api_calls/types";
	import CommentComponent from "$lib/components/posts/Comment.svelte";

	interface Props {
		comments: Comment[];
		feed_item: Post | Event | Recommendation;
	}

	let { comments, feed_item }: Props = $props();

	let all_comments = $state(comments);
	let num_comments = $derived(all_comments.length);

	let update_comments = (new_comments: Comment[]) => {
		all_comments = new_comments;
	};

	let remove_comment = (id: string) => {
		all_comments = all_comments.filter((c) => c.id !== id);
	};

	let replace_comment = (updated: Comment) => {
		all_comments = all_comments.map((c) => (c.id === updated.id ? updated : c));
	};
</script>

<div>
	<div class="flex">
		{num_comments} Comments
		<MessageCircleMore />
	</div>
	<div>
		<div>
			{#each all_comments as comment (comment.id)}
				<CommentComponent {comment} ondelete={remove_comment} onupdate={replace_comment} />
			{/each}
		</div>
	</div>
	<SubmitComment {feed_item} {update_comments} />
</div>
