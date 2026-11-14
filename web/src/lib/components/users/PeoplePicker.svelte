<script lang="ts" module>
	export type PickedPerson = {
		type: "user" | "circle";
		id: string;
		name: string;
		profile_photo_url?: string;
		members?: string[];
	};
</script>

<script lang="ts">
	import type { Snippet } from "svelte";
	import type { Circle, User } from "$lib/api_calls/types";
	import TextField from "$lib/components/TextField.svelte";
	import UserList from "$lib/components/users/UserList.svelte";
	import PickAction from "$lib/components/users/PickAction.svelte";

	interface Props {
		picked?: PickedPerson[];
		id?: string;
		name: string;
		circles_name?: string;
		placeholder?: string;
		add_label?: string;
		picked_subtitle?: string;
		children?: Snippet;
	}

	let {
		picked = $bindable([]),
		id,
		name,
		circles_name,
		placeholder = "search your friends",
		add_label = "add",
		picked_subtitle = "added!",
		children,
	}: Props = $props();

	const DEBOUNCE_MS = 250;

	let query = $state("");
	let results = $state<PickedPerson[]>([]);
	let timer: ReturnType<typeof setTimeout> | undefined;
	let request = 0;
	let circles: Circle[] | null = null;

	const key = (p: PickedPerson) => `${p.type}:${p.id}`;
	let picked_keys = $derived(new Set(picked.map(key)));
	let shown = $derived(results.filter((r) => !picked_keys.has(key(r))));

	const CIRCLE = "circle:";
	const as_user = (p: PickedPerson) =>
		({
			id: p.type === "circle" ? CIRCLE + p.id : p.id,
			name: p.name,
			profile_photo_url: p.profile_photo_url,
		}) as User;
	const is_circle = (user: User) => user.id.startsWith(CIRCLE);
	let rows = $derived([...picked, ...shown].map(as_user));
	const find = (list: PickedPerson[], user: User) => list.find((p) => as_user(p).id === user.id);

	const search = async (text: string) => {
		const this_request = ++request;
		const lowered = text.toLowerCase();
		const [friends, all_circles] = await Promise.all([
			fetch(`/api/friends/search?search=${encodeURIComponent(text)}`)
				.then((r) => (r.ok ? r.json() : []))
				.catch(() => []),
			circles_name ? load_circles() : Promise.resolve([] as Circle[]),
		]);
		if (this_request !== request) return;
		results = [
			...all_circles
				.filter((c) => c.name.toLowerCase().includes(lowered))
				.map((c): PickedPerson => ({
					type: "circle",
					id: c.id,
					name: c.name,
					members: (c.members ?? []).map((m) => m.name),
				})),
			...((friends ?? []) as User[]).map((f): PickedPerson => ({
				type: "user",
				id: f.id,
				name: f.name,
				profile_photo_url: f.profile_photo_url,
			})),
		];
	};

	const load_circles = async (): Promise<Circle[]> => {
		if (circles === null) {
			const response = await fetch("/api/circles").catch(() => null);
			circles = response?.ok ? await response.json() : [];
		}
		return circles ?? [];
	};

	const on_input = () => {
		clearTimeout(timer);
		const text = query.trim();
		if (!text) {
			request++;
			results = [];
			return;
		}
		timer = setTimeout(() => search(text), DEBOUNCE_MS);
	};
	$effect(() => () => clearTimeout(timer));

	const add = (person: PickedPerson) => {
		if (!picked_keys.has(key(person))) picked = [...picked, person];
	};
	const remove = (person: PickedPerson) => {
		picked = picked.filter((p) => key(p) !== key(person));
	};
	const add_user = (user: User) => {
		const person = find(shown, user);
		if (person) add(person);
	};
	const remove_user = (user: User) => {
		const person = find(picked, user);
		if (person) remove(person);
	};
	const is_picked = (user: User) => !!find(picked, user);
	const is_static = is_picked;

	const onkeydown = (e: KeyboardEvent) => {
		if (e.key === "Enter") {
			e.preventDefault();
			if (shown[0]) add(shown[0]);
		} else if (e.key === "Escape") {
			query = "";
			on_input();
		}
	};
</script>

{#each picked as person (key(person))}
	<input type="hidden" name={person.type === "circle" ? circles_name : name} value={person.id} />
{/each}

<div class="flex flex-col gap-3">
	<TextField
		{id}
		bind:value={query}
		oninput={on_input}
		{onkeydown}
		{placeholder}
		autocomplete="off"
	/>

	{#if rows.length > 0}
		<UserList
			users={rows}
			onselect={add_user}
			{is_static}
			trailing={PickAction}
			trailing_props={{ is_picked, add_label, onadd: add_user, onremove: remove_user }}
			user_subtitle={row_subtitle}
		/>
	{/if}

	{@render children?.()}
</div>

{#snippet circle_size(user: User)}
	{@const members = find([...picked, ...shown], user)?.members ?? []}
	circle of {members.length}
{/snippet}

{#snippet row_subtitle(user: User)}
	{#if is_circle(user)}{@render circle_size(user)}{/if}
	{#if is_circle(user) && is_picked(user)}·{/if}
	{#if is_picked(user)}{picked_subtitle}{/if}
{/snippet}
