<script lang="ts">
    import H1 from "$lib/components/text/H1.svelte";
    import H2 from "$lib/components/text/H2.svelte";
    import Card from "$lib/components/Card.svelte";
    import PlusCircle from "$lib/components/posts/PlusCircle.svelte";
    import LinkButton from "$lib/components/text/LinkButton.svelte";

    let {data} = $props();
    let user = data.user;
    let recommendation = data.recommendation;

    console.log(user);
    console.log(data.my_user_id);


</script>

<div>
    {#if data.my_user_id.toString() === user.id.toString()}
        <div class="float-right relative">
            <LinkButton url="/recommendations/{recommendation.id}/edit">Edit</LinkButton>
            <LinkButton url="/recommendations/{recommendation.id}/delete">Delete</LinkButton>

        </div>
    {/if}
    <H2>{user.name}'s recommendation</H2>
    <Card>
        <H1>{recommendation.title}</H1>
        <p>{recommendation.media_type}</p>
        <p>{recommendation.notes}</p>
        <p>Who recommended? {recommendation.who_recommended}</p>
        <p>Added: {recommendation.create_date_string}</p>
    </Card>
</div>