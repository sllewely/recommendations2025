<script lang="ts">
	// The left side of a subheader: a title (or something else, like a user card) and a caption.
	import type { Snippet } from "svelte";

	interface Props {
		title?: string;
		// text under the title, or a snippet for richer content (e.g. "by <UserCard>")
		caption?: string | Snippet;
		// replaces the title text, e.g. <UserCard size="lg" />
		children?: Snippet;
	}

	let { title, caption, children }: Props = $props();
</script>

<div class="flex min-w-0 flex-col gap-1.5">
	<h1 class="text-xl leading-none">
		{#if children}
			{@render children()}
		{:else}
			{title}
		{/if}
	</h1>
	{#if typeof caption === "function"}
		<div class="flex flex-row items-center gap-1.5 text-sm text-zinc-500 dark:text-zinc-400">
			{@render caption()}
		</div>
	{:else if caption}
		<p class="text-sm text-zinc-500 dark:text-zinc-400">{caption}</p>
	{/if}
</div>
