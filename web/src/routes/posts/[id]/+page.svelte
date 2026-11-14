<script lang="ts">
	import UserCard from "$lib/components/users/UserCard.svelte";
	import Button from "$lib/components/Button.svelte";
	import SubHeader from "$lib/components/SubHeader.svelte";
	import SubHeaderTitle from "$lib/components/SubHeaderTitle.svelte";
	import PostCard from "$lib/components/posts/PostCard.svelte";
	import { goto } from "$app/navigation";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import type { Post } from "$lib/api_calls/types";

	interface Props {
		data: {
			post: Post;
			my_user_id: string;
		};
	}

	let { data }: Props = $props();
	let my_user_id = data.my_user_id;

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
			goto("/");
		} else {
			newToast("Error deleting a post: " + res.message, ToastType.Error);
		}
	};
</script>

<SubHeader>
	<SubHeaderTitle title={data.post.title || "post"}>
		{#snippet caption()}
			by <UserCard user={data.post.user} size="sm" />
		{/snippet}
	</SubHeaderTitle>
	{#if my_user_id.toString() === data.post.user.id.toString()}
		<div class="flex flex-row gap-5">
			<Button href="/posts/{data.post.id}/edit">edit</Button>
			<Button color="red" onclick={delete_post}>delete</Button>
		</div>
	{/if}
</SubHeader>

<div class="flex flex-col gap-5">
	<PostCard feed_item={data.post} truncate={false} />
</div>
