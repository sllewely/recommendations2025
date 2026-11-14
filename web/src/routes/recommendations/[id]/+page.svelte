<script lang="ts">
	import H1 from "$lib/components/text/H1.svelte";
	import H2 from "$lib/components/text/H2.svelte";
	import Card from "$lib/components/Card.svelte";
	import LinkButton from "$lib/components/text/LinkButton.svelte";
	import Link from "$lib/components/text/Link.svelte";
	import type { Recommendation, User } from "$lib/api_calls/types";
	import { parseAbsoluteToLocal } from "@internationalized/date";
	import Commentable from "$lib/components/posts/Commentable.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import { goto } from "$app/navigation";
	import { Button } from "$lib/components/ui/button";

	interface Props {
		data: {
			recommendation: Recommendation;
			my_user_id: string;
		};
	}

	let { data }: Props = $props();

	let comments = $derived(data.recommendation.comments);

	const localizedCreateTime = parseAbsoluteToLocal(data.recommendation.created_at);
	const formattedCreateTime = new Intl.DateTimeFormat("en-US", {
		dateStyle: "medium",
		timeStyle: "short",
		timeZone: localizedCreateTime.timeZone,
	}).format(localizedCreateTime.toDate());

	let delete_recommendation = async () => {
		const response = await fetch("/api/recommendations/delete", {
			method: "POST",
			body: JSON.stringify({ id: data.recommendation.id }),
			headers: {
				"Content-Type": "application/json",
			},
		});
		let res = await response.json();
		if (res.success) {
			newToast("Successfully deleted recommendation");
			goto("/posts");
		} else {
			newToast("Error deleting a recommendation: " + res.message, ToastType.Error);
		}
	};
</script>

<div>
	{#if data.my_user_id.toString() === data.recommendation.user.id.toString()}
		<div class="float-right relative">
			<LinkButton url="/recommendations/{data.recommendation.id}/edit">Edit</LinkButton>
			<Button onclick={delete_recommendation} variant="destructive">Delete</Button>
		</div>
	{/if}
	<div>
		<div class="flex flex-row justify-between">
			<div>
				<span class="font-bold">
					<Link url="/users/{data.recommendation.user.id}">{data.recommendation.user.name}</Link>
				</span>'s recommendation
			</div>
			<div>
				<span class="text-sm">posted at {formattedCreateTime}</span>
			</div>
		</div>
		<Card>
			<H1>{data.recommendation.title}</H1>
			<p>{data.recommendation.media_type}</p>
			<p>{data.recommendation.notes}</p>
			{#if data.recommendation.who_recommended}
				<p>Who recommended? {data.recommendation.who_recommended}</p>
			{/if}
			<p class="truncate">
				{#if data.recommendation.url}
					<Link url={data.recommendation.url}>{data.recommendation.url}</Link>
				{/if}
			</p>
		</Card>

		<div>
			<Commentable feed_item={data.recommendation} comments={data.recommendation.comments} />
		</div>
	</div>
</div>
