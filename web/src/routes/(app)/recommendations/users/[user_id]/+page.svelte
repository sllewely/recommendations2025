<script>
    import H1 from '$lib/components/text/H1.svelte';
    import H2 from '$lib/components/text/H2.svelte';
    import LinkButton from '$lib/components/text/LinkButton.svelte';
    import FeedItem from "$lib/components/posts/FeedItem.svelte";
    import DateHeader from "$lib/components/posts/DateHeader.svelte";
    import EventFeedItem from "$lib/components/posts/EventFeedItem.svelte";

    import {current_user} from '$lib/state/current_user.svelte.js';

    // import * as Table from "$lib/components/ui/table";

    let {data} = $props();

    const user = data.user;
    const recommendations = data.recommendations;

</script>

<div>
    <H1>{user.name}'s saved recommendations</H1>

    <p>Save the things you love, track what you want to enjoy next, share interests with your friends</p>

    <div>Create a new recommendation</div>

    <div>List of recommendations you've saved</div>

    <div>

    </div>

</div>