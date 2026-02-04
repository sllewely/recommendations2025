<script lang="ts">
	import { Label as FormsnapLabel } from "formsnap";
	import { Label } from "formsnap";
	import { cn } from "$lib/utils.js";
	import type { ComponentProps } from "svelte";

	type Props = ComponentProps<typeof Label>;

	let { class: className, children, ...restProps }: Props = $props();
</script>

<FormsnapLabel class={cn("font-semibold text-nowrap", className)} {...restProps}>
	{@render children?.()}
</FormsnapLabel>
