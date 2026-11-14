<script lang="ts">
	import SubHeader from "$lib/components/SubHeader.svelte";
	import SubHeaderTitle from "$lib/components/SubHeaderTitle.svelte";
	import Button from "$lib/components/Button.svelte";
	import Feed from "$lib/components/posts/Feed.svelte";
	import PostCard from "$lib/components/posts/PostCard.svelte";
	import Link from "$lib/components/text/Link.svelte";
	import { feedCard, feedKey, feedPageLoader, type FeedFilters } from "$lib/feed";
	import type { Post } from "$lib/api_calls/types";
	import type { PageProps } from "./$types.js";

	let { data }: PageProps = $props();

	const filters: FeedFilters = { type: ["Post"] };
	const load_page = feedPageLoader<Post>(filters);
</script>

<SubHeader>
	<SubHeaderTitle title="posts" />
	<Button href="/posts/create">new</Button>
</SubHeader>

<div class="flex flex-col gap-5">
	<Feed
		items={data.feed_items.map((item) => item.feedable as Post)}
		key={feedKey}
		card={feedCard}
		next_page={data.next_page}
		{load_page}
	>
		{#snippet content(post)}
			<PostCard feed_item={post} />
		{/snippet}
		{#snippet empty()}
			<div
				class="flex justify-center p-2 font-bold border-zinc-800 rounded-sm bg-lime-200 border dark:text-zinc-900"
			>
				<p>
					No posts yet!
					<Link url="/posts/create">Write a post</Link>
				</p>
			</div>
		{/snippet}
	</Feed>
</div>
