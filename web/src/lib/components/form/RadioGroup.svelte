<script lang="ts" module>
	import type { Component } from "svelte";

	export interface RadioOption {
		value: string;
		label: string;
		icon?: Component<any>;
	}
</script>

<script lang="ts">
	import TextField from "$lib/components/TextField.svelte";
	import Button from "$lib/components/Button.svelte";
	import { cn } from "$lib/utils.js";

	interface Props {
		options: readonly RadioOption[];
		value?: string;
		label?: string;
		name?: string;
		other?: string;
		class?: string;
	}

	let { options, value = $bindable(""), label, name, other, class: className }: Props = $props();

	const is_option = (v: string) => options.some((option) => option.value === v);

	let other_picked = $state(!!other && !is_option(value));
	let other_text = $state(other && !is_option(value) ? value : "");

	const pick = (option: RadioOption) => {
		other_picked = false;
		value = option.value;
	};
	const pick_other = () => {
		other_picked = true;
		value = other_text;
	};
</script>

{#if name}
	<input type="hidden" {name} {value} />
{/if}

<div role="radiogroup" aria-label={label} class={cn("flex flex-row flex-wrap gap-2", className)}>
	{#each options as option (option.value)}
		{@const picked = !other_picked && value === option.value}
		{@const Icon = option.icon}
		<Button
			role="radio"
			aria-checked={picked}
			color={picked ? "yellow" : "zinc"}
			variant={picked ? "filled" : "dashed"}
			onclick={() => pick(option)}
		>
			{#if Icon}
				<Icon />
			{/if}
			{option.label}
		</Button>
	{/each}
	{#if other}
		<TextField
			bind:value={other_text}
			oninput={pick_other}
			onfocus={() => {
				if (other_text) pick_other();
			}}
			placeholder={other}
			aria-label={label ? `${label}: ${other}` : other}
			autocomplete="off"
			class={cn(
				"w-40 flex-1",
				other_picked &&
					"border-solid border-yellow-600 focus:border-yellow-600 dark:border-yellow-400 dark:focus:border-yellow-400",
			)}
		/>
	{/if}
</div>
