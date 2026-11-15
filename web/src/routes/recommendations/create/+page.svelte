<script lang="ts">
	import SubHeader from "$lib/components/SubHeader.svelte";
	import SubHeaderTitle from "$lib/components/SubHeaderTitle.svelte";
	import RecommendationForm from "../RecommendationForm.svelte";

	let { form } = $props();
</script>

<SubHeader>
	<SubHeaderTitle
		title="save a recommendation"
		caption="save the things you love, track what you want to enjoy next, share interests with your friends"
	/>
</SubHeader>

<RecommendationForm {form} />
