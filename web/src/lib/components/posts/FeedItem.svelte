<script lang="ts">
    import {enhance} from '$app/forms';
    import Link from '$lib/components/text/Link.svelte';
    import H2 from "$lib/components/text/H2.svelte";
    import RecommendationCard from "$lib/components/posts/RecommendationCard.svelte";
    import PostCard from "$lib/components/posts/PostCard.svelte";
    import EventCard from "$lib/components/posts/EventCard.svelte";

    import * as Collapsible from "$lib/components/ui/collapsible";
    import {Textarea} from "$lib/components/ui/textarea";
    import {Button} from "$lib/components/ui/button";
    import {MessageCircleMore} from '@lucide/svelte';

    import Comment from "$lib/components/posts/Comment.svelte";
    import SubmitComment from "$lib/components/posts/SubmitComment.svelte";

    let {feed_item} = $props();

    let by_line = ' posted';

    let border_color = "border-orange-500";
    if (feed_item.class_name === 'Event') {
        border_color = "border-blue-500";
        by_line = ' posted an upcoming event'
    } else {
        border_color = "border-orange-500";
    }

    let posting = $state(false);

    const num_comments = feed_item['comments']?.length;

    //TODO: Style the shadcn Button component to be a fun color!!


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

            <Link>
                <div class="flex">
                    {num_comments} Comments
                    <MessageCircleMore/>
                </div>

            </Link>
            <div>
                {#if feed_item.comments.length > 0}
                    <Comment comment={feed_item.comments[0]}/>
                {/if}
            </div>
        </Collapsible.Trigger>
        <Collapsible.Content>
            <div>
                <div>
                    {#each feed_item.comments.slice(1) as comment}
                        <Comment {comment}/>
                    {/each}
                </div>
                <SubmitComment {feed_item}/>
            </div>
        </Collapsible.Content>

    </Collapsible.Root>
</div>