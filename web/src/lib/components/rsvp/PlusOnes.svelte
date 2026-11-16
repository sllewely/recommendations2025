<script lang="ts">
	import { Button } from "$lib/components/ui/button";
	import { Input } from "$lib/components/ui/input";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import { invalidateAll } from "$app/navigation";
	import { X } from "lucide-svelte";
	import type { PlusOne } from "$lib/api_calls/types";

	let {
		event_id,
		my_plus_ones,
	}: {
		event_id: string;
		// the +1s the viewer added
		my_plus_ones: PlusOne[];
	} = $props();

	let adding = $state(false);
	let name = $state("");
	let saving = $state(false);

	const add = async (e: SubmitEvent) => {
		e.preventDefault();
		if (!name.trim()) return;
		saving = true;
		const response = await fetch("/api/plus_ones", {
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify({ event_id, name: name.trim() }),
		});
		const res = await response.json();
		saving = false;
		if (!res.success) {
			newToast("Error adding a +1: " + res.message, ToastType.Error);
			return;
		}
		name = "";
		adding = false;
		await invalidateAll();
	};

	const remove = async (plus_one: PlusOne) => {
		const response = await fetch("/api/plus_ones/delete", {
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify({ id: plus_one.id }),
		});
		const res = await response.json();
		if (!res.success) {
			newToast("Error removing a +1: " + res.message, ToastType.Error);
			return;
		}
		await invalidateAll();
	};
</script>

<div class="flex flex-row flex-wrap items-center gap-2">
	{#each my_plus_ones as plus_one (plus_one.id)}
		<span class="inline-flex items-center gap-1 rounded-full border px-2 py-0.5 text-xs">
			+1 {plus_one.name}
			<button
				type="button"
				class="cursor-pointer"
				aria-label="remove {plus_one.name}"
				onclick={() => remove(plus_one)}
			>
				<X class="size-3" />
			</button>
		</span>
	{/each}
	{#if adding}
		<form class="flex flex-row items-center gap-2" onsubmit={add}>
			<Input
				class="h-8 w-40"
				placeholder="Their name"
				aria-label="+1's name"
				maxlength={60}
				bind:value={name}
			/>
			<Button type="submit" size="sm" disabled={!name.trim() || saving}>Add</Button>
			<Button type="button" size="sm" variant="ghost" onclick={() => (adding = false)}>
				Cancel
			</Button>
		</form>
	{:else}
		<!-- styled like Link -->
		<button
			type="button"
			class="cursor-pointer text-xs text-teal-400 hover:text-orange-400"
			onclick={() => (adding = true)}
		>
			add a plus one
		</button>
	{/if}
</div>
