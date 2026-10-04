<script lang="ts" module>
	export type AudienceMember = {
		type: "user" | "circle";
		id: string;
		name: string;
	};
</script>

<script lang="ts">
	import { Badge } from "$lib/components/ui/badge";
	import { Users, X } from "@lucide/svelte";
	import type { Circle, User } from "$lib/api_calls/types";

	interface Props {
		selected?: AudienceMember[];
	}

	let { selected = $bindable([]) }: Props = $props();

	let query = $state("");
	let suggestions = $state<AudienceMember[]>([]);
	let highlighted = $state(0);
	let input_el = $state<HTMLInputElement>();

	let circles: Circle[] | null = null;
	let request_count = 0;

	const key = (member: AudienceMember) => `${member.type}:${member.id}`;
	let selected_keys = $derived(new Set(selected.map(key)));

	const loadCircles = async (): Promise<Circle[]> => {
		if (circles === null) {
			const response = await fetch("/api/circles");
			circles = response.ok ? await response.json() : [];
		}
		return circles ?? [];
	};

	const search = async (text: string) => {
		const request_id = ++request_count;
		const trimmed = text.trim();
		if (trimmed.length === 0) {
			suggestions = [];
			return;
		}

		const [friends, all_circles] = await Promise.all([
			fetch(`/api/friends/search?search=${encodeURIComponent(trimmed)}`)
				.then((r) => (r.ok ? r.json() : []))
				.catch(() => []),
			loadCircles().catch(() => []),
		]);

		// ignore stale responses
		if (request_id !== request_count) return;

		const lowered = trimmed.toLowerCase();
		const circle_matches: AudienceMember[] = all_circles
			.filter((c) => c.name.toLowerCase().includes(lowered))
			.map((c) => ({ type: "circle", id: c.id, name: c.name }));
		const friend_matches: AudienceMember[] = ((friends ?? []) as User[]).map((f) => ({
			type: "user",
			id: f.id,
			name: f.name,
		}));

		suggestions = [...circle_matches, ...friend_matches].filter((s) => !selected_keys.has(key(s)));
		highlighted = 0;
	};

	const choose = (member: AudienceMember) => {
		if (!selected_keys.has(key(member))) {
			selected = [...selected, member];
		}
		query = "";
		suggestions = [];
		request_count++;
		input_el?.focus();
	};

	const remove = (member: AudienceMember) => {
		selected = selected.filter((m) => key(m) !== key(member));
	};

	const onkeydown = (e: KeyboardEvent) => {
		if ((e.key === "Tab" || e.key === "Enter") && suggestions.length > 0) {
			e.preventDefault();
			choose(suggestions[highlighted] ?? suggestions[0]);
		} else if (e.key === "Enter") {
			// don't submit the form from this box
			e.preventDefault();
		} else if (e.key === "ArrowDown" && suggestions.length > 0) {
			e.preventDefault();
			highlighted = (highlighted + 1) % suggestions.length;
		} else if (e.key === "ArrowUp" && suggestions.length > 0) {
			e.preventDefault();
			highlighted = (highlighted - 1 + suggestions.length) % suggestions.length;
		} else if (e.key === "Escape") {
			suggestions = [];
		} else if (e.key === "Backspace" && query.length === 0 && selected.length > 0) {
			selected = selected.slice(0, -1);
		}
	};
</script>

<div class="relative">
	<div
		class="flex flex-wrap items-center gap-1 rounded-md border border-input bg-background px-2 py-1 min-h-10 cursor-text"
		onclick={() => input_el?.focus()}
		role="presentation"
	>
		{#each selected as member (key(member))}
			<Badge variant={member.type === "circle" ? "secondary" : "default"} class="gap-1">
				{#if member.type === "circle"}
					<Users size={12} />
				{/if}
				{member.name}
				<button
					type="button"
					class="cursor-pointer"
					aria-label={`remove ${member.name}`}
					onclick={(e) => {
						e.stopPropagation();
						remove(member);
					}}
				>
					<X size={12} />
				</button>
			</Badge>
		{/each}
		<input
			bind:this={input_el}
			bind:value={query}
			oninput={() => search(query)}
			{onkeydown}
			onblur={() => (suggestions = [])}
			class="flex-1 min-w-32 bg-transparent outline-none text-sm py-1"
			placeholder={selected.length === 0 ? "Type a friend or circle..." : ""}
			autocomplete="off"
		/>
	</div>

	{#if suggestions.length > 0}
		<ul
			class="absolute z-20 mt-1 w-full rounded-md border border-input bg-background shadow-md max-h-60 overflow-auto"
		>
			{#each suggestions as suggestion, i (key(suggestion))}
				<li>
					<button
						type="button"
						class="flex w-full items-center gap-2 px-3 py-1 text-left text-sm cursor-pointer {i ===
						highlighted
							? 'bg-accent'
							: ''}"
						onmousedown={(e) => {
							// keep focus in the input so blur doesn't clear suggestions first
							e.preventDefault();
							choose(suggestion);
						}}
						onmouseenter={() => (highlighted = i)}
					>
						{#if suggestion.type === "circle"}
							<Users size={14} />
						{/if}
						{suggestion.name}
						{#if suggestion.type === "circle"}
							<span class="text-xs text-muted-foreground">circle</span>
						{/if}
					</button>
				</li>
			{/each}
		</ul>
	{/if}
	<p class="text-xs font-light pt-1">Press Tab to add the highlighted suggestion.</p>
</div>
