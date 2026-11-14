<script lang="ts">
	import type { Snippet } from "svelte";
	import { cn } from "$lib/utils.js";

	interface Props {
		level?: 2 | 3;
		class?: string;
		children?: Snippet;
	}

	let { level = 2, class: className, children }: Props = $props();
</script>

<svelte:element this={`h${level}`} class={cn("text-lg font-bold leading-tight", className)}>
	{@render children?.()}
</svelte:element>
