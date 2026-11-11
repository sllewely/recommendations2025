<script lang="ts">
	import type { Snippet } from "svelte";

	interface Props {
		text?: string;
		enabled?: boolean;
		thresholdLength?: number;
		thresholdLines?: number;
		collapsedClass?: string;
		buttonClass?: string;
		children?: Snippet;
	}

	let {
		text = "",
		enabled = true,
		thresholdLength = 280,
		thresholdLines = 4,
		collapsedClass = "max-h-28",
		buttonClass = "text-sm mt-1",
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
	<!-- with a read more button, drop the bottom margin of the last markdown block so the
	     button sits right under the text (important to beat MarkedDownPost's unlayered styles) -->
	<div
		class={is_too_long
			? `relative [&_section>:last-child]:mb-0! ${expanded ? "" : `${collapsedClass} overflow-clip`}`
			: "relative"}
	>
		{@render children?.()}
	</div>

	{#if is_too_long}
		<button
			type="button"
			class="{buttonClass} font-semibold text-teal-400 hover:text-orange-400 hover:underline block w-fit focus:outline-none cursor-pointer"
			onclick={toggleExpand}
		>
			{expanded ? "read less" : "read more..."}
		</button>
	{/if}
</div>
