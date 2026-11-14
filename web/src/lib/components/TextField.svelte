<script lang="ts">
	// Text input: zinc background, 1px dashed zinc border that goes solid when focused (like
	// Button on hover). One line by default; `multiline` makes it a textarea that grows
	// with its content.
	//   <TextField name="title" placeholder="title" bind:value />
	//   <TextField multiline name="notes" rows={4} />
	import type { HTMLInputAttributes, HTMLTextareaAttributes } from "svelte/elements";
	import { cn } from "$lib/utils.js";

	type Props = (HTMLInputAttributes & HTMLTextareaAttributes) & {
		multiline?: boolean;
		value?: string | number | null;
		ref?: HTMLInputElement | HTMLTextAreaElement | null;
		class?: string;
	};

	let {
		multiline = false,
		value = $bindable(),
		ref = $bindable(null),
		class: className,
		...rest
	}: Props = $props();

	const classes = $derived(
		cn(
			"w-full min-w-0 px-3 py-1.5 text-sm outline-none",
			"bg-zinc-100 border border-dashed border-zinc-400 text-zinc-900 placeholder:text-zinc-400",
			"dark:bg-zinc-700/50 dark:border-zinc-500 dark:text-zinc-100 dark:placeholder:text-zinc-500",
			"focus:border-solid focus:border-zinc-600 dark:focus:border-zinc-300",
			"disabled:cursor-not-allowed disabled:opacity-60",
			multiline && "field-sizing-content min-h-20 resize-y",
			className,
		),
	);
</script>

{#if multiline}
	<textarea bind:this={ref} bind:value class={classes} {...rest as HTMLTextareaAttributes}
	></textarea>
{:else}
	<input bind:this={ref} bind:value class={classes} {...rest as HTMLInputAttributes} />
{/if}
