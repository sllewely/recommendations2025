<script lang="ts">
    import Card from '$lib/components/Card.svelte';
    import Link from '$lib/components/text/Link.svelte';
    import H2 from "$lib/components/text/H2.svelte";
    import RecommendationCard from "$lib/components/posts/RecommendationCard.svelte";
    import PostCard from "$lib/components/posts/PostCard.svelte";
    import EventCard from "$lib/components/posts/EventCard.svelte";

    import * as Collapsible from "$lib/components/ui/collapsible";

    let {feed_item} = $props();

    let by_line = ' posted';

    let border_color = "border-orange-500";
    if (feed_item.class_name === 'Event') {
        border_color = "border-blue-500";
        by_line = ' posted an upcoming event'
    } else {
        border_color = "border-orange-500";
    }


    //TODO: different component based on which type


</script>
<div class="p-2 my-2 border-bottom-2 border-gray-600 rounded-lg shadow-md">
    <Collapsible.Root>
        {#if feed_item.class_name === 'Recommendation'}
            <RecommendationCard feed_item={feed_item}/>
        {:else if feed_item.class_name === 'Post'}
            <PostCard feed_item={feed_item}/>

        {:else}
            <div>

                <EventCard feed_item={feed_item}/>
            </div>
        {/if}
        <Collapsible.Trigger>
            Comments
        </Collapsible.Trigger>
        <Collapsible.Content>
            I had some thoughts about this
        </Collapsible.Content>

    </Collapsible.Root>
</div>