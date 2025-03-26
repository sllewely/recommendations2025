<script lang="ts">
    import {enhance} from '$app/forms';
    import Card from '$lib/components/Card.svelte';
    import Link from '$lib/components/text/Link.svelte';
    import H2 from "$lib/components/text/H2.svelte";
    import PlusCircle from "$lib/components/posts/PlusCircle.svelte";
    import {current_user} from '$lib/state/current_user.svelte';

    let {feed_item} = $props();

    if (feed_item.class_name !== 'Event') {
        console.error("not a post feed item");
    }




    // let creating = $state(false);



</script>
<div>
    <div class="flex flex-row justify-between">
        <div><span class="font-bold"><Link url="/users/{feed_item.creator_id}">{feed_item.creator_name}</Link></span> posted an upcoming event</div>
        <div><span class="text-sm">at {feed_item.create_date_string} {feed_item.create_time_string}</span></div>
    </div>

<div>
    <div class="p-2">

        <a href="/events/{feed_item.id}">
        <Card border_color="border-lime-500" hover_color="hover:bg-yellow-100">


            <H2>{feed_item.title}</H2>
            {#if feed_item.description}
                <p>{feed_item.description}</p>
            {/if}
            {#if feed_item.start_date_string}
                <p>Happening {feed_item.start_date_string} - {feed_item.start_time_string}</p>
            {/if}
            {#if feed_item.address}
                <p>at {feed_item.address}</p>
            {/if}

        </Card>
        </a>
    </div>
</div>
</div>