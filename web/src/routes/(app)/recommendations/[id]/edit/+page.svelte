<script lang="ts">
	import { enhance } from "$app/forms";
	import Input from "$lib/components/form/Input.svelte";
	import InputCheckbox from "$lib/components/form/InputCheckbox.svelte";
	import FormButton from "$lib/components/form/FormButton.svelte";
	import H1 from "$lib/components/text/H1.svelte";
	import ToggleButton from "$lib/components/form/ToggleButton.svelte";
	import Card from "$lib/components/Card.svelte";

	import { RecommendationStatus } from "$lib/enums";

	let { data, form } = $props();
	let recommendation = data.recommendation;

	let creating = $state(false);
	let starting_status =
		recommendation.status === "interested"
			? RecommendationStatus.Interested
			: recommendation.status === "recommend"
				? RecommendationStatus.Recommend
				: RecommendationStatus.Watching;
	let status = $state(starting_status);

	// TODO:
	// List of types, one can be selected
	// One selected: interested, watching, recommend
	// who recommended appears if interested
	// rating appears if recommend or watching
</script>

<div>
	<H1>Edit your recommendation</H1>

	{#if creating}
		<p>signing in...</p>
	{/if}
	<Card>
		<form
			method="POST"
			action="?/edit_recommendation"
			use:enhance={() => {
				creating = true;
				return async ({ update }) => {
					await update();
					creating = false;
				};
			}}
		>
			<div class="flex flex-col">
				<input type="hidden" name="id" value={recommendation.id} />
				<InputCheckbox
					name="recommendation_only"
					label="Don't post publicly, just save for me (TODO: not implemented):"
				/>
				<Card>
					<Input name="title" label="Title:" value={form?.title ?? recommendation.title} />
					<H1>Recommendation</H1>
					<Input
						name="media_type"
						label="Type:"
						placeholder="book, movie, other"
						value={form?.media_type ?? recommendation.media_type}
						list="mediaTypeList"
					/>
					<datalist id="mediaTypeList">
						<option value="book" />
						<option value="tv show" />
						<option value="movie" />
						<option value="video game" />
						<option value="board game" />
						<option value="artist" />
						<option value="artist, music" />
						<option value="theatre" />
						<option value="food" />
						<option value="article" />
						<option value="author" />
					</datalist>
					<input type="hidden" name="status" value={status} />
					<div>
						<span onclick={() => (status = RecommendationStatus.Interested)}
							><ToggleButton color="yellow" selected={status === RecommendationStatus.Interested}
								>&#10133; Interested</ToggleButton
							></span
						>
						<span onclick={() => (status = RecommendationStatus.Watching)}
							><ToggleButton color="orange" selected={status === RecommendationStatus.Watching}
								>&#10133; Watching</ToggleButton
							></span
						>
						<span onclick={() => (status = RecommendationStatus.Recommend)}
							><ToggleButton color="blue" selected={status === RecommendationStatus.Recommend}
								>&#10133; Recommend</ToggleButton
							></span
						>
					</div>

					<p>TODO: Should be text area</p>
					<Input name="notes" label="Notes:" value={form?.notes ?? recommendation.notes} />
					<Card>
						<H1>Extras</H1>
						<Input name="author" label="Author/Artist/Creator:" />
						<Input name="rating" label="Rating:" placeholder="1-5" />
						<Input name="completed" label="Completed?" placeholder="yes/no" />
						<Input
							name="who_recommended"
							label="Who recommended?:"
							value={form?.who_recommended ?? recommendation.who_recommended}
						/>
					</Card>
				</Card>
			</div>
			<FormButton>Update recommendation</FormButton>
		</form>
	</Card>
</div>
