<script lang="ts" module>
	const TONES: Record<string, { border: string; open: string }> = {
		Post: {
			border: "border-sky-200/50",
			open: "border-sky-200",
		},
		Event: {
			border: "border-lime-200/50",
			open: "border-lime-200",
		},
		Recommendation: {
			border: "border-fuchsia-200/50",
			open: "border-fuchsia-200",
		},
	};
</script>

<script lang="ts">
	import { SmilePlus } from "@lucide/svelte";
	import { Tooltip } from "bits-ui";
	import {
		type Post,
		type Recommendation,
		type Event,
		REACTS,
		reactToEmoji,
	} from "$lib/api_calls/types";
	import { current_user, isSignedIn } from "$lib/state/current_user.svelte";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import { cn } from "$lib/utils.js";

	interface Props {
		feedable: Post | Recommendation | Event;
	}

	let { feedable }: Props = $props();

	let reactions = $state(feedable.reactions ?? []);
	let picking = $state(false);
	let sending = $state(false);

	let tone = $derived(TONES[feedable.class_name] ?? TONES.Post);
	let signed_in = $derived(isSignedIn());
	let can_save = $derived(
		signed_in && feedable.class_name === "Recommendation" && feedable.user?.id !== current_user.id,
	);
	let saved = $state(false);
	let saving = $state(false);

	const save = async () => {
		if (saved || saving || feedable.class_name !== "Recommendation") return;
		saving = true;
		try {
			const response = await fetch("/api/recommendations/save", {
				method: "POST",
				headers: { "Content-Type": "application/json" },
				body: JSON.stringify({
					title: feedable.title,
					media_type: feedable.media_type,
					url: feedable.url,
					who_recommended: feedable.user?.name,
				}),
			});
			if (response.ok) {
				saved = true;
				newToast("Saved to your recommendations");
			} else {
				newToast("Couldn't save this recommendation", ToastType.Error);
			}
		} finally {
			saving = false;
		}
	};

	let mine = $derived(reactions.find((r) => r.user?.id === current_user.id)?.react);

	// [react, names of who reacted] in the order the emojis are offered
	const reactors = (react: string) =>
		reactions
			.filter((r) => r.react === react)
			.map((r) => (r.user?.id === current_user.id ? "you" : (r.user?.name ?? "")));
	let groups = $derived(
		[...REACTS, ...new Set(reactions.map((r) => r.react).filter((r) => !REACTS.includes(r)))]
			.map((react) => [react, reactors(react)] as const)
			.filter(([, names]) => names.length > 0),
	);

	const react = async (choice: string) => {
		picking = false;
		if (!signed_in || sending || choice === mine) return;
		sending = true;
		const before = reactions;
		// show it straight away; put it back if the server says no
		const me = before.find((r) => r.user?.id === current_user.id)?.user ?? { id: current_user.id };
		reactions = [
			...before.filter((r) => r.user?.id !== current_user.id),
			{ react: choice, user: me },
		];
		try {
			const response = await fetch("/api/reactions/update", {
				method: "POST",
				headers: { "Content-Type": "application/json" },
				body: JSON.stringify({
					react: choice,
					reactable_id: feedable.id,
					reactable_type: feedable.class_name,
				}),
			});
			const json = await response.json().catch(() => null);
			if (!response.ok || !json || json["errors"] || json["error"]) {
				reactions = before;
				newToast("Couldn't react: " + (json?.["errors"] ?? json?.["error"] ?? ""), ToastType.Error);
			}
		} finally {
			sending = false;
		}
	};

	const pill = "inline-flex h-7 items-center border border-dashed text-sm font-normal";
</script>

<svelte:window onkeydown={(e) => e.key === "Escape" && (picking = false)} />

<div class="flex flex-row flex-wrap items-center gap-2.5">
	{#if can_save}
		<button
			type="button"
			class={cn(
				pill,
				tone.border,
				"px-2.5 font-bold",
				saved ? "cursor-default border-solid" : "cursor-pointer hover:border-solid",
			)}
			disabled={saved || saving}
			onclick={save}
		>
			{#if saved}
				saved!
			{:else}
				save
			{/if}
		</button>
	{/if}

	<Tooltip.Provider delayDuration={200}>
		{#each groups as [r, names] (r)}
			<Tooltip.Root>
				<Tooltip.Trigger
					type="button"
					class={cn(
						pill,
						tone.border,
						"gap-1.5 px-2.5",
						signed_in && "cursor-pointer hover:border-solid",
						// yours: solid border, no fill (like "saved!")
						r === mine && "border-solid",
					)}
					aria-pressed={r === mine}
					aria-label={`${reactToEmoji[r] ?? r} ${names.length}${r === mine ? ", yours" : ""}`}
					disabled={!signed_in}
					onclick={() => react(r)}
				>
					<span aria-hidden="true">{reactToEmoji[r] ?? r}</span>
					<span class="tabular-nums" aria-hidden="true">{names.length}</span>
				</Tooltip.Trigger>
				<Tooltip.Portal>
					<Tooltip.Content
						side="top"
						align="center"
						sideOffset={6}
						class="z-50 max-w-64 border border-zinc-600 bg-zinc-700 px-2 py-1 text-center text-xs text-zinc-400 shadow-md"
					>
						{#each names as name, i}{#if i > 0}{" & "}{/if}<span class="text-zinc-100">{name}</span
							>{/each}
					</Tooltip.Content>
				</Tooltip.Portal>
			</Tooltip.Root>
		{/each}
	</Tooltip.Provider>

	{#if signed_in}
		{#if picking}
			<div role="group" aria-label="pick a reaction" class="inline-flex h-7 flex-row">
				{#each REACTS as r, i}
					<button
						type="button"
						class={cn(
							"relative h-full cursor-pointer border border-dashed px-2 text-sm",
							"hover:z-10 hover:border-solid",
							i > 0 && "-ml-px",
							tone.open,
						)}
						aria-label={`react ${reactToEmoji[r]}`}
						onclick={() => react(r)}
					>
						{reactToEmoji[r]}
					</button>
				{/each}
			</div>
		{:else}
			<button
				type="button"
				class={cn(
					pill,
					"cursor-pointer px-2 border-zinc-500/50 text-zinc-500 hover:border-solid hover:border-zinc-300/50 hover:text-zinc-300 dark:border-zinc-400/50 dark:text-zinc-400",
				)}
				aria-label="add a reaction"
				aria-expanded={picking}
				onclick={() => (picking = true)}
			>
				<SmilePlus class="size-4" />
			</button>
		{/if}
	{/if}
</div>
