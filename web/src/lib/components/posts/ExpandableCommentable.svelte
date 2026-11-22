<script lang="ts">
	import SubmitComment from "$lib/components/posts/SubmitComment.svelte";
	import type { Comment, Feedable, Post, Event, Recommendation } from "$lib/api_calls/types";
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

	let remove_comment = (id: string) => {
		all_comments = all_comments.filter((c) => c.id !== id);
	};

	let replace_comment = (updated: Comment) => {
		all_comments = all_comments.map((c) => (c.id === updated.id ? updated : c));
	};

	let show_extra_comment = $state(true);

	let expand_comments = () => {
		show_extra_comment = !show_extra_comment;
	};
</script>

<div>
	<Collapsible.Root>
		<div class="flex flex-row items-center justify-between">
			<Collapsible.Trigger
				onclick={expand_comments}
				class="cursor-pointer text-sm font-bold underline underline-offset-2"
			>
				comments ({num_comments})
			</Collapsible.Trigger>
			{@render actions?.()}
		</div>
		<div>
			{#if num_comments > 0 && show_extra_comment}
				{#key all_comments.at(-1)?.id}
					<CommentComponent
						comment={all_comments.at(-1)}
						truncate
						ondelete={remove_comment}
						onupdate={replace_comment}
					/>
				{/key}
			{/if}
		</div>
		<Collapsible.Content>
			<div>
				<div>
					{#each all_comments as comment (comment.id)}
						<CommentComponent {comment} ondelete={remove_comment} onupdate={replace_comment} />
					{/each}
				</div>
			</div>
			<SubmitComment {feed_item} {update_comments} />
		</Collapsible.Content>
	</Collapsible.Root>
</div>
