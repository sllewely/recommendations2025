<script lang="ts">
	import SubHeader from "$lib/components/SubHeader.svelte";
	import SubHeaderTitle from "$lib/components/SubHeaderTitle.svelte";
	import RecommendationForm from "../../RecommendationForm.svelte";

	let { data, form } = $props();
</script>

<SubHeader>
	<SubHeaderTitle title="edit recommendation" />
</SubHeader>

<RecommendationForm recommendation={data.recommendation} {form} />
