<script lang="ts">
	import Button from "$lib/components/Button.svelte";
	import { cn } from "$lib/utils.js";

	interface Props {
		options: readonly { value: string; label: string }[];
		value?: string[];
		label?: string;
		onchange?: (value: string[]) => void;
		class?: string;
	}

	let { options, value = $bindable([]), label, onchange, class: className }: Props = $props();

	const toggle = (option: string) => {
		const next = value.includes(option) ? value.filter((v) => v !== option) : [...value, option];
		value = next.length === options.length ? [] : next;
		onchange?.(value);
	};
</script>

<div role="group" aria-label={label} class={cn("flex flex-row flex-wrap gap-2", className)}>
	{#each options as option (option.value)}
		{@const on = value.includes(option.value)}
		<Button
			aria-pressed={on}
			color={on ? "yellow" : "zinc"}
			variant={on ? "filled" : "dashed"}
			onclick={() => toggle(option.value)}
		>
			{option.label}
		</Button>
	{/each}
</div>
