<script lang="ts">
    import Card from '$lib/components/Card.svelte';
    import Link from '$lib/components/text/Link.svelte';
    import H2 from "$lib/components/text/H2.svelte";

    let {feed_item} = $props();

    let by_line = ' posted';
    if (feed_item.class_name === 'Recommendation') {
        if (feed_item.status === 'watching') {
            by_line = ' is watching';
        } else if (feed_item.status === 'recommend') {
            by_line = ' recommends';
        } else {
            by_line = ' is interested in';
        }
    } else if (feed_item.class_name === 'Event') {
        by_line = ' posted an upcoming event'
    }



</script>
<div class="p-2">
    <Card>
        <div class="flex flex-row justify-between">
            <div><Link url="/users/{feed_item.creator_id}">{feed_item.creator_name}</Link> {by_line}</div>
            <div>at {feed_item.create_date_string} {feed_item.create_time_string}</div>
        </div>
        <H2>{feed_item.title ?? feed_item.post_title}</H2>
        {#if feed_item.notes ?? feed_item.content}
            <p>{feed_item.notes ?? feed_item.content}</p>
        {/if}

    </Card>
</div>