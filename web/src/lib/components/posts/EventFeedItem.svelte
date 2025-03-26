<script lang="ts">
    import Card from "$lib/components/Card.svelte";
    import Link from "$lib/components/text/Link.svelte";
    import H2 from "$lib/components/text/H2.svelte";
    import EventCard from "$lib/components/posts/EventCard.svelte";

    let {event_item} = $props();

    // console.log(event_item.current_user_rsvp);
</script>

<div class="p-2">
    <div class="p-2 my-2 border-bottom-2 border-gray-600 rounded-lg shadow-md">

    <p>posted by <Link url="/users/{event_item.creator_id}">{event_item.creator_name}</Link></p>
        <a href="/events/{event_item.id}">

            <EventCard feed_item={event_item} />
        </a>
</div>
</div>