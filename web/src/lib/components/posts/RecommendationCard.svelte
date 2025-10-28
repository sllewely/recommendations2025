<script lang="ts">
	import { enhance } from "$app/forms";
	import Card from "$lib/components/Card.svelte";
	import Link from "$lib/components/text/Link.svelte";
	import H2 from "$lib/components/text/H2.svelte";
	import PlusCircle from "$lib/components/posts/PlusCircle.svelte";
	import { current_user } from "$lib/state/current_user.svelte";
	import type { Recommendation } from "$lib/api_calls/types";
	import { parseAbsoluteToLocal } from "@internationalized/date";

	interface Props {
		feed_item: Recommendation;
	}

	let { feed_item }: Props = $props();

	let by_line = " is interested in";

	if (feed_item.class_name !== "Recommendation") {
		console.error("not a recommendation feed item");
	}

	let border_color = "border-yellow-500";
	if (feed_item.status === "watching") {
		by_line = " is watching";
	} else if (feed_item.status === "recommend") {
		by_line = " recommends";
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
			<span class="font-bold"
				><Link url="/users/{feed_item.user.id}">{feed_item.user.name}</Link></span
			>
			{by_line}
		</div>
		<div>
			<span class="text-sm">at {formattedCreateTime}</span>
		</div>
	</div>

	<div>
		{#if current_user.id !== feed_item.user.id}
			<div class="float-right relative">
				<div class="absolute top-0 right-0">
					<form
						method="POST"
						action="?/add_recommendation"
						use:enhance={() => {
							creating = true;
							return async ({ update }) => {
								await update();
								creating = false;
							};
						}}
					>
						<input type="hidden" name="title" value={feed_item.title} />
						<input type="hidden" name="media_type" value={feed_item.media_type} />
						<input type="hidden" name="who_recommended" value={feed_item.user.name} />
						<button type="submit">
							<PlusCircle />
						</button>
					</form>
				</div>
			</div>
		{/if}
		<div class="p-2">
			<a href="/recommendations/{feed_item.id}">
				<Card {border_color} hover_color="hover:bg-yellow-100">
					<p>{feed_item.media_type}</p>
					<H2>{feed_item.title}</H2>
					{#if feed_item.notes}
						<p>{feed_item.notes}</p>
					{/if}
				</Card>
			</a>
		</div>
	</div>
</div>
