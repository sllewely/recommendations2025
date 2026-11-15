<script lang="ts" generics="T extends Record<string, unknown>">
	import type { Snippet, ComponentProps } from "svelte";
	import type { FormPath, SuperForm } from "sveltekit-superforms";
	import { Field, Control, Label, Description, FieldErrors } from "formsnap";
	import TextField from "$lib/components/TextField.svelte";
	import FormRow from "$lib/components/form/FormRow.svelte";

	type Props = Omit<ComponentProps<typeof TextField>, "form" | "name" | "children"> & {
		form: SuperForm<T>;
		name: FormPath<T>;
		label: string;
		description?: string;
		control?: Snippet<[{ props: Record<string, unknown> }]>;
		children?: Snippet;
	};

	let {
		form,
		name,
		label,
		description,
		control,
		children: hint,
		value = $bindable(),
		...rest
	}: Props = $props();
</script>

<Field {form} {name}>
	<Control>
		{#snippet children({ props })}
			<FormRow>
				{#snippet info()}
					<Label>{label}</Label>
					{#if description}
						<Description class="text-xs text-zinc-500 dark:text-zinc-400">{description}</Description
						>
					{/if}
				{/snippet}
				{#if control}
					{@render control({ props })}
				{:else}
					<TextField {...props} {...rest} bind:value />
				{/if}
				{@render hint?.()}
				<FieldErrors class="text-sm text-red-600 dark:text-red-400" />
			</FormRow>
		{/snippet}
	</Control>
</Field>
