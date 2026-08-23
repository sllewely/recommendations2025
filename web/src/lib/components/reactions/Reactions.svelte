<script lang="ts">
	import ReactButton from "$lib/components/reactions/ReactButton.svelte";
	import { type Post, type Recommendation, type Event } from "$lib/api_calls/types";

	interface Props {
		feedable: Post | Recommendation | Event;
	}

	const REACTS = ["like", "heart", "celebrate"];

	let open_choices = $state(false);

	const update_reactions = async (react: String) => {
		return () => {
			console.log(react);
		};
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
