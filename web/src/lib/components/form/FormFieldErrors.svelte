<script lang="ts">
	import { FieldErrors as FormsnapFieldErrors } from "formsnap";
	import { cn } from "$lib/utils.js";
	import type { ComponentProps } from "svelte";

	type Props = ComponentProps<typeof FormsnapFieldErrors>;

	let { class: className, ...restProps }: Props = $props();
</script>

<FormsnapFieldErrors class={cn("font-light text-red-500 text-sm", className)} {...restProps} />
