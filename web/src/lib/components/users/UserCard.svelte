<script lang="ts" module>
	const SIZES = {
		xs: { avatar: "h-6", gap: "gap-1.5", text: "text-sm", sub: "text-xs leading-tight" },
		sm: { avatar: "h-8", gap: "gap-1.5", text: "text-sm", sub: "text-xs leading-tight" },
		md: { avatar: "h-12", gap: "gap-2.5", text: "leading-tight", sub: "text-xs leading-none" },
		lg: { avatar: "h-16", gap: "gap-3", text: "text-lg", sub: "text-sm" },
	} as const;
</script>

<script lang="ts">
	import type { Snippet } from "svelte";
	import type { User } from "$lib/api_calls/types";
	import Avatar from "$lib/components/users/Avatar.svelte";
	import { cn } from "$lib/utils.js";

	interface Props {
		user: User;
		size?: keyof typeof SIZES;
		subtitle?: Snippet;
		onclick?: () => void;
		static?: boolean;
		label?: string;
		dashed?: boolean;
		name_class?: string;
	}

	let {
		user,
		size = "md",
		subtitle,
		onclick,
		static: is_static = false,
		name_class,
		label,
		dashed = false,
	}: Props = $props();

	let s = $derived(SIZES[size]);
</script>

{#snippet contents()}
	<Avatar {user} class={s.avatar} {dashed} />
	<span class="flex min-w-0 flex-col items-start">
		<span class={cn("max-w-full truncate text-yellow-400", s.text, name_class)}
			>{label ?? user.name}</span
		>
		{#if subtitle}
			<span class={cn("max-w-full truncate", s.sub)}>{@render subtitle()}</span>
		{/if}
	</span>
{/snippet}

{#if is_static}
	<div class={cn("flex w-fit min-w-0 max-w-full flex-row items-center", s.gap)}>
		{@render contents()}
	</div>
{:else if onclick}
	<button
		type="button"
		{onclick}
		class={cn(
			"flex w-fit min-w-0 max-w-full cursor-pointer flex-row items-center text-left",
			s.gap,
		)}
	>
		{@render contents()}
	</button>
{:else}
	<a
		href={`/users/${user.id}`}
		class={cn("flex w-fit min-w-0 max-w-full flex-row items-center", s.gap)}
	>
		{@render contents()}
	</a>
{/if}
