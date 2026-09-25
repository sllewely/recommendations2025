<script lang="ts">
	import type { Snippet } from "svelte";

	interface Props {
		text?: string;
		enabled?: boolean;
		thresholdLength?: number;
		thresholdLines?: number;
		children?: Snippet;
	}

	let {
		text = "",
		enabled = true,
		thresholdLength = 280,
		thresholdLines = 4,
		children,
	}: Props = $props();

	let expanded = $state(false);

	let is_too_long = $derived.by(() => {
		if (!enabled || !text) return false;
		const line_count = (text.match(/\n/g) || []).length + 1;
		return text.length > thresholdLength || line_count > thresholdLines;
	});

	function toggleExpand(e: MouseEvent) {
		e.preventDefault();
		e.stopPropagation();
		expanded = !expanded;
	}
</script>

<div class="relative">
	<div class={is_too_long && !expanded ? "max-h-28 overflow-hidden relative" : "relative"}>
		{@render children?.()}
	</div>

	{#if is_too_long}
		<button
			type="button"
			class="text-sm font-semibold text-teal-400 hover:text-orange-400 hover:underline inline-block mt-1 focus:outline-none cursor-pointer"
			onclick={toggleExpand}
		>
			{expanded ? "read less" : "read more..."}
		</button>
	{/if}
</div>
