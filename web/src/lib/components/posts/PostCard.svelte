<script lang="ts">
	import { enhance } from "$app/forms";
	import Card from "$lib/components/Card.svelte";
	import Link from "$lib/components/text/Link.svelte";
	import H2 from "$lib/components/text/H2.svelte";
	import PlusCircle from "$lib/components/posts/PlusCircle.svelte";
	import { current_user } from "$lib/state/current_user.svelte";
	import type { Post } from "$lib/api_calls/types";
	import { parseAbsoluteToLocal } from "@internationalized/date";
	import MarkedDownPost from "$lib/components/posts/MarkedDownPost.svelte";
	import UserCard from "$lib/components/users/UserCard.svelte";

	interface Props {
		feed_item: Post;
	}

	let { feed_item }: Props = $props();

	if (feed_item.class_name !== "Post") {
		console.error("not a post feed item");
	}

	const localizedCreateTime = parseAbsoluteToLocal(feed_item.created_at);
	const formattedCreateTime = new Intl.DateTimeFormat("en-US", {
		dateStyle: "medium",
		timeStyle: "short",
		timeZone: localizedCreateTime.timeZone,
	}).format(localizedCreateTime.toDate());
</script>

<div>
	<div class="flex flex-row justify-between">
		<div>
			<span class="font-bold">
				<UserCard user={feed_item.user} />
			</span> posted
		</div>
		<div>
			<span class="text-sm">at {formattedCreateTime}</span>
		</div>
	</div>

	<div>
		<div class="p-2">
			<a href="/posts/{feed_item.id}">
				<Card border_color="border-orange-500" hover_color="hover:bg-orange-100">
					{#if feed_item.title}<H2>{feed_item.title}</H2>{/if}
					{#if feed_item.content}
						<MarkedDownPost captured_text={feed_item.content} />
					{/if}
				</Card>
			</a>
		</div>
	</div>
</div>
