<script lang="ts">
	import H1 from "$lib/components/text/H1.svelte";
	import H2 from "$lib/components/text/H2.svelte";
	import Card from "$lib/components/Card.svelte";
	import LinkButton from "$lib/components/text/LinkButton.svelte";
	import Link from "$lib/components/text/Link.svelte";
	import type { Recommendation, User } from "$lib/api_calls/types";
	import { parseAbsoluteToLocal } from "@internationalized/date";
	import Commentable from "$lib/components/posts/Commentable.svelte";

	interface Props {
		data: {
			recommendation: Recommendation;
			my_user_id: string;
		};
	}

	let { data }: Props = $props();

	// Svelte pitfall.  Page updates are not triggered by load data prop change!!
	// This is the workaround
	let recommendation = $state(data.recommendation);
	$effect(() => {
		recommendation = data.recommendation;
	});

	let comments = $derived(recommendation.comments);

	let num_comments = $derived(comments.length);

	const localizedCreateTime = parseAbsoluteToLocal(recommendation.created_at);
	const formattedCreateTime = new Intl.DateTimeFormat("en-US", {
		dateStyle: "medium",
		timeStyle: "short",
		timeZone: localizedCreateTime.timeZone,
	}).format(localizedCreateTime.toDate());
</script>

<div>
	{#if data.my_user_id.toString() === recommendation.user.id.toString()}
		<div class="float-right relative">
			<LinkButton url="/recommendations/{recommendation.id}/edit">Edit</LinkButton>
			<LinkButton url="/recommendations/{recommendation.id}/delete">Delete</LinkButton>
		</div>
	{/if}
	<H2>{recommendation.user.name}'s recommendation</H2>
	<Card>
		<H1>{recommendation.title}</H1>
		<p>{recommendation.media_type}</p>
		<p>{recommendation.notes}</p>
		{#if recommendation.who_recommended}
			<p>Who recommended? {recommendation.who_recommended}</p>
		{/if}
		<p>Added: {formattedCreateTime}</p>
		{#if recommendation.url}
			<Link url={recommendation.url}>{recommendation.url}</Link>
		{/if}
	</Card>

	<div>
		<Commentable feed_item={recommendation} {comments} />
	</div>
</div>
