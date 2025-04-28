<script>
    import H1 from '$lib/components/text/H1.svelte';
    import H2 from '$lib/components/text/H2.svelte';
    import LinkButton from '$lib/components/text/LinkButton.svelte';
    import FeedItem from "$lib/components/posts/FeedItem.svelte";
    import DateHeader from "$lib/components/posts/DateHeader.svelte";
    import EventFeedItem from "$lib/components/posts/EventFeedItem.svelte";
    import Link from "$lib/components/text/Link.svelte";

    let {data} = $props();

</script>

<div>
    <div class="flex justify-center bg-lime-200 border-1 border-gray-800 rounded-sm font-bold p-2 mb-2">
        <Link url="/friends">Add friends!!</Link>
    </div>

    <div>
        <LinkButton color="yellow" url="/recommendations/create">&#10133; Recommendation</LinkButton>
        <LinkButton color="orange" url="/events/create">&#10133; Event</LinkButton>
        <LinkButton color="blue" url="/posts/create">&#10133; Post</LinkButton>
    </div>

    <H1>Posts</H1>

    <div class="grid grid-cols-3">
        <div class="col-span-2 flex flex-col">
            <H2>the feed</H2>
            {#if data.posts.length === 0}
                <div class="flex justify-center bg-lime-200 border-1 border-gray-800 rounded-sm font-bold p-2 mb-2">
                    <p>
                        Your feed is empty!
                        <Link url="/friends">Add friends!!</Link>
                    </p>

                </div>
            {/if}
            {#each data.posts as feed_item}
                <FeedItem feed_item={feed_item}/>
            {/each}

        </div>
        <div class="flex flex-col">
            <H2>Events</H2>
            {#each data.events as event_item}
                {#if !!event_item['date_header']}
                    <DateHeader event_item={event_item}/>
                {:else}
                    <EventFeedItem event_item={event_item}/>
                {/if}
            {/each}
        </div>
    </div>
</div>