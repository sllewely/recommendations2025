<script lang="ts">
    import H1 from "$lib/components/text/H1.svelte";
    import H2 from "$lib/components/text/H2.svelte";
    import Card from "$lib/components/Card.svelte";

    let {data} = $props();
    let user = data.user;
    let recommendation = data.recommendation;


</script>

<div>
    <H2>{user.name}'s recommendation</H2>
    <Card>
    <H1>{recommendation.title}</H1>
    <p>{recommendation.media_type}</p>
    <p>{recommendation.notes}</p>
    <p>Who recommended? {recommendation.who_recommended}</p>
    <p>Added: {recommendation.create_date_string}</p>
    </Card>
</div>