<script lang="ts">
	import LinkButton from "$lib/components/text/LinkButton.svelte";
	import PostCard from "$lib/components/posts/PostCard.svelte";
	import { MessageCircleMore } from "@lucide/svelte";
	import Comment from "$lib/components/posts/Comment.svelte";
	import SubmitComment from "$lib/components/posts/SubmitComment.svelte";
	import { goto } from "$app/navigation";
	import { Button } from "$lib/components/ui/button";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import type { Post } from "$lib/api_calls/types";
	import Commentable from "$lib/components/posts/Commentable.svelte";

	interface Props {
		data: {
			post: Post;
			my_user_id: string;
		};
	}
	let { data }: Props = $props();
	let my_user_id = data.my_user_id;

	// Svelte pitfall.  Page updates are not triggered by load data prop change!!
	// This is the workaround
	let post = $state(data.post);
	$effect(() => {
		post = data.post;
	});

	let comments = $derived(post.comments);

	let num_comments = $derived(comments.length);

	let delete_post = async () => {
		const response = await fetch("/api/delete_post", {
			method: "POST",
			body: JSON.stringify({ id: post.id }),
			headers: {
				"Content-Type": "application/json",
			},
		});
		let res = await response.json();
		if (res.success) {
			newToast("Successfully deleted post");
			goto("/posts");
		} else {
			newToast("Error deleting a post: " + res.message, ToastType.Error);
		}
	};
</script>

<div>
	{#if my_user_id.toString() === post.user.id.toString()}
		<div class="float-right relative">
			<LinkButton url="/posts/{post.id}/edit">Edit</LinkButton>
			<Button onclick={delete_post} variant="destructive">Delete</Button>
		</div>
	{/if}
	<PostCard feed_item={post} />

	<div>
		<Commentable feed_item={post} {comments} />
	</div>
</div>
