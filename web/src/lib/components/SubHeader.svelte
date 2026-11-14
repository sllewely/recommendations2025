<script lang="ts">
	import type { Snippet } from "svelte";
	import { getSubheaderSlot } from "$lib/state/subheader.svelte";

	let { children }: { children: Snippet } = $props();

	const slot = getSubheaderSlot();
	const owner = Symbol("subheader");
	slot.content = children;
	slot.owner = owner;

	$effect(() => {
		slot.content = children;
		slot.owner = owner;
		return () => {
			if (slot.owner === owner) {
				slot.content = null;
				slot.owner = null;
			}
		};
	});
</script>
