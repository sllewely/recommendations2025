<script lang="ts">
	import { enhance } from "$app/forms";
	import * as Card from "$lib/components/ui/card/index.js";
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

	let by_line = $derived.by(() => {
		if (feed_item.status === "watching") return " is watching";
		if (feed_item.status === "recommend") return " recommends";
		return " is interested in";
	});

	if (feed_item.class_name !== "Recommendation") {
		console.error("not a recommendation feed item");
	}

	let border_color = "border-yellow-500";

	const localizedCreateTime = parseAbsoluteToLocal(feed_item.created_at);
	const formattedCreateTime = new Intl.DateTimeFormat("en-US", {
		dateStyle: "medium",
		timeStyle: "short",
		timeZone: localizedCreateTime.timeZone,
	}).format(localizedCreateTime.toDate());

	let creating = $state(false);
</script>

<div>
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
				<Card.Root
					class="border-yellow-500 hover:bg-yellow-100 border-2 dark:hover:bg-yellow-950 dark:bg-gray-900 dark:text-gray-200"
				>
					<Card.Header>
						<Card.Title>{feed_item.title}</Card.Title>
					</Card.Header>
					<Card.Content>
						<p>{feed_item.media_type}</p>
						{#if feed_item.notes}
							<p>{feed_item.notes}</p>
						{/if}
						{#if feed_item.url}
							<p class="truncate">
								<Link url={feed_item.url}>{feed_item.url}</Link>
							</p>
						{/if}
					</Card.Content>
				</Card.Root>
			</a>
		</div>
	</div>
</div>
