<script lang="ts">
    import Card from "$lib/components/Card.svelte";
    import Link from "$lib/components/text/Link.svelte";
    import H2 from "$lib/components/text/H2.svelte";
    import EventCard from "$lib/components/posts/EventCard.svelte";

    let {event_item} = $props();

</script>

<div class="p-2">
    <div class="p-2 my-2 border-bottom-2 border-gray-600 rounded-lg shadow-md">

    <p>posted by <Link url="/users/{event_item.creator_id}">{event_item.creator_name}</Link></p>

        <div class="p-2">

                    <a href="/events/{event_item.id}">
            <Card border_color="border-lime-500" hover_color="hover:bg-lime-100">


                <H2>{event_item.title}</H2>
                {#if event_item.description}
                    <p>{event_item.description}</p>
                {/if}
                {#if event_item.start_date_string}
                    <p>Happening {event_item.start_date_string} - {event_item.start_time_string}</p>
                {/if}
                {#if event_item.address}
                    <p>at {event_item.address}</p>
                {/if}


                <p class="text-sm">rsvp: {event_item.current_user_rsvp ?? "not rsvp'd"}</p>
            </Card>
                    </a>
        </div>
</div>
</div>