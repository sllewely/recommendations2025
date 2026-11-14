<script lang="ts">
	import ReactButton from "$lib/components/reactions/ReactButton.svelte";
	import {
		type Post,
		type Recommendation,
		type Event,
		REACTS,
		reactToEmoji,
	} from "$lib/api_calls/types";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import { current_user } from "$lib/state/current_user.svelte";
	import { Badge } from "$lib/components/ui/badge";
	import * as Tooltip from "$lib/components/ui/tooltip";

	interface Props {
		feedable: Post | Recommendation | Event;
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
		class={"flex flex-row gap-2 absolute -top-10 right-0 z-10" + (open_choices ? "" : " hidden")}
	>
		{#each REACTS as react}
			<ReactButton
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
							<span {...props} class="inline-flex">
								<Badge variant="outline" class="gap-1 text-sm font-normal"
									>{reactToEmoji[react] || react} {names.length}</Badge
								>
							</span>
						{/snippet}
					</Tooltip.Trigger>
					<Tooltip.Content>
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
			class="h-6 px-1.5"
			click_handler={() => {
				open_choices = !open_choices;
			}}
			react={my_reaction}
		/>
	</div>
</div>
