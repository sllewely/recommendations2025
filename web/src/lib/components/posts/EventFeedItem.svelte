<script lang="ts">
    import Card from "$lib/components/Card.svelte";
    import Link from "$lib/components/text/Link.svelte";
    import H2 from "$lib/components/text/H2.svelte";

    let {event_item} = $props();
</script>

<div class="p-2">
<Card>
    <H2>{event_item.title}</H2>
    <p>posted by <Link url="/users/{event_item.creator_id}">{event_item.creator_name}</Link></p>
    {#if event_item.description}
        <p>{event_item.description}</p>
    {/if}
    <p>{event_item['time_string']}</p>
    {#if event_item.url}
        <p><Link url={event_item.url}></Link></p>
    {/if}

</Card>
</div>