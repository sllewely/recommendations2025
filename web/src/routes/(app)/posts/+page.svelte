<script>
    import H1 from '$lib/components/text/H1.svelte';
    import H2 from '$lib/components/text/H2.svelte';
    import Link from '$lib/components/text/Link.svelte';
    import LinkButton from '$lib/components/text/LinkButton.svelte';
    import Card from '$lib/components/Card.svelte'
    import FeedItem from "$lib/components/posts/FeedItem.svelte";
    import EventCard from "$lib/components/posts/EventCard.svelte";
    import DateHeader from "./DateHeader.svelte";
    import RecommendationCard from '$lib/components/posts/RecommendationCard.svelte'
    import EventFeedItem from "$lib/components/posts/EventFeedItem.svelte";

    let { data } = $props();

</script>


<div>
    <LinkButton color="yellow" url="/recommendations/create">&#10133; Recommendation</LinkButton>
    <LinkButton color="orange" url="/events/create">&#10133; Event</LinkButton>
    <LinkButton color="blue" url="/posts/create">&#10133; Post</LinkButton>
</div>

<H1>Posts</H1>

<div class="grid grid-cols-3">
<div class="col-span-2 flex flex-col">
    <H2>the feed</H2>
    {#each data.posts as feed_item}
        <FeedItem feed_item={feed_item} />
    {/each}

</div>
    <div class="flex flex-col">
        <H2>Events</H2>
        {#each data.events as event_item}
            {#if !!event_item['date_header']}
                {console.log(event_item)}
                <DateHeader event_item={event_item} />
            {:else}
                <EventFeedItem event_item={event_item}/>
            {/if}
        {/each}
    </div>
</div>