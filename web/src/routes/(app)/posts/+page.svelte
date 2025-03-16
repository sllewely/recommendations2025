<script>
    import H1 from '$lib/components/text/H1.svelte';
    import H2 from '$lib/components/text/H2.svelte';
    import Link from '$lib/components/text/Link.svelte';
    import LinkButton from '$lib/components/text/LinkButton.svelte';
    import Card from '$lib/components/Card.svelte'
    import FeedItem from "./FeedItem.svelte";

    let { data } = $props();

    //TODO: display dates above events
</script>


<H1>Posts</H1>
<div>
    <LinkButton color="yellow" url="/recommendations/create">&#10133; Recommendation</LinkButton>
    <LinkButton color="orange" url="/events/create">&#10133; Event</LinkButton>
    <LinkButton color="blue" url="/posts/create">&#10133; Post</LinkButton>
</div>
<h2><Link url="/posts/create">create a post</Link></h2>

<h1>res:</h1>
<h2>{data.jwt}</h2>
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
            {#if event_item['date_header']}
                <Card>
                    <H2>{event_item['date_header']}</H2>
                </Card>
            {:else}
                <Card>
                    <H2>{event_item.title}</H2>
                    <p>posted by {event_item.creator_name}</p>
                    {#if event_item.description}
                        <p>{event_item.description}</p>
                    {/if}
                    <p>{event_item['time_string']}</p>
                    {#if event_item.url}
                        <p><Link url={event_item.url}></Link></p>
                    {/if}

                </Card>
            {/if}


        {/each}
    </div>
</div>