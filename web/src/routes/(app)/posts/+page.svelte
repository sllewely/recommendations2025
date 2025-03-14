<script>
    import H1 from '$lib/components/text/H1.svelte';
    import H2 from '$lib/components/text/H2.svelte';
    import Link from '$lib/components/text/Link.svelte';
    import LinkButton from '$lib/components/text/LinkButton.svelte';
    import Card from '$lib/components/Card.svelte'

    let { data } = $props();
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
    {#each data.posts as feed_item}
        <Card>
            {#if feed_item.status}
                <p>friend is {feed_item.status}...</p>
            {/if}
            <H2>{feed_item.title ?? feed_item.post_title}</H2>
            {#if feed_item.notes ?? feed_item.content}
                <p>{feed_item.notes ?? feed_item.content}</p>
            {/if}
        </Card>

    {/each}

</div>
</div>