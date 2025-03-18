<script lang="ts">
    import {enhance} from '$app/forms';
    import Card from '$lib/components/Card.svelte';
    import Link from '$lib/components/text/Link.svelte';
    import H2 from "$lib/components/text/H2.svelte";
    import PlusCircle from "$lib/components/posts/PlusCircle.svelte";
    import {current_user} from '$lib/state/current_user.svelte';

    let {feed_item} = $props();

    let by_line = ' is interested in';

    if (feed_item.class_name !== 'Recommendation') {
        console.error("not a recommendation feed item");
    }

    let border_color = "border-yellow-500";
    if (feed_item.status === 'watching') {
        by_line = ' is watching';
    } else if (feed_item.status === 'recommend') {
        by_line = ' recommends';
    }


    let creating = $state(false);



</script>
<div>
    {#if current_user.id !== feed_item.creator_id}
        <div class="float-right relative">
            <div class="absolute top-0 right-0">
                <form
                        method="POST"
                        action="?/add_recommendation"
                        use:enhance={() => {
            creating = true;
            return async ({update}) => {
                await update();
                creating = false;
            };
        }}
                >
                    <input type="hidden" name="title" value={feed_item.title} />
                    <input type="hidden" name="media_type" value={feed_item.media_type} />
                    <input type="hidden" name="who_recommended" value={feed_item.creator_name} />
                    <button type="submit">
                <PlusCircle />
                    </button>
                </form>
            </div></div>
        {/if}
    <div class="p-2">

        <a href="/recommendations/{feed_item.id}">
        <Card border_color={border_color} hover_color="hover:bg-yellow-100">

            <div class="flex flex-row justify-between pb-2">
                <div><span class="font-bold"><Link url="/users/{feed_item.creator_id}">{feed_item.creator_name}</Link></span> {by_line}</div>
                <div><span class="text-sm">at {feed_item.create_date_string} {feed_item.create_time_string}</span></div>
            </div>
            <p>{feed_item.media_type}</p>
            <H2>{feed_item.title}</H2>
            {#if feed_item.notes}
                <p>{feed_item.notes}</p>
            {/if}

        </Card>
        </a>
    </div>
</div>