<script lang="ts">
	import type { Snippet } from "svelte";
	import { cn } from "$lib/utils.js";

	interface Props {
		label?: string;
		for?: string;
		description?: string;
		info?: Snippet;
		class?: string;
		children: Snippet;
	}

	let { label, for: for_id, description, info, class: className, children }: Props = $props();

	const label_id = $props.id();
	let grouped = $derived(!!label && !for_id && !info);
</script>

<div class={cn("flex flex-col gap-1.5 md:grid md:grid-cols-3 md:gap-5", className)}>
	<div class="flex min-w-0 flex-col gap-1 md:pt-1.5">
		{#if info}
			{@render info()}
		{:else if label}
			{#if for_id}
				<label for={for_id}>{label}</label>
			{:else}
				<span id={label_id}>{label}</span>
			{/if}
			{#if description}
				<p class="text-xs text-zinc-500 dark:text-zinc-400">{description}</p>
			{/if}
		{/if}
	</div>
	<div
		class="flex min-w-0 flex-col gap-1.5 md:col-span-2"
		role={grouped ? "group" : undefined}
		aria-labelledby={grouped ? label_id : undefined}
	>
		{@render children()}
	</div>
</div>
