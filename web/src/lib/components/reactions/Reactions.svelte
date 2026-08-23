<script lang="ts">
	import ReactButton from "$lib/components/reactions/ReactButton.svelte";
	import { type Post, type Recommendation, type Event } from "$lib/api_calls/types";
	import { newToast, ToastType } from "$lib/state/toast.svelte";
	import { current_user, isSignedIn } from "$lib/state/current_user.svelte";

	interface Props {
		feedable: Post | Recommendation | Event;
	}

	let { feedable }: Props = $props();

	const REACTS = ["like", "heart", "celebrate"];

	let open_choices = $state(false);

	// a hash of reactions counts grouped by react type
	let grouped_reactions = $derived(
		feedable.reactions.reduce<Record<string, number>>((counts, reaction) => {
			counts[reaction.react] = (counts[reaction.react] ?? 0) + 1;
			return counts;
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
	<div class={"flex flex-row gap-2 absolute -top-10" + (open_choices ? "" : " hidden")}>
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

	<div class="flex flex-row gap-2">
		<ReactButton
			click_handler={() => {
				open_choices = !open_choices;
			}}
			react={my_reaction}
		/>
		{#each Object.entries(grouped_reactions) as [react, count]}
			<span>{react}: {count}</span>
		{/each}
	</div>
</div>
