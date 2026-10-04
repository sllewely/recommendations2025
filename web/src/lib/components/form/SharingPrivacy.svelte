<script lang="ts" module>
	export const SHARING_PRIVACY_OPTIONS = [
		{ value: "public", label: "Public to Bumblebeans" },
		{ value: "friends", label: "Friends only" },
		{ value: "specific", label: "Only specific people" },
	] as const;

	export type SharingPrivacyValue = (typeof SHARING_PRIVACY_OPTIONS)[number]["value"];
</script>

<script lang="ts">
	import * as Collapsible from "$lib/components/ui/collapsible";
	import { ChevronDown, ChevronRight } from "@lucide/svelte";
	import AudiencePicker, { type AudienceMember } from "./AudiencePicker.svelte";

	interface Props {
		value?: SharingPrivacyValue;
		name?: string;
		open?: boolean;
		audience?: AudienceMember[];
		user_ids_name?: string;
		circle_ids_name?: string;
	}

	let {
		value = $bindable("public"),
		name = "privacy",
		open = $bindable(false),
		audience = $bindable([]),
		user_ids_name = "privacy_user_ids",
		circle_ids_name = "privacy_circle_ids",
	}: Props = $props();

	let selected_label = $derived.by(() => {
		if (value === "specific" && audience.length > 0) {
			return "Only " + audience.map((member) => member.name).join(", ");
		}
		return SHARING_PRIVACY_OPTIONS.find((option) => option.value === value)?.label ?? "";
	});
</script>

<!-- form values live outside Collapsible.Content so they're submitted while collapsed -->
<input type="hidden" {name} {value} />
{#if value === "specific"}
	{#each audience as member (`${member.type}:${member.id}`)}
		<input
			type="hidden"
			name={member.type === "circle" ? circle_ids_name : user_ids_name}
			value={member.id}
		/>
	{/each}
{/if}

<Collapsible.Root bind:open>
	<Collapsible.Trigger type="button" class="flex items-center gap-2 cursor-pointer">
		{#if open}
			<ChevronDown size={16} />
		{:else}
			<ChevronRight size={16} />
		{/if}
		<span class="font-bold">Privacy</span>
		<span class="truncate">{selected_label}</span>
	</Collapsible.Trigger>
	<Collapsible.Content>
		<div class="flex flex-col gap-2 pt-2 pl-6">
			{#each SHARING_PRIVACY_OPTIONS as option}
				<label class="flex items-center gap-2 cursor-pointer">
					<input type="radio" value={option.value} bind:group={value} />
					{option.label}
				</label>
			{/each}
			{#if value === "specific"}
				<AudiencePicker bind:selected={audience} />
			{/if}
		</div>
	</Collapsible.Content>
</Collapsible.Root>
