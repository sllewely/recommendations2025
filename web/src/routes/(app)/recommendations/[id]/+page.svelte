<script lang="ts">
    import H1 from "$lib/components/text/H1.svelte";

    let {data} = $props();
    let recommendation = data.recommendation;
</script>

<div>
    <H1>{recommendation.title}</H1>
</div>