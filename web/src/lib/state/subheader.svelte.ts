import { getContext, setContext, type Snippet } from "svelte";

type Slot = { content: Snippet | null; owner: symbol | null };

const KEY = Symbol("subheader");

export function createSubheaderSlot(): Slot {
	const slot = $state<Slot>({ content: null, owner: null });
	setContext(KEY, slot);
	return slot;
}

export function getSubheaderSlot(): Slot {
	return getContext<Slot>(KEY);
}
