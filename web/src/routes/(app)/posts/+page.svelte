<script>
    import H1 from '$lib/components/text/H1.svelte';
    import H2 from '$lib/components/text/H2.svelte';
    import LinkButton from '$lib/components/text/LinkButton.svelte';
    import FeedItem from "$lib/components/posts/FeedItem.svelte";
    import DateHeader from "$lib/components/posts/DateHeader.svelte";
    import EventFeedItem from "$lib/components/posts/EventFeedItem.svelte";
    import Link from "$lib/components/text/Link.svelte";
    import {Button, buttonVariants} from "$lib/components/ui/button/index.js";
    import {CalendarPlus2, MessageCircleHeart, MessageSquareText} from '@lucide/svelte';

    let {data} = $props();

</script>

<div>
    <div class="flex justify-center bg-lime-200 border-1 border-gray-800 rounded-sm font-bold p-2 mb-2">
        <Link url="/friends">Add friends!!</Link>
    </div>


    <div class="grid grid-cols-3">
        <div class="col-span-2 flex flex-col">
            <H1>Posts</H1>

            <div class="flex justify-center pt-2 pb-2 space-x-2">
                <Button href="/posts/create" class={buttonVariants({ variant: "post" })}>
                    <MessageSquareText/> &nbsp;
                    New post
                </Button>
                <Button href="/recommendations/create" class={buttonVariants({ variant: "recommendation" })}>
                    <MessageCircleHeart/> &nbsp;
                    Share a recommendation
                </Button>
            </div>
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
        <div class="flex flex-col pl-2">
            <H1>Events</H1>

            <div class="flex justify-center pt-2 pb-2">
                <Button href="/events/create" class={buttonVariants({ variant: "event" })}>
                    <CalendarPlus2/> &nbsp;
                    Create event
                </Button>
            </div>
            {#if data.events.length === 0}
                <div class="flex justify-center bg-lime-200 border-1 border-gray-800 rounded-sm font-bold p-2 mb-2">
                    <p>
                        No upcoming events.
                        <Link url="/events/create">Create a new event</Link>
                    </p>

                </div>
            {/if}
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