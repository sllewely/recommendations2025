<script lang="ts">
	import RecommendationForm from "../RecommendationForm.svelte";

	let { data, form } = $props();
</script>

<div>
	<RecommendationForm {data} {form} />
</div>
