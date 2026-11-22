<script lang="ts">
	import { cn } from "$lib/utils.js";
	import { reactToEmoji } from "$lib/api_calls/types";

	interface Props {
		react: string;
		selected?: boolean;
		click_handler: () => void;
		class?: string;
	}

	let { react, selected, click_handler, class: className }: Props = $props();
</script>

<button
	type="button"
	class={cn(
		"relative inline-flex h-7 cursor-pointer items-center border border-dashed border-zinc-500 px-2 text-sm hover:z-10 hover:border-solid dark:border-zinc-400",
		className,
	)}
	onclick={click_handler}
>
	<span>{reactToEmoji[react] || react}</span>
</button>
