<script lang="ts" module>
	export const SHARING_PRIVACY_OPTIONS = [
		{ value: "public", label: "public to bumblebeans" },
		{ value: "friends", label: "friends only" },
		{ value: "specific", label: "only specific people" },
	] as const;

	export type SharingPrivacyValue = (typeof SHARING_PRIVACY_OPTIONS)[number]["value"];
</script>

<script lang="ts">
	import PeoplePicker, { type PickedPerson } from "$lib/components/users/PeoplePicker.svelte";
	import FormRow from "./FormRow.svelte";
	import RadioGroup from "./RadioGroup.svelte";

	interface Props {
		value?: SharingPrivacyValue;
		name?: string;
		audience?: PickedPerson[];
		user_ids_name?: string;
		circle_ids_name?: string;
	}

	let {
		value = $bindable("public"),
		name = "privacy",
		audience = $bindable([]),
		user_ids_name = "privacy_user_ids",
		circle_ids_name = "privacy_circle_ids",
	}: Props = $props();
</script>

<FormRow label="privacy" description="who can see it">
	<RadioGroup
		label="privacy"
		{name}
		options={SHARING_PRIVACY_OPTIONS}
		bind:value={() => value, (v) => (value = v as SharingPrivacyValue)}
	/>
	{#if value === "specific"}
		<PeoplePicker
			name={user_ids_name}
			circles_name={circle_ids_name}
			placeholder="search your friends and circles"
			picked_subtitle="can see it"
			bind:picked={audience}
		/>
	{/if}
</FormRow>
