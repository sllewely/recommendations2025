<script lang="ts">
	import ReactButton from "$lib/components/reactions/ReactButton.svelte";
	import { type Post, type Recommendation, type Event } from "$lib/api_calls/types";
	import { newToast, ToastType } from "$lib/state/toast.svelte";

	interface Props {
		feedable: Post | Recommendation | Event;
	}

	let { feedable }: Props = $props();

	const REACTS = ["like", "heart", "celebrate"];

	let open_choices = $state(false);

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

	<ReactButton
		click_handler={() => {
			open_choices = !open_choices;
		}}
		react="like"
	/>
</div>
