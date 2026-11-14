<script lang="ts">
	import type { Snippet } from "svelte";
	import type { HTMLAnchorAttributes, HTMLButtonAttributes } from "svelte/elements";
	import { cn } from "$lib/utils.js";

	const COLORS = {
		yellow: {
			base: "border-yellow-600 text-yellow-600 dark:border-yellow-400 dark:text-yellow-400",
			hover:
				"hover:border-yellow-700 hover:text-yellow-700 dark:hover:border-yellow-300 dark:hover:text-yellow-300",
		},
		red: {
			base: "border-red-600 text-red-600 dark:border-red-400 dark:text-red-400",
			hover:
				"hover:border-red-700 hover:text-red-700 dark:hover:border-red-300 dark:hover:text-red-300",
		},
		zinc: {
			base: "border-zinc-500 text-zinc-500 dark:border-zinc-400 dark:text-zinc-400",
			hover:
				"hover:border-zinc-600 hover:text-zinc-600 dark:hover:border-zinc-300 dark:hover:text-zinc-300",
		},
	} as const;

	type Props = (HTMLAnchorAttributes & HTMLButtonAttributes) & {
		href?: string;
		color?: keyof typeof COLORS;
		variant?: "dashed" | "filled";
		class?: string;
		children?: Snippet;
	};

	let {
		href,
		color = "yellow",
		variant = "dashed",
		disabled,
		class: className,
		children,
		...rest
	}: Props = $props();

	const classes = $derived(
		cn(
			"inline-flex items-center justify-center gap-2 px-3 py-1.5 text-sm border bg-transparent",
			variant === "dashed" ? "border-dashed" : "border-solid",
			COLORS[color].base,
			disabled
				? "cursor-default"
				: cn("cursor-pointer", COLORS[color].hover, variant === "dashed" && "hover:border-solid"),
			"[&_svg]:size-4 [&_svg]:shrink-0",
			className,
		),
	);
</script>

{#if href}
	<a {href} class={classes} {...rest}>{@render children?.()}</a>
{:else}
	<button type="button" class={classes} {disabled} {...rest}>{@render children?.()}</button>
{/if}
