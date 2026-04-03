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
	import Link from "$lib/components/text/Link.svelte";
	import { parseAbsoluteToLocal } from "@internationalized/date";

	interface Props {
		data: {
			post: Post;
			my_user_id: string;
		};
	}

	let { data }: Props = $props();
	let my_user_id = data.my_user_id;

	let localizedCreateTime = parseAbsoluteToLocal(data.post.created_at);

	let formattedCreateTime = new Intl.DateTimeFormat("en-US", {
		dateStyle: "medium",
		timeStyle: "short",
		timeZone: localizedCreateTime.timeZone,
	}).format(localizedCreateTime.toDate());

	let delete_post = async () => {
		const response = await fetch("/api/delete_post", {
			method: "POST",
			body: JSON.stringify({ id: data.post.id }),
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
	{#if my_user_id.toString() === data.post.user.id.toString()}
		<div class="float-right relative">
			<LinkButton url="/posts/{data.post.id}/edit">Edit</LinkButton>
			<Button onclick={delete_post} variant="destructive">Delete</Button>
		</div>
	{/if}
	<div>
		<div class="flex flex-row justify-between">
			<div>
				<span class="font-bold">
					<Link url="/users/{data.post.user.id}">{data.post.user.name}</Link>
				</span>'s post
			</div>
			<div>
				<span class="text-sm">posted at {formattedCreateTime}</span>
			</div>
		</div>
		<PostCard feed_item={data.post} />

		<div>
			<Commentable feed_item={data.post} comments={data.post.comments} />
		</div>
	</div>
</div>
