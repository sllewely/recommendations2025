<script lang="ts" module>
	export const CARD_BG = "rounded-xl bg-zinc-100 dark:bg-zinc-700/50";
	export const CARD = CARD_BG + " p-5";

	// class names written out in full so Tailwind finds them
	export const ACCENTS = {
		sky: {
			badge: "bg-sky-500/10 dark:bg-sky-400/10 text-sky-500 dark:text-sky-400",
			text: "text-sky-500 dark:text-sky-300",
			hover: "has-[.card-link:hover]:border-sky-500 dark:has-[.card-link:hover]:border-sky-200",
			border: "hover:border-sky-500 dark:hover:border-sky-200",
			bar: "border-l-sky-400 dark:border-l-sky-200",
		},
		lime: {
			badge: "bg-lime-500/10 dark:bg-lime-400/10 text-lime-500 dark:text-lime-400",
			text: "text-lime-500 dark:text-lime-300",
			hover: "has-[.card-link:hover]:border-lime-500 dark:has-[.card-link:hover]:border-lime-200",
			border: "hover:border-lime-500 dark:hover:border-lime-200",
			bar: "border-l-lime-400 dark:border-l-lime-200",
		},
		fuchsia: {
			badge: "bg-fuchsia-500/10 dark:bg-fuchsia-400/10 text-fuchsia-500 dark:text-fuchsia-400",
			text: "text-fuchsia-500 dark:text-fuchsia-300",
			hover:
				"has-[.card-link:hover]:border-fuchsia-500 dark:has-[.card-link:hover]:border-fuchsia-200",
			border: "hover:border-fuchsia-500 dark:hover:border-fuchsia-200",
			bar: "border-l-fuchsia-400 dark:border-l-fuchsia-200",
		},
		yellow: {
			badge: "bg-yellow-500/10 dark:bg-yellow-400/10 text-yellow-500 dark:text-yellow-400",
			text: "text-yellow-500 dark:text-yellow-300",
			hover:
				"has-[.card-link:hover]:border-yellow-500 dark:has-[.card-link:hover]:border-yellow-200",
			border: "hover:border-yellow-500 dark:hover:border-yellow-200",
			bar: "border-l-yellow-400 dark:border-l-yellow-200",
		},
		zinc: {
			badge: "bg-zinc-400/10 text-zinc-400",
			text: "text-zinc-500 dark:text-zinc-400",
			hover: "has-[.card-link:hover]:border-zinc-400",
			border: "hover:border-zinc-500 dark:hover:border-zinc-400",
			bar: "border-l-zinc-500 dark:border-l-zinc-400",
		},
	} as const;

	export type Accent = keyof typeof ACCENTS;
</script>

<script lang="ts">
	import type { Component } from "svelte";
	import { cn } from "$lib/utils.js";

	interface Props {
		icon: Component<any>;
		accent: Accent;
		class?: string;
	}

	let { icon: Icon, accent, class: className }: Props = $props();
</script>

<span
	aria-hidden="true"
	class={cn(
		"inline-flex size-7 shrink-0 items-center justify-center rounded-lg",
		ACCENTS[accent].badge,
		className,
	)}
>
	<Icon class="size-4" />
</span>
