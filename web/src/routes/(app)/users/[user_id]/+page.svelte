<script lang="ts">
    import H1 from '$lib/components/text/H1.svelte'
    import FeedItem from "../../posts/FeedItem.svelte";
    import H2 from "$lib/components/text/H2.svelte";

    let {data} = $props();
    let user = data.user;
    let posts = data.posts;

</script>
<H1>{user.name}</H1>
<p>Your friend, {user.name}, because presently everyone on the app is your friend</p>

<H1>Posts</H1>
<div class="col-span-2 flex flex-col">
    <H2>the feed</H2>
    {#each data.posts as feed_item}
        <FeedItem feed_item={feed_item} />

    {/each}

</div>