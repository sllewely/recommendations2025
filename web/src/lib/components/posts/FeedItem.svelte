<script lang="ts">
    import Card from '$lib/components/Card.svelte';
    import Link from '$lib/components/text/Link.svelte';
    import H2 from "$lib/components/text/H2.svelte";
    import PlusCircle from "$lib/components/posts/PlusCircle.svelte";

    let {feed_item} = $props();

    let by_line = ' posted';

    let border_color = "border-orange-500";
    if (feed_item.class_name === 'Recommendation') {
        border_color = "border-yellow-500";
        if (feed_item.status === 'watching') {
            by_line = ' is watching';
        } else if (feed_item.status === 'recommend') {
            by_line = ' recommends';
        } else {
            by_line = ' is interested in';
        }
    } else if (feed_item.class_name === 'Event') {
        border_color = "border-blue-500";
        by_line = ' posted an upcoming event'
    } else {
        border_color = "border-orange-500";
    }


    //TODO: different component based on which type



</script>
<div>
    {#if feed_item.class_name === 'Recommendation'}
    <div class="float-right relative">
        <div class="absolute top-0 right-0">
<PlusCircle />
        </div></div>
        {/if}
<div class="p-2">

    <Card border_color={border_color}>

        <div class="flex flex-row justify-between pb-2">
            <div><span class="font-bold"><Link url="/users/{feed_item.creator_id}">{feed_item.creator_name}</Link></span> {by_line}</div>
            <div><span class="text-sm">at {feed_item.create_date_string} {feed_item.create_time_string}</span></div>
        </div>
        <H2>{feed_item.title ?? feed_item.post_title}</H2>
        {#if feed_item.notes ?? feed_item.content}
            <p>{feed_item.notes ?? feed_item.content}</p>
        {/if}
        {#if feed_item.start_date_string}
            <p>Happening {feed_item.start_date_string} - {feed_item.start_time_string}</p>
        {/if}
        {#if feed_item.address}
            <p>at {feed_item.address}</p>
        {/if}



    </Card>
</div>
    </div>