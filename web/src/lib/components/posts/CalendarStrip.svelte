<script lang="ts">
	import { onMount } from "svelte";
	import type { Event } from "$lib/api_calls/types";
	import { formatWhen } from "$lib/format_date";
	import Item, { type Attribute } from "$lib/components/posts/Item.svelte";
	import UserCard from "$lib/components/users/UserCard.svelte";
	import { ACCENTS, CARD_BG } from "$lib/components/posts/FeedBadge.svelte";
	import { cn } from "$lib/utils.js";
	import RsvpPicker from "$lib/components/rsvp/RsvpPicker.svelte";

	let { events = $bindable() }: { events: Event[] } = $props();

	let mounted = $state(false);
	onMount(() => {
		mounted = true;
	});

	const attributes = (event: Event): Attribute[] => [
		...(event.address ? [{ label: "at", value: event.address }] : []),
		...(event.url ? [{ label: "see", value: event.url, href: event.url }] : []),
	];

	const plain = (markdown: string) =>
		markdown
			.replace(/!\[[^\]]*\]\([^)]*\)/g, "")
			.replace(/\[([^\]]*)\]\([^)]*\)/g, "$1")
			.replace(/[*_`~#>]+/g, "")
			.replace(/\s+/g, " ")
			.trim();

	const stretched = "after:absolute after:inset-0 after:content-['']";
</script>

<div class="h-80 mt-1">
	{#if events.length === 0}
		<p class="text-sm text-zinc-500 dark:text-zinc-400">no upcoming events</p>
	{:else}
		<ul class="-mx-1 flex h-full snap-x flex-row gap-3 overflow-x-auto px-1 pb-2">
			{#each events as event (event.id)}
				<li class="flex w-72 shrink-0 snap-start flex-col">
					<div
						class="mb-1 flex h-(--reply-h) flex-row items-stretch gap-1 text-sm [--reply-h:--spacing(5)]"
					>
						<div aria-hidden="true" class="flex aspect-square h-full shrink-0">
							<div
								class="mt-auto ml-auto size-[calc(50%+1px)] rounded-tl-md border-t-2 border-l-2 border-dotted border-zinc-500 dark:border-zinc-400"
							></div>
						</div>
						<span class="flex items-center gap-1 truncate text-zinc-500 dark:text-zinc-400">
							on
							<span class="text-zinc-600 dark:text-zinc-300">
								{mounted ? formatWhen(event.start_date_time) : ""}
							</span>
						</span>
					</div>

					<article
						class={cn(
							"relative flex min-h-0 flex-1 flex-col gap-5 overflow-hidden border border-dashed border-transparent p-5",
							CARD_BG,
							ACCENTS.lime.hover,
							"[&_:is(a,button):not(.card-link)]:relative [&_:is(a,button):not(.card-link)]:z-1",
						)}
					>
						<div class="flex flex-col gap-1.5">
							<h3 class="line-clamp-2 text-lg font-semibold leading-tight">
								<a href="/events/{event.id}" class={cn("card-link", stretched)}>{event.title}</a>
							</h3>
							<div
								class="flex flex-row items-center gap-1.5 text-sm text-zinc-500 dark:text-zinc-400"
							>
								by <UserCard user={event.user} size="xs" />
							</div>
						</div>
						<div class="flex min-h-0 flex-1 flex-col gap-5">
							<Item feed_item={event} attributes={attributes(event)} actions={false} />
							{#if event.description?.trim()}
								<p class="line-clamp-4">{plain(event.description)}</p>
							{/if}
						</div>
						<div class="flex flex-row items-center gap-2.5">
							<RsvpPicker event_id={event.id} bind:rsvps={event.rsvps} align="start" />
							<span class="text-sm text-zinc-600 dark:text-zinc-300">
								{event.rsvps.length}
								{event.rsvps.length === 1 ? "rsvp" : "rsvps"}
							</span>
						</div>
					</article>
				</li>
			{/each}
		</ul>
	{/if}
</div>
