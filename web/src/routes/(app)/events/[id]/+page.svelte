<script lang="ts">
    import H1 from "$lib/components/text/H1.svelte";
    import H2 from "$lib/components/text/H2.svelte";
    import Card from "$lib/components/Card.svelte";
    import PlusCircle from "$lib/components/posts/PlusCircle.svelte";
    import LinkButton from "$lib/components/text/LinkButton.svelte";

    let {data} = $props();
    let user = data.user;
    let event = data.event;


</script>

<div>
    {#if data.my_user_id === event.creator_id}
    <div class="float-right relative">
        <LinkButton url="/events/{event.id}/edit">Edit</LinkButton>
        <LinkButton url="/events/{event.id}/delete">Delete</LinkButton>

    </div>
    {/if}
    <Card>
    <H1>{event.title}</H1>
    <p>{event.description}</p>
    <p>{event.address}</p>
        <p>{event.start_date_string} {event.start_time_string}</p>
    </Card>
</div>