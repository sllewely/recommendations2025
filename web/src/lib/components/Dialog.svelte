<script lang="ts">
	import type { Snippet } from "svelte";
	import { Dialog } from "bits-ui";
	import { X } from "@lucide/svelte";
	import { cn } from "$lib/utils.js";

	interface Props {
		open?: boolean;
		title: string;
		description?: string;
		children?: Snippet;
		actions?: Snippet;
		class?: string;
	}

	let {
		open = $bindable(false),
		title,
		description,
		children,
		actions,
		class: className,
	}: Props = $props();
</script>

<Dialog.Root bind:open>
	<Dialog.Portal>
		<Dialog.Overlay class="fixed inset-0 z-50 bg-black/40 dark:bg-black/60" />
		<Dialog.Content
			class={cn(
				"fixed top-1/2 left-1/2 z-50 flex w-full max-w-[calc(100%-2rem)] -translate-x-1/2 -translate-y-1/2 flex-col gap-5 p-6 shadow-2xl outline-hidden sm:max-w-md",
				"border border-zinc-300 bg-zinc-100 text-zinc-900 shadow-zinc-900/20 dark:border-zinc-600 dark:bg-zinc-800 dark:text-zinc-100 dark:shadow-black/50",
				className,
			)}
		>
			<div class="flex flex-col gap-1.5 pr-8">
				<Dialog.Title class="text-lg font-bold leading-tight">{title}</Dialog.Title>
				{#if description}
					<Dialog.Description class="text-sm text-zinc-500 dark:text-zinc-400">
						{description}
					</Dialog.Description>
				{/if}
			</div>

			{@render children?.()}

			{#if actions}
				<div class="flex flex-row flex-wrap justify-end gap-2">
					{@render actions()}
				</div>
			{/if}

			<Dialog.Close
				class="absolute top-5 right-5 cursor-pointer text-zinc-500 hover:text-zinc-900 dark:text-zinc-400 dark:hover:text-zinc-100"
			>
				<X class="size-5" />
				<span class="sr-only">close</span>
			</Dialog.Close>
		</Dialog.Content>
	</Dialog.Portal>
</Dialog.Root>
