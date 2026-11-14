<script lang="ts">
	import SubHeader from "$lib/components/SubHeader.svelte";
	import SubHeaderTitle from "$lib/components/SubHeaderTitle.svelte";
	import Button from "$lib/components/Button.svelte";
	import Feed from "$lib/components/posts/Feed.svelte";
	import RecommendationCard from "$lib/components/posts/RecommendationCard.svelte";
	import Link from "$lib/components/text/Link.svelte";
	import { feedCard, feedKey, feedPageLoader } from "$lib/feed";
	import type { Recommendation } from "$lib/api_calls/types";
	import type { PageProps } from "./$types.js";

	let { data }: PageProps = $props();

	let load_page = $derived(feedPageLoader<Recommendation>(data.filters));
</script>

<SubHeader>
	<SubHeaderTitle title={data.saved ? "saved recommendations" : "recommendations"} />
	<div class="flex flex-row gap-5">
		{#if data.saved}
			<Button href="/recommendations">all</Button>
		{:else}
			<Button href="/recommendations?saved">saved</Button>
		{/if}
		<Button href="/recommendations/create">new</Button>
	</div>
</SubHeader>

<div class="flex flex-col gap-5">
	<!-- switching between all and saved reuses this page, so remount the feed to reset its list -->
	{#key data.saved}
		<Feed
			items={data.feed_items.map((item) => item.feedable as Recommendation)}
			key={feedKey}
			card={feedCard}
			next_page={data.next_page}
			{load_page}
		>
			{#snippet content(recommendation)}
				<RecommendationCard feed_item={recommendation} />
			{/snippet}
			{#snippet empty()}
				<div
					class="flex justify-center p-2 font-bold border-zinc-800 rounded-sm bg-lime-200 border dark:text-zinc-900"
				>
					<p>
						{data.saved ? "You haven't saved any recommendations yet!" : "No recommendations yet!"}
						<Link url="/recommendations/create">Save a recommendation</Link>
					</p>
				</div>
			{/snippet}
		</Feed>
	{/key}
</div>
