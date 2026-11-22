<script lang="ts">
	import ReactButton from "$lib/components/reactions/ReactButton.svelte";
	import {
		type Post,
		type Recommendation,
		type Event,
		type Comment,
		REACTS,
		reactToEmoji,
	} from "$lib/api_calls/types";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import { current_user } from "$lib/state/current_user.svelte";
	import * as Tooltip from "$lib/components/ui/tooltip";
	import { cn } from "$lib/utils.js";

	interface Props {
		feedable: Post | Recommendation | Event | Comment;
	}

	let { feedable }: Props = $props();

	let open_choices = $state(false);

	// a hash of reactor names grouped by react type
	let grouped_reactions = $derived(
		feedable.reactions.reduce<Record<string, string[]>>((groups, reaction) => {
			(groups[reaction.react] ??= []).push(reaction.user.name);
			return groups;
		}, {}),
	);

	let my_reaction = $derived(
		feedable.reactions.find((reaction) => reaction.user.id === current_user.id)?.react ?? "like",
	);

	// the react you've actually picked (my_reaction falls back to "like" for the button)
	let mine = $derived(
		feedable.reactions.find((reaction) => reaction.user.id === current_user.id)?.react,
	);

	// dashed pill styling from the redesign (f6826f0)
	const pill =
		"inline-flex h-7 items-center border border-dashed border-zinc-500 text-sm font-normal dark:border-zinc-400";

	const update_reactions = async (react: String) => {
		console.log(react);
		const response = await fetch("/api/reactions/update", {
			method: "POST",
			headers: {
				"Content-Type": "application/json",
			},
			body: JSON.stringify({
				react: react,
				reactable_id: feedable.id,
				reactable_type: feedable.class_name,
			}),
		});
		const json = await response.json();
		console.log("update_reactions response", json);
		if (json["errors"]) {
			newToast("Error:" + json["errors"], ToastType.Error);
		} else {
			window.location.reload();
			newToast("Updated reaction", ToastType.Success);
		}
	};
</script>

<div class="relative">
	<div
		role="group"
		aria-label="pick a reaction"
		class={cn(
			"absolute -top-9 right-0 z-10 flex h-7 flex-row bg-zinc-100 dark:bg-zinc-800",
			!open_choices && "hidden",
		)}
	>
		{#each REACTS as react, i}
			<ReactButton
				class={cn(i > 0 && "-ml-px")}
				click_handler={() => {
					update_reactions(react);
					open_choices = false;
				}}
				{react}
			/>
		{/each}
	</div>

	<div class="flex flex-row items-center gap-2">
		<Tooltip.Provider delayDuration={200}>
			{#each Object.entries(grouped_reactions) as [react, names]}
				<Tooltip.Root>
					<Tooltip.Trigger>
						{#snippet child({ props })}
							<span {...props} class={cn(pill, "gap-1.5 px-2.5", react === mine && "border-solid")}>
								<span>{reactToEmoji[react] || react}</span>
								<span class="tabular-nums">{names.length}</span>
							</span>
						{/snippet}
					</Tooltip.Trigger>
					<Tooltip.Content
						sideOffset={6}
						class="max-w-64 rounded-none border border-zinc-600 bg-zinc-700 px-2 py-1 text-center text-xs text-zinc-100 shadow-md"
						arrowClasses="hidden"
					>
						<ul>
							{#each names as name}
								<li>{name}</li>
							{/each}
						</ul>
					</Tooltip.Content>
				</Tooltip.Root>
			{/each}
		</Tooltip.Provider>
		<ReactButton
			class="text-zinc-500 hover:border-zinc-600 dark:text-zinc-400 dark:hover:border-zinc-300"
			click_handler={() => {
				open_choices = !open_choices;
			}}
			react={my_reaction}
		/>
	</div>
</div>
