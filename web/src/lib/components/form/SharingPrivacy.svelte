<script lang="ts" module>
	export const SHARING_PRIVACY_OPTIONS = [
		{ value: "public", label: "Public to Bumblebeans" },
		{ value: "friends", label: "Friends only" },
		// TODO: third option coming later
	] as const;

	export type SharingPrivacyValue = (typeof SHARING_PRIVACY_OPTIONS)[number]["value"];
</script>

<script lang="ts">
	import * as Collapsible from "$lib/components/ui/collapsible";
	import { ChevronDown, ChevronRight } from "@lucide/svelte";

	interface Props {
		value?: SharingPrivacyValue;
		name?: string;
		open?: boolean;
	}

	let { value = $bindable("public"), name = "privacy", open = $bindable(false) }: Props = $props();

	let selected_label = $derived(
		SHARING_PRIVACY_OPTIONS.find((option) => option.value === value)?.label ?? "",
	);
</script>

<Collapsible.Root bind:open>
	<Collapsible.Trigger type="button" class="flex items-center gap-2 cursor-pointer">
		{#if open}
			<ChevronDown size={16} />
		{:else}
			<ChevronRight size={16} />
		{/if}
		<span class="font-bold">Privacy</span>
		<span>{selected_label}</span>
	</Collapsible.Trigger>
	<Collapsible.Content>
		<div class="flex flex-col gap-2 pt-2 pl-6">
			{#each SHARING_PRIVACY_OPTIONS as option}
				<label class="flex items-center gap-2 cursor-pointer">
					<input type="radio" {name} value={option.value} bind:group={value} />
					{option.label}
				</label>
			{/each}
		</div>
	</Collapsible.Content>
</Collapsible.Root>
