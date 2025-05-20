<script lang="ts">
	import Card from "$lib/components/Card.svelte";
	import Link from "$lib/components/text/Link.svelte";
	import H2 from "$lib/components/text/H2.svelte";
	import RecommendationCard from "$lib/components/posts/RecommendationCard.svelte";

	let { feed_item } = $props();

	let by_line = (function () {
		switch (feed_item.class_name) {
			case "Post":
				return " posted";
			case "Event":
				return " posted an upcoming event";
			default:
				return " is interested in";
		}
	})();

	//TODO: different component based on which type
</script>

<div>
	<!--{#if feed_item.class_name === 'Recommendation'}-->
	<!--    <RecommendationCard feed_item={feed_item} />-->
	<!--    {:else}-->
	<div class="p-2">
		<Card>
			<div class="flex flex-row justify-between pb-2">
				<div>
					<span class="font-bold"
						><Link url="/users/{feed_item.creator_id}">{feed_item.creator_name}</Link></span
					>
				</div>
				<div>
					<span class="text-sm"
						>at {feed_item.create_date_string} {feed_item.create_time_string}</span
					>
					{by_line}
				</div>
			</div>
			<H2>{feed_item.title ?? feed_item.post_title}</H2>
			{#if feed_item.notes ?? feed_item.content}
				<p>{feed_item.notes ?? feed_item.content}</p>
			{/if}
			{#if feed_item.start_date_string}
				<p>Happening {feed_item.start_date_string} - {feed_item.start_time_string}</p>
			{/if}
			{#if feed_item.address}
				<p>at {feed_item.address}</p>
			{/if}
		</Card>
	</div>
	<!--{/if}-->
</div>
