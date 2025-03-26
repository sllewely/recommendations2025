<script lang="ts">
    import {enhance} from '$app/forms';
    import Card from '$lib/components/Card.svelte';
    import Link from '$lib/components/text/Link.svelte';
    import H2 from "$lib/components/text/H2.svelte";
    import PlusCircle from "$lib/components/posts/PlusCircle.svelte";
    import {current_user} from '$lib/state/current_user.svelte';

    let {feed_item} = $props();

    if (feed_item.class_name !== 'Post') {
        console.error("not a post feed item");
    }




    // let creating = $state(false);



</script>
<div>
    <div class="flex flex-row justify-between">
        <div><span class="font-bold"><Link url="/users/{feed_item.creator_id}">{feed_item.creator_name}</Link></span> posted</div>
        <div><span class="text-sm">at {feed_item.create_date_string} {feed_item.create_time_string}</span></div>
    </div>

<div>
    <div class="p-2">

        <a href="/posts/{feed_item.id}">
        <Card border_color="border-orange-500" hover_color="hover:bg-orange-100">


            <H2>{feed_item.post_title}</H2>
            {#if feed_item.content}
                <p>{feed_item.content}</p>
            {/if}

        </Card>
        </a>
    </div>
</div>
</div>