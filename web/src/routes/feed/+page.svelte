<script lang="ts">
	import { goto } from "$app/navigation";
	import SubHeader from "$lib/components/SubHeader.svelte";
	import SubHeaderTitle from "$lib/components/SubHeaderTitle.svelte";
	import Feed from "$lib/components/posts/Feed.svelte";
	import AnyCard from "$lib/components/posts/AnyCard.svelte";
	import NewMenu from "$lib/components/posts/NewMenu.svelte";
	import Button from "$lib/components/Button.svelte";
	import FilterGroup from "$lib/components/form/FilterGroup.svelte";
	import Link from "$lib/components/text/Link.svelte";
	import { FEED_TYPE_OPTIONS, feedCard, feedKey, feedPageLoader, feedTypeUrl } from "$lib/feed";
	import { current_user } from "$lib/state/current_user.svelte";
	import type { PageProps } from "./$types.js";

	let { data }: PageProps = $props();

	const filter = (types: string[]) =>
		goto(feedTypeUrl("/feed", types), { noScroll: true, keepFocus: true });

	let load_page = $derived(feedPageLoader(data.filters));
</script>

<SubHeader>
	<SubHeaderTitle title="feed" />
	<div class="flex flex-row flex-wrap items-center justify-end gap-3">
		<FilterGroup
			label="show"
			options={FEED_TYPE_OPTIONS}
			value={data.types}
			onchange={filter}
			class="justify-end"
		/>
		<NewMenu />
	</div>
</SubHeader>

<nav aria-label="feed or calendar" class="-mt-5 mb-10 flex flex-row gap-2 md:hidden">
	<Button href="/feed" aria-current="page" variant="filled" class="flex-1">feed</Button>
	<Button href="/calendar" color="zinc" class="flex-1">calendar</Button>
</nav>

<div class="flex flex-col gap-5">
	{#key data.types.join()}
		<Feed
			items={data.feed_items.map((item) => item.feedable)}
			key={feedKey}
			card={feedCard}
			next_page={data.next_page}
			{load_page}
		>
			{#snippet content(item)}
				<AnyCard feed_item={item} />
			{/snippet}
			{#snippet empty()}
				<p class="text-zinc-500 dark:text-zinc-400">
					nothing here yet! <Link url="/users/{current_user.id}">add friends</Link>
				</p>
			{/snippet}
		</Feed>
	{/key}
</div>
