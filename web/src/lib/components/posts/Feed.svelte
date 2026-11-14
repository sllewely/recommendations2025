<script lang="ts" module>
	import type { Component } from "svelte";
	import type { User } from "$lib/api_calls/types";
	import type { Accent } from "$lib/components/posts/FeedBadge.svelte";

	export type { Accent };

	export interface FeedCardInfo {
		href: string;
		title?: string;
		label: string;
		user: User;
		posted_at: string;
		icon: Component<any>;
		accent: Accent;
	}
</script>

<script lang="ts" generics="T">
	import type { Snippet } from "svelte";
	import { onMount } from "svelte";
	import { cn } from "$lib/utils.js";
	import { formatWhen } from "$lib/format_date";
	import UserCard from "$lib/components/users/UserCard.svelte";
	import FeedBadge, { ACCENTS, CARD } from "$lib/components/posts/FeedBadge.svelte";
	import { Spinner } from "$lib/components/ui/spinner/index.js";

	interface Props {
		items: T[];
		key: (item: T) => string;
		card: (item: T) => FeedCardInfo;
		content: Snippet<[T]>;
		next_page?: number | null;
		load_page?: (page: number) => Promise<{ items: T[]; next: number | null }>;
		empty?: Snippet;
	}

	let { items, key, card, content, next_page, load_page, empty }: Props = $props();

	let list = $state(items);
	let next = $state(next_page ?? null);
	let loading = $state(false);

	async function load_more() {
		if (loading || next == null || !load_page) return;
		loading = true;
		try {
			const page = await load_page(next);
			list = list.concat(page.items);
			next = page.next;
		} finally {
			loading = false;
		}
	}

	$effect(() => {
		if (!load_page) return;
		const on_scroll = () => {
			if (window.innerHeight + window.scrollY >= document.body.offsetHeight) load_more();
		};
		window.addEventListener("scroll", on_scroll);
		return () => window.removeEventListener("scroll", on_scroll);
	});

	let mounted = $state(false);
	onMount(() => {
		mounted = true;
	});

	// the card's own link (the title, or a hidden one when there's no title): its ::after covers
	// the card. "card-link" marks it for the hover border and so it isn't lifted like the others
	const stretched =
		"card-link after:absolute after:inset-0 after:z-1 after:content-[''] focus-visible:outline-none focus-visible:after:outline-2 focus-visible:after:outline-amber-400";
	// every other link/button/input in the card sits above the card's link, so it still works
	const lift =
		"[&_:is(a,button,input,textarea,select,label,summary,[tabindex]):not(.card-link)]:relative [&_:is(a,button,input,textarea,select,label,summary,[tabindex]):not(.card-link)]:z-2";
</script>

<div class="flex flex-col gap-5">
	{#if list.length === 0 && !loading}
		{@render empty?.()}
	{/if}

	{#each list as item (key(item))}
		{@const info = card(item)}
		<div class="flex flex-col">
			<div
				class="mb-1.5 flex h-(--reply-h) flex-row items-stretch gap-1.5 pl-2.5 text-sm [--reply-h:--spacing(10)]"
			>
				<div aria-hidden="true" class="flex aspect-square h-full shrink-0">
					<div
						class="mt-auto ml-auto size-[calc(50%+1px)] rounded-tl-xl border-t-2 border-l-2 border-dashed border-zinc-500 dark:border-zinc-400"
					></div>
				</div>
				<div class="flex min-w-0 flex-row items-center gap-1.5">
					<UserCard user={info.user} size="sm" />
					<span class="truncate text-zinc-500 dark:text-zinc-400"
						>posted on {mounted ? formatWhen(info.posted_at) : ""}</span
					>
				</div>
			</div>

			<article
				class={cn(
					"relative flex flex-col gap-5 border border-dashed border-transparent",
					CARD,
					lift,
					ACCENTS[info.accent].hover,
				)}
			>
				{#if info.title}
					<div class="flex flex-row items-start gap-3">
						<FeedBadge icon={info.icon} accent={info.accent} />
						<h3 class="mt-1 text-lg font-semibold leading-tight">
							<a href={info.href} class={stretched}>{info.title}</a>
						</h3>
					</div>
				{:else}
					<!-- no title: still one real link covering the card, named for screen readers. pinned
					     to the card's edges (absolute inset-0) so it doesn't take a slot in the card's gap,
					     and so its ::after, measured against the link once it's absolute, covers the card -->
					<a href={info.href} class={cn(stretched, "absolute inset-0")}
						><span class="sr-only">{info.label}</span></a
					>
				{/if}
				{@render content(item)}
			</article>
		</div>
	{/each}

	{#if loading}
		<div class="flex justify-center pt-20">
			<Spinner class="size-24" />
		</div>
	{/if}

	{#if load_page && next == null}
		<div class="flex justify-center pt-10 italic text-zinc-500 dark:text-zinc-400">
			Reached the end of time :)
		</div>
	{/if}
</div>
