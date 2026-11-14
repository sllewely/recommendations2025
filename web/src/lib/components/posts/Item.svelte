<script lang="ts" module>
	export interface Attribute {
		label: string;
		value: string;
		href?: string;
	}

	const COLLAPSED = {
		2: { length: 120, class: "max-h-[3.25rem]" },
		4: { length: 280, class: "max-h-[6.25rem]" },
		6: { length: 400, class: "max-h-[9.25rem]" },
	} as const;
</script>

<script lang="ts">
	import type { Snippet } from "svelte";
	import type { Comment, Post, Event, Recommendation } from "$lib/api_calls/types";
	import MarkedDownPost from "$lib/components/posts/MarkedDownPost.svelte";
	import Comments from "$lib/components/posts/Comments.svelte";
	import Reactions from "$lib/components/reactions/Reactions.svelte";

	interface Props {
		feed_item: Post | Event | Recommendation;
		attributes?: Attribute[];
		description?: string;
		lines?: keyof typeof COLLAPSED;
		truncate?: boolean;
		panels?: boolean;
		rsvps?: Snippet;
		rsvp_count?: number;
	}

	let {
		feed_item,
		attributes = [],
		description,
		lines = 6,
		truncate = true,
		panels = true,
		rsvps,
		rsvp_count = 0,
	}: Props = $props();

	let open = $state<"rsvps" | "comments" | null>(null);
	const toggle = (panel: "rsvps" | "comments") => (open = open === panel ? null : panel);

	let comments = $state<Comment[]>(feed_item.comments ?? []);

	let expanded = $state(false);
	let too_long = $derived.by(() => {
		if (!truncate || !description) return false;
		const line_count = (description.match(/\n/g) || []).length + 1;
		return description.length > COLLAPSED[lines].length || line_count > lines;
	});
</script>

<div class="flex flex-col gap-5">
	{#if attributes.length > 0}
		<ul
			class="flex min-w-0 flex-col gap-1 text-sm text-zinc-500 dark:text-zinc-400 [&>li]:truncate [&_.value]:text-zinc-700 dark:[&_.value]:text-zinc-300"
		>
			{#each attributes as attribute}
				<li>
					{attribute.label}
					{#if attribute.href}
						<a href={attribute.href} class="value underline">{attribute.value}</a>
					{:else}
						<span class="value">{attribute.value}</span>
					{/if}
				</li>
			{/each}
		</ul>
	{/if}

	{#if description?.trim()}
		<div>
			<!-- with a read more button, drop the bottom margin of the last markdown block so the
			     button sits right under the text (important to beat MarkedDownPost's unlayered styles) -->
			<div
				class={too_long
					? `relative [&_section>:last-child]:mb-0! ${expanded ? "" : `${COLLAPSED[lines].class} overflow-clip`}`
					: "relative"}
			>
				<MarkedDownPost captured_text={description} />
			</div>
			{#if too_long}
				<button
					type="button"
					class="mt-2 block w-fit cursor-pointer text-xs leading-none text-zinc-700 underline focus:outline-none dark:text-zinc-300"
					onclick={(e) => {
						e.preventDefault();
						e.stopPropagation();
						expanded = !expanded;
					}}
				>
					{expanded ? "read less" : "read more"}
				</button>
			{/if}
		</div>
	{/if}

	<Reactions feedable={feed_item} />

	{#if panels}
		<div class="flex flex-row flex-wrap items-center gap-4 text-sm font-bold">
			<button
				type="button"
				class="cursor-pointer underline underline-offset-2"
				aria-expanded={open === "comments"}
				onclick={() => toggle("comments")}
			>
				comments ({comments.length})
			</button>
			{#if rsvps}
				<button
					type="button"
					class="cursor-pointer underline underline-offset-2"
					aria-expanded={open === "rsvps"}
					onclick={() => toggle("rsvps")}
				>
					rsvps ({rsvp_count})
				</button>
			{/if}
		</div>

		{#if open === "comments"}
			<Comments {feed_item} bind:comments offset={false} />
		{:else if open === "rsvps" && rsvps}
			<div class="flex flex-col gap-2">
				{@render rsvps()}
			</div>
		{/if}
	{/if}
</div>
